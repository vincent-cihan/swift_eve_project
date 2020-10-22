//
//  AppDelegate.swift
//  EveProject
//
//  Created by lyons on 2018/12/29.
//  Copyright © 2018 lyons. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

let GYScreenWidth = UIScreen.main.bounds.size.width
let GYScreenHeigth = UIScreen.main.bounds.size.height
let DominantColor = UIColor.init(red: 239/255.0, green: 80/255.0, blue: 88/255.0, alpha: 1)

/// Hud样式
func setHudStyle() {
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    SVProgressHUD.setMaximumDismissTimeInterval(1.5)
}
