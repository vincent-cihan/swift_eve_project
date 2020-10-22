//
//  GYModel.swift
//  EveProject
//
//  Created by lyons on 2019/1/30.
//  Copyright © 2019 lyons. All rights reserved.
//

import Foundation
import HandyJSON


//分页基类
class GYList: HandyJSON {
    var total: Int = 0
    var pageNum: Int = 0
    var totalPage: Int = 0
    var start: Int = 0
    var limit: Int = 0
    var pages: [Int]?
    
    required init() {}
}

extension Array: HandyJSON{}

//成功后返回的数据模型
struct GYResponseData<T: HandyJSON>: HandyJSON {
    var success: Int = 0
    var message:String?
    var data: T?
}

//成功后失败返回的数据模型
struct GYError: HandyJSON {
    var errorNum: Int = 0
    var errorArgs: Array<Any>?
    var errorMsg: String?
    var detail: String?
}
