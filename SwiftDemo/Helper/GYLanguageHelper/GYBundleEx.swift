//
//  GYBundleEx.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/13.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

class GYBundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = Bundle.getLanguageBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle {
    
    private static var onLanguageDispatchOnce: ()->Void = {
        //替换Bundle.main为自定义的BundleEx
        object_setClass(Bundle.main, GYBundleEx.self)
    }
    
    func onLanguage(){
        Bundle.onLanguageDispatchOnce()
    }
    
    class func getLanguageBundle() -> Bundle? {
        let lan = GYLanguageHelper.currentLanguage()
        //TODO:path传值???
        let languageBundlePath = Bundle.main.path(forResource: lan, ofType: "lproj")
        guard languageBundlePath != nil else {
            return nil
        }
        let languageBundle = Bundle.init(path: languageBundlePath!)
        guard languageBundle != nil else {
            return nil
        }
        return languageBundle!
    }
}
extension String {
    var localized: String {
        Bundle.main.onLanguage()
        return NSLocalizedString(self, comment: self)
    }
}
