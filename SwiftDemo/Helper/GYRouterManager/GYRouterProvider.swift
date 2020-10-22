//
//  GYRouterProvider.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/12.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

public typealias Complated = ([String : Any]) -> Void


public protocol RouterProviderType: AnyObject {
    associatedtype Target: ControllerConvertible
    func jump(from source: UIViewController?, to router: Target, with parameters: [String : Any], callBack handler: @escaping Complated)
}

public class GYRouterProvider<target: ControllerConvertible>: RouterProviderType {
    
    public let callback = "GYRouterProvider.callback"
    public init() {}
    public func jump(
        from source: UIViewController? = UIViewController.topWindowController(),
        to router: target,
        with parameters: [String : Any] = [:],
        callBack handler: @escaping Complated = { _ in }
        )
    {
        // 实例化目标对象
        let viewController = router.target.init()
        
        // 设置目标对象title
        if let title = router.title {
            viewController.title = title
        }
        
        // 配置目标对象需要参数
        if parameters.count > 0 {
            for (key, value) in parameters {
                viewController.putExtra(key, value)
            }
        }
        
        // 配置回调闭包
        viewController.putExtra(callback, handler)
        
        // 获取当前对象
        guard let windowController = source else {return}
        
        // 跳转逻辑
        DispatchQueue.main.async {
            
            switch router.method {
            case .push:
                guard let nav = windowController.navigationController else {
                    return
                }
                nav.pushViewController(viewController, animated: true)
                
            case .present(let parent):
                guard let parent = parent else {
                    windowController.present(viewController, animated: true)
                    return
                }
                let nav = parent.init(rootViewController: viewController)
                windowController.present(nav, animated: true)
            }
        }
    }
}
