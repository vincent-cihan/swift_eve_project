//
//  GYViewLayer.swift
//  SwiftDemo
//
//  Created by lyons on 2019/2/1.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit


/// 方向
///
/// - top: 上
/// - left: 下
/// - bottom: 左
/// - right: 右
enum Direction {
    case top
    case left
    case bottom
    case right
}

extension UIView {
    
    /// 尺寸
    var gy_size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }
    
    /// 宽度
    var gy_w: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            frame.size.width = newValue
        }
    }
    
    /// 高度
    var gy_h: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            frame.size.height = newValue
        }
    }
    
    /// 横坐标
    var gy_x: CGFloat {
        get {
            return frame.minX
        }
        set(newValue) {
            frame = CGRect(x: newValue, y: gy_y, width: gy_w, height: gy_h)
        }
    }
    
    /// 纵坐标
    var gy_y: CGFloat {
        get {
            return frame.minY
        }
        set(newValue) {
            frame = CGRect(x: gy_x, y: newValue, width: gy_w, height: gy_h)
        }
    }
    
    /// 上端坐标
    var gy_top: CGFloat {
        get {
            return frame.minY
        }
        set(newValue) {
            frame = CGRect(x: gy_x, y: newValue, width: gy_w, height: gy_h)
        }
    }
    
    /// 左边坐标
    var gy_left: CGFloat {
        get {
            return frame.minX
        }
        set(newValue) {
            frame = CGRect(x: newValue, y: gy_y, width: gy_w, height: gy_h)
        }
    }
    
    /// 右端横坐标
    var gy_right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(newValue) {
            frame.origin.x = UIScreen.main.bounds.size.width - newValue - frame.size.width
        }
    }
    
    /// 底端纵坐标
    var gy_bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set(newValue) {
            frame.origin.y = UIScreen.main.bounds.size.height - newValue - frame.size.height
        }
    }
    
    /// 中心横坐标
    var gy_centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            center.x = newValue
        }
    }
    
    /// 中心纵坐标
    var gy_centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            center.y = newValue
        }
    }
    
    /// 原点
    var gy_origin: CGPoint {
        get {
            return frame.origin
        }
        set(newValue) {
            frame.origin = newValue
        }
    }
    
    /// 右上角坐标
    var gy_topRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - gy_w, y: newValue.y)
        }
    }
    
    /// 右下角坐标
    var gy_bottomRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - gy_w, y: newValue.y - gy_h)
        }
    }
    
    /// 左下角坐标
    var gy_bottomLeft: CGPoint {
        get {
            return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x, y: newValue.y - gy_h)
        }
    }
    
    /// 获取UIView对象某个方向缩进指定距离后的方形区域
    ///
    /// - Parameters:
    ///   - direction: 要缩进的方向
    ///   - distance: 缩进的距离
    /// - Returns: 得到的区域
    func gy_cutRect(direction: Direction, distance: CGFloat) ->  CGRect {
        switch direction {
        case .top:
            return CGRect(x: 0, y: distance, width: gy_w, height: gy_h - distance)
        case .left:
            return CGRect(x: distance, y: 0, width: gy_w - distance, height: gy_h)
        case .right:
            return CGRect(x: 0, y: 0, width: gy_w - distance, height: gy_h)
        case .bottom:
            return CGRect(x: 0, y: 0, width: gy_w, height: gy_h - distance)
        }
    }
}

