//
//  GYGradualView.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/11.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import SnapKit

class GYGradualView: UIView{
    /// headView高度
    let headHeight:CGFloat = 200
    /// sectionHeader高度
    let sectionHeaderHeight:CGFloat = 44
    
    var tableView: UITableView!
    var headView: UIView!
    var sectionHeader: UIView!
    var bgImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    //xib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    override func awakeFromNib() {
        
    }
    //调整子View的大小
    override func layoutSubviews() {
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension GYGradualView {
    func setupSubviews() {
        tableView = UITableView.init()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }else{
            parentVC()!.automaticallyAdjustsScrollViewInsets = false
        }
        autoresizesSubviews = true
        
        let height = headHeight+sectionHeaderHeight
        tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint.init(x: 0, y: -height), animated:false)
        tableView.addObserver(self, forKeyPath: "contentOffset", options: [.new,.old], context: nil)
        addSubview(tableView)

        headView = UIView.init()
        headView.backgroundColor = UIColor.lightGray
        headView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight,UIView.AutoresizingMask.flexibleWidth]
        addSubview(headView)
        
        bgImageView = UIImageView.init()
        bgImageView.setGaussianBlurImage(with: URL(string: "https://i7.wenshen520.com/c/42.jpg"), blurNumber:0)
        bgImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight,UIView.AutoresizingMask.flexibleWidth]
        headView.addSubview(bgImageView)
        
        sectionHeader = UIView.init()
        sectionHeader.backgroundColor = UIColor.gray
        sectionHeader.autoresizingMask = UIView.AutoresizingMask.flexibleTopMargin
        addSubview(sectionHeader)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        headView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(headHeight)
            make.width.equalTo(GYScreenWidth)
        }
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.top).offset(0)
            make.left.equalTo(headView.snp.left).offset(0)
            make.right.equalTo(headView.snp.right).offset(0)
            make.bottom.equalTo(headView.snp.bottom).offset(0)
        }
        sectionHeader.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(sectionHeaderHeight)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offset = tableView.contentOffset.y + (headHeight + sectionHeaderHeight)
        var imgH = headHeight - offset
        
        if (imgH < statusAndNaviH) {
            imgH = statusAndNaviH
        }
//        print(tableView.contentOffset.y)
        
        let w = imgH*GYScreenWidth/headHeight
        
        headView.snp.updateConstraints { (make) in
            make.width.equalTo(w<GYScreenWidth ? GYScreenWidth:w)
            make.height.equalTo(imgH)
        }
        bgImageView.snp.updateConstraints { (make) in
            make.top.equalTo(headView.snp.top).offset(0)
            make.left.equalTo(headView.snp.left).offset(0)
            make.right.equalTo(headView.snp.right).offset(0)
            make.bottom.equalTo(headView.snp.bottom).offset(0)
        }
        sectionHeader.snp.updateConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(0)
        }
        
        //根据透明度来生成图片
        //找最大值
        var alpha  = offset * 1 / 136.0   // (200 - 64) / 136.0f
        if (alpha >= 1) {
            alpha = 0.99
        }else if(alpha<0){
            alpha = 0
        }
        //print(alpha)
        bgImageView.setGaussianBlurImage(with: URL(string: "https://i7.wenshen520.com/c/42.jpg"), blurNumber:Float(alpha))
        
        //拿到标题 标题文字的随着移动高度的变化而变化
        if (parentVC() != nil) {
            let titleL = parentVC()!.navigationItem.titleView as! UILabel
            titleL.textColor = UIColor.init(white: 1, alpha: alpha)
        }
        //把颜色生成图片
        //        let alphaColor = UIColor.init(white: 1, alpha: alpha)
        //把颜色生成图片
        //        let alphaImage = UIImage.imageWithColor(color: alphaColor)
        //修改导航条背景图片
        //        navigationController?.navigationBar.setBackgroundImage(alphaImage, for: UIBarMetrics.default)
    }
    /// 获取父级ViewController
    ///
    /// - Returns: 父级ViewController
    func parentVC() -> UIViewController? {
        var n = self.next
        while n != nil {
            if (n is UIViewController) {
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }
}
