//
//  NCZImage.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/17.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit

class NCZImage: UIImageView {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        
        //设置圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
        
        //边框
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor

    }
    func onRotation() {
        //动画实例关键字
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //初始值
        animation.fromValue = 0
        //结束值
        animation.toValue = M_PI*2.0
        //动画时间
        animation.duration = 20
        //重复次数尽可能大
        animation.repeatCount = 10000
        self.layer.addAnimation(animation, forKey: nil)
    }
    
}
