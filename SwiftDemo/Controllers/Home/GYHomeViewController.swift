//
//  GYHomeViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/1/31.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import Kingfisher
import Accelerate

class GYHomeViewController: GYRootViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "cell"
    var list: Array<Router> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //不想在 tabbarItem 上显示 title 就使用 navigationItem 的方法
        navigationItem.title = "首页".localized
        
        setNaviBarItem()
        list = [Router.gaussianBlur,Router.gradualNavi,Router.notification,Router.protocolVC,Router.webViewVC]
        // 4.注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.title = GYLanguageHelper.currentLanName().localized
    }
}

extension GYHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func setNaviBarItem() {
        // 在右侧添加一个按钮
        let barButtonItem = UIBarButtonItem(title: GYLanguageHelper.currentLanName().localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(change))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    @objc func change(){
        Page.jump(from: self, to: Router(rawValue: Router.languages.rawValue)!, with: [:]) { (params) in
            print(params)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        let className = list[indexPath.row]
        cell?.textLabel?.text = className.title
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let className = list[indexPath.row]
        guard type(of: className) == Router.self else {
            return
        }
        if(className.rawValue == "GYWebViewViewController"){
            let alertController = UIAlertController(title: "输入url",
                                                    message: "", preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "url"
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let url = alertController.textFields!.first!
                Page.jump(from: self, to: className, with: ["status" : "ON", "url" : url.text!]) { (params) in
                    print(params)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        Page.jump(from: self, to: className, with: ["status" : "ON"]) { (params) in
            print(params)
        }
    }
}

