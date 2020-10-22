//
//  GYRootTabBarController.swift
//  EveProject
//
//  Created by lyons on 2018/12/29.
//  Copyright © 2018 lyons. All rights reserved.
//

import UIKit

class GYRootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.isTranslucent = false  //避免受默认的半透明色影响，关闭
//        self.tabBar.tintColor = UIColor.red //设置选中颜色，这里使用黄色
        
        creatSubViewControllers()
    }
    
    func creatSubViewControllers(){
        let v1  = GYHomeViewController ()
        let item1 : UITabBarItem = UITabBarItem (title: "", image: UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "home_1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        v1.tabBarItem = item1
        
        let v2 = GYMineViewController()
        let item2 : UITabBarItem = UITabBarItem (title: "", image: UIImage(named: "me")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "me_1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        v2.tabBarItem = item2

        let n1 = GYRootNavigationController.init(rootViewController: v1)
        let n2 = GYRootNavigationController.init(rootViewController: v2)
        
        let tabArray = [n1, n2]
        self.viewControllers = tabArray
    }
}
