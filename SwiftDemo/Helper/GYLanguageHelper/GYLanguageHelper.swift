//
//  GYLanguageHelper.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/13.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

let GYLanguageKey = "GYLanguageKey"

enum language:String {
    case system = ""
    case en = "en"
    case zh = "zh-Hans"
    case zhHK = "zh-HK"
    case ja = "ja"
}

///  languageType 语言协议
public protocol languageType {
    // 目标类标题
    var title: String {get}
}

extension language: languageType {
    var title: String {
        switch self {
        case .en:
            return "English"
        case .ja:
            return "日本語"
        case .zh:
            return "简体中文"
        case .zhHK:
            return "繁体中文（香港）"
        default:
            return "系统语言"
        }
    }
}

class GYLanguageHelper {
    static func setUserLanguage (userLanguage:String){
        //跟随手机系统
        guard userLanguage.count>0 else {
            resetSystemLanguage()
            return
        }
        UserDefaults.standard.set(userLanguage, forKey: GYLanguageKey)
        UserDefaults.standard.set([userLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    static func initSystemLanguage() {
        let userLanguage = UserDefaults.standard.value(forKey: GYLanguageKey)
        guard userLanguage == nil else {
            UserDefaults.standard.set([(userLanguage as! String)], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            return
        }
        UserDefaults.standard.set(nil, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    static func resetSystemLanguage() {
        UserDefaults.standard.removeObject(forKey: GYLanguageKey)
        UserDefaults.standard.set(nil, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    static func currentLanName() -> String {
        if let userLanguage = UserDefaults.standard.value(forKey: GYLanguageKey) {
            return language(rawValue: (userLanguage as! String))!.title
        }
        return "系统语言"
    }
    static func currentLanguage() -> String? {
        let userLanguage = UserDefaults.standard.value(forKey: GYLanguageKey)
        guard userLanguage == nil else {
            return (userLanguage as! String)
        }
        return Locale.preferredLanguages.first
    }
}

extension String {
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    func gySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func gySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}


