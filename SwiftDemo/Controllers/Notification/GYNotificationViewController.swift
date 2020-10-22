//
//  GYNotificationViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/26.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import UserNotifications

class GYNotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "cell"
    var list: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        list = ["本地通知"]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

}

extension GYNotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = "\(list[indexPath.row].localized)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            if #available(iOS 10.0, *) {
                //iOS 10以后
                registNotification(alertTime: 3)
            } else {
                //iOS 10之前
                let notification = UILocalNotification.init()
                notification.alertBody = "测试本地推送"
                notification.applicationIconBadgeNumber = 1
                UIApplication.shared.presentLocalNotificationNow(notification)
            }
            break
        default: break
            
        }
    }
    @available(iOS 10.0, *)
    func registNotification(alertTime:NSInteger) {
        let content = UNMutableNotificationContent.content(title: "测试 title", subtitle: "测试 subtitle", body: "测试 body", identifier: "FiveSecond", sound: UNNotificationSound.default)
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(alertTime), repeats: false)
        GYNotificationHelper.push(content: content, trigger: trigger) { (error) in
            if error == nil {
                print("Time Interval Notification scheduled: FiveSecond")
            }
        }
    }
}
