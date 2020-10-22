//
//  GYProtocolViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/5/20.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

class GYProtocolViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func buttonClick(_ sender: Any) {
        label.text = MyStruct().method()
    }
    
}

struct MyStruct: MyProtocol {
    func method() -> String {
        print("called in Struct")
        return "called in Struct"
    }
}


protocol MyProtocol {
    func method() -> String
}

extension MyProtocol {
    func method() -> String {
        print("called")
        return "called"
    }
}
