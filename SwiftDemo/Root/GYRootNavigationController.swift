//
//  GYRootNavigationController.swift
//  EveProject
//
//  Created by lyons on 2018/12/29.
//  Copyright © 2018 lyons. All rights reserved.
//

import UIKit

class GYRootNavigationController: UINavigationController, UINavigationBarDelegate {
    // 实现navigationBar(_: shouldPop:)
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        var shouldPop = true
        
        // 已修改（标记1）
        let viewControllersCount = self.viewControllers.count
        let navigationItemsCount = navigationBar.items?.count
        
        if(viewControllersCount < navigationItemsCount!){
            return shouldPop
        }
        if let topViewController: UIViewController = self.topViewController {
            if(topViewController is NavigationControllerBackButtonDelegate){
                let delegate = topViewController as! NavigationControllerBackButtonDelegate
                shouldPop = delegate.shouldPopOnBackButtonPress()
            }
        }
        if(shouldPop == false){
            isNavigationBarHidden = true
            isNavigationBarHidden = false
        }else{
            if(viewControllersCount >= navigationItemsCount!){
                DispatchQueue.main.async { () -> Void in
                    self.popViewController(animated: true)
                }
            }
        }
        return shouldPop
    }
}

extension GYRootNavigationController
{
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        //设置如果跳转页面不为第一页，隐藏tabbar
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// 定义一个protocol，实现它的类，自定义pop规则、逻辑或方法
protocol NavigationControllerBackButtonDelegate {
    func shouldPopOnBackButtonPress() -> Bool
}
