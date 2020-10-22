//
//  GYGradualNaviViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/8.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import SnapKit

class GYGradualNaviViewController: GYRootViewController {
    let cellID = "cell"
    var gradualView:GYGradualView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setCustomVeiw()
    }
}

extension GYGradualNaviViewController: UITableViewDataSource, UITableViewDelegate {
    func setNavigation() {
        // 设置导航栏的背景
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        // 取消掉底部的那根线
        navigationController?.navigationBar.shadowImage = UIImage.init()
        
        // 设置标题
        let titleLabel = UILabel.init()
        titleLabel.text = "动态导航".localized
        titleLabel.sizeToFit()
        // 开始的时候看不见，所以alpha值为0
        titleLabel.textColor = UIColor.init(white: 0, alpha: 0)
        navigationItem.titleView = titleLabel
    }
    func setCustomVeiw(){
        gradualView = GYGradualView.init()
        // 4.注册cell
        gradualView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        gradualView.tableView.delegate = self
        gradualView.tableView.dataSource = self
        view.addSubview(gradualView)
        gradualView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}
