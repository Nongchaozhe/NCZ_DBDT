//
//  NCZButton.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/18.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit

class NCZButton: UIButton {
    var isPlay:Bool = true
    
    let imgPlay:UIImage = UIImage(named: "play")!
    let imgPause:UIImage = UIImage(named: "pause")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onClick() {
        isPlay = !isPlay
        if isPlay {
            self.setImage(imgPause, forState: UIControlState.Normal)
        }else {
            self.setImage(imgPlay, forState: UIControlState.Normal)
        }
    }
    func onPlay() {
        isPlay = true
        self.setImage(imgPause, forState: UIControlState.Normal)
    }
}
