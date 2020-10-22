//
//  GYNotificationHelper.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/26.
//  Copyright © 2019 lyons. All rights reserved.
//

import Foundation
import UserNotifications

class GYNotificationHelper {
    static func initSystemLanguage(appDelegate: AppDelegate){
        //注册通知
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = appDelegate
            center.requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.sound]) { (granted, error) in
                if error == nil {
                    print("注册成功")
                }
            }
            center.getNotificationSettings { (settings) in
                print("\(settings)")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    @available(iOS 10.0, *)
    static func push(content:UNMutableNotificationContent,trigger:UNTimeIntervalNotificationTrigger,withCompletionHandler completionHandler: ((Error?) -> Void)? = nil) {
        let request = UNNotificationRequest.init(identifier: content.categoryIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completionHandler)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(UNNotificationPresentationOptions.alert)
    }
}

@available(iOS 10.0, *)
extension UNMutableNotificationContent {
    public static func content(title:String? = nil,
                               subtitle:String? = nil,
                               body:String? = nil,
                               identifier:String? = nil,
                               sound:UNNotificationSound? = nil) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title ?? "", arguments: nil)
        content.subtitle = NSString.localizedUserNotificationString(forKey: subtitle ?? "", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body ?? "", arguments: nil)
        content.categoryIdentifier = identifier ?? "defaultIdentifier"
        content.sound = sound ?? UNNotificationSound.default
        return content
    }
}
