//
//  ViewController.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/17.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //背景
    @IBOutlet var bgImage: UIImageView!
    //第二背景-旋转
    @IBOutlet var bgRotationImage: NCZImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgRotationImage.onRotation()
        
        //设置背景的模糊效果
        //创建模糊效果
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        //创建效果视图存放模糊效果
        let blurView = UIVisualEffectView(effect: blurEffect)
        //创建模糊效果视图尺寸
        blurView.frame.size = CGSizeMake(view.frame.width, view.frame.height)
        //添加到背景中
        bgImage.addSubview(blurView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

