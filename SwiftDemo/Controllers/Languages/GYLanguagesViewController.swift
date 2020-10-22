//
//  GYLanguagesViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/13.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

class GYLanguagesViewController: GYRootViewController {
    let cellID = "tableViewCell"
    var list: Array<language> = [language.system,language.en,language.zh,language.zhHK,language.ja]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
}

extension GYLanguagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        let language = list[indexPath.row]
        cell?.textLabel?.text = language.title.localized
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lan = list[indexPath.row]
        chooseLanguage(lan: lan)
    }
    func chooseLanguage(lan:language) {
        GYLanguageHelper.setUserLanguage(userLanguage: lan.rawValue)
        let tbc = GYRootTabBarController()
        tbc.selectedIndex = 0
        let nvc:UINavigationController = tbc.selectedViewController as! UINavigationController
        var vcs:Array = nvc.viewControllers
        let vc:GYLanguagesViewController = GYLanguagesViewController.init(nibName: "GYLanguagesViewController", bundle: nil)
        vc.title = Router.languages.title
        vc.hidesBottomBarWhenPushed = true
        vcs.append(vc)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = tbc
            nvc.viewControllers = vcs
        }
//        DispatchQueue.global().async {
//            let sheet = UIAlertController.init(title: "是否切换语言", message: nil, preferredStyle: .alert)
//            sheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
//            sheet.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
//                UIApplication.shared.keyWindow?.rootViewController = GYRootTabBarController()
//                UIApplication.shared.keyWindow?.alpha = 0
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
//                    UIView.animate(withDuration: 0.6, animations: {
//                        UIApplication.shared.keyWindow?.alpha = 1
//                    })
//                })
//            }))
//            self.present(sheet, animated: true, completion: nil)
//        }
    }
}
