//
//  GYApi.swift
//  EveProject
//
//  Created by lyons on 2019/1/30.
//  Copyright © 2019 lyons. All rights reserved.
//

import Foundation
import HandyJSON
import Moya

enum GYApi {
    case easyRequset
    case functionList//功能总表
    case robotList
    case robotDetail(uuid: String)
    case registerUser(user: Dictionary<String,Any>, pepperUserDetail: Dictionary<String,Any>)
}

extension GYApi: TargetType {
    var baseURL: URL {
        #if DEBUG
        switch self {
        case .easyRequset:
            return URL(string:"http://api.robot.nplus5.com")!
        default:
            return URL(string:(Moya_baseURL_dev))!
        }
        #else
        switch self {
        case .easyRequset:
            return URL(string:"http://api.robot.nplus5.com")!
        default:
            return URL(string:(Moya_baseURL))!
        }
        #endif
    }
    
    var method: Moya.Method {
        
        switch self {
        case .functionList, .robotList, .robotDetail:
            return .get
        case .registerUser:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .functionList:
            return "/api/functiontotal/"
        case .robotList:
            return "/api/robot/"
        case .robotDetail(let uuid):
            return "/api/robot/\(uuid)/detail/"
        case .registerUser:
            return "/api/register/user"
        case .easyRequset:
            return ""
        }
    }
    
    /// 单元测试数据
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .functionList, .robotList, .robotDetail:
            return .requestPlain
        case let .registerUser(user, pepperUserDetail):
            return .requestParameters(parameters: ["user": user, "pepperUserDetail":pepperUserDetail], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Accept":"application/json"]
    }
}



