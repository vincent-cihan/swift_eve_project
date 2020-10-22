//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by lyons on 2019/1/31.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        //Swift:
        // for iOS
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle")?.load()
        //for tvOS:
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/tvOSInjection10.bundle")?.load()
        //Or for macOS:
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection10.bundle")?.load()
        #endif
        
        //注册通知
        GYNotificationHelper.initSystemLanguage(appDelegate: self)
        
        //初始化语言
//        GYLanguageHelper.initSystemLanguage()
        
        //设置 HUD 的样式
        setHudStyle()
        let screen = UIScreen.main.bounds        //获得设备尺寸
        self.window = UIWindow.init(frame: screen)    //给“输出窗口“实例化并设置frame
        let root = GYRootTabBarController()
        self.window?.rootViewController = root //将“输出窗口”的根视图设置为tab
        self.window?.makeKeyAndVisible() //  设置"输出窗口可见"
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
