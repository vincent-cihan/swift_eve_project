//
//  GYGaussianBlurViewController.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/8.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import AVFoundation

class GYGaussianBlurViewController: GYRootViewController {
    private var callback: Complated!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callback = getExtra(Page.callback)!
        imageView.setGaussianBlurImage(with: URL(string: "https://i7.wenshen520.com/c/42.jpg"), blurNumber: slider.value)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        callback(["name": "lyons"])
    }
    @IBAction func sliderChange(_ sender: UISlider) {
        imageView.setGaussianBlurImage(with: URL(string: "https://i7.wenshen520.com/c/42.jpg"), blurNumber: sender.value)
    }
}

