//
//  GYNetWorkTool.swift
//  EveProject
//
//  Created by lyons on 2019/1/31.
//  Copyright © 2019 lyons. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import HandyJSON
import SVProgressHUD

/// 超时时长
private var requestTimeOut:Double = 30
///成功数据的回调
typealias successCallback<T: HandyJSON> = ((T?) -> (Void))
///失败的回调
typealias failedCallback = ((GYError?) -> (Void))
///网络错误的回调
typealias errorCallback = (() -> (Void))


///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: GYApi) -> Endpoint in
    ///这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
    //        let additionalParameters = ["token":"888888"]
    //        let defaultEncoding = URLEncoding.default
    //        switch target.task {
    //            ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    //        case .requestPlain:
    //            task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    //        case .requestParameters(var parameters, let encoding):
    //            additionalParameters.forEach { parameters[$0.key] = $0.value }
    //            task = .requestParameters(parameters: parameters, encoding: encoding)
    //        default:
    //            break
    //        }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */
    
    
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30//每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    switch target {
    case .easyRequset:
        return endpoint
    default:
        return endpoint
    }
}

///网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
//}


/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
///但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
    case .began:
        print("开始请求网络")
        
    case .ended:
        print("结束")
    }
}

// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
//stubClosure   用来延时发送网络请求


////网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider<GYApi>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)



/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func NetWorkRequest<T: HandyJSON>(_ target: GYApi,model: T.Type, completion: @escaping successCallback<T> ){
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        print("提示用户网络似乎出现了问题")
        return
    }
    //这里显示loading图
    SVProgressHUD.show()
    Provider.request(target) { (result) in
        //隐藏hud
        SVProgressHUD.dismiss()
        switch result {
        case let .success(response):
            //这里的completion和failed判断条件依据不同项目来做
            guard response.statusCode == 200  else {
                let errorStr = String(data: response.data, encoding: .utf8)
                let error = JSONDeserializer<GYError>.deserializeFrom(json: errorStr) ?? GYError()
                SVProgressHUD.showError(withStatus:error.errorMsg)
                return
            }
            guard let returnData = try? result.value?.mapModel(GYResponseData<T>.self) else {
                completion(T())
                return
            }
            completion(returnData?.data)
        case let .failure(error):
            print("网络连接失败:\(error)")
            SVProgressHUD.showError(withStatus:"网络连接失败:\(error)")
        }
    }
}


/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failed: 请求失败的回调
func NetWorkRequest<T: HandyJSON>(_ target: GYApi,model: T.Type, completion: @escaping successCallback<T> , failed:failedCallback?) {
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        print("提示用户网络似乎出现了问题")
        return
    }
    //这里显示loading图
    SVProgressHUD.show()
    Provider.request(target) { (result) in
        //隐藏hud
        SVProgressHUD.dismiss()
        switch result {
        case let .success(response):
            //这里的completion和failed判断条件依据不同项目来做
            guard response.statusCode == 200  else {
                let errorStr = String(data: response.data, encoding: .utf8)
                let error = JSONDeserializer<GYError>.deserializeFrom(json: errorStr) ?? GYError()
                failed!(error)
                return
            }
            guard let returnData = try? result.value?.mapModel(GYResponseData<T>.self) else {
                completion(T())
                return
            }
            completion(returnData?.data)
        case let .failure(error):
            print("网络连接失败:\(error)")
            SVProgressHUD.showError(withStatus:"网络连接失败:\(error)")
        }
    }
}


///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
func NetWorkRequest<T: HandyJSON>(_ target: GYApi, model: T.Type, completion: @escaping successCallback<    T> , failed:failedCallback?, errorResult:errorCallback?) {
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        print("提示用户网络似乎出现了问题")
        return
    }
    //这里显示loading图
    SVProgressHUD.show()
    Provider.request(target) { (result) in
        //隐藏hud
        SVProgressHUD.dismiss()
        switch result {
        case let .success(response):
            //这里的completion和failed判断条件依据不同项目来做
            guard response.statusCode == 200  else {
                let errorStr = String(data: response.data, encoding: .utf8)
                let error = JSONDeserializer<GYError>.deserializeFrom(json: errorStr) ?? GYError()
                failed!(error)
                return
            }
            guard let returnData = try? result.value?.mapModel(GYResponseData<T>.self) else {
                completion(T())
                return
            }
            completion(returnData?.data)
        case let .failure(error):
            print("网络连接失败:\(error)")
            if errorResult != nil {
                errorResult!()
            }
        }
    }
}

/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}

/*
/// Demo中并未使用，以后如果有数组转json可以用这个。
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let json = parameters?["jsonArray"] else {
            return request
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data
        
        return request
    }
}
*/

//给 Response 增加了json 格式化方法
extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}
