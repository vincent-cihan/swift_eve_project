//
//  GYWebViewViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/5/29.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import WebKit

class GYWebViewViewController: UIViewController {
    private var callback: Complated!
    var webView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callback = getExtra(Page.callback)!
        let url:String = getExtra("url") ?? ""
        
        
        let config = WKWebViewConfiguration()
        // 設置偏好設置
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        config.userContentController = WKUserContentController()
        //注意在這裏注入JS對象名稱 "JSObject"
        config.userContentController.add(self, name: "toOutWebView")

        
        webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: GYScreenWidth, height: GYScreenHeigth), configuration: config)
        view.addSubview(webView!)
        webView?.navigationDelegate = self
        webView?.loadUrl(url)
        webView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        webView?.evaluateJavaScript("toOutWebView()", completionHandler: { (any, error) in
//            if (error != nil) {
//                print(error.debugDescription)
//            }
//        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        //这个方法防止内存泄漏，写在合适的位置即可
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: "toOutWebView")
    }
}

extension WKWebView {
    open func loadUrl(_ url: String) {
        guard url.count > 0 else {
            return
        }
        let url = URL.init(string: url)!
        let request = URLRequest.init(url: url)
        load(request)
    }
}

extension GYWebViewViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

extension GYWebViewViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "toOutWebView") {
            print(message.body)
            let json:Dictionary<String, Any> = message.body as! Dictionary<String, String>
            let url:URL = URL.init(string: json["url"] as! String)!
            
            UIApplication.shared.open(url, options: [:]) { (make) in
                
            }
            
        }
    }
}
extension GYWebViewViewController: NavigationControllerBackButtonDelegate {
    func shouldPopOnBackButtonPress() -> Bool {
        guard webView!.canGoBack else {
            return true
        }
        webView?.goBack()
        return false
    }
}
