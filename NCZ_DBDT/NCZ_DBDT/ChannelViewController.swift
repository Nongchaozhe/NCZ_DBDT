//
//  ChannelViewController.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/17.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChannelViewController: UIViewController,UITableViewDelegate {

    @IBOutlet var channelList: UITableView!
    
    //申明代理
    var delegate:ChannelProtocol?
    //频道列表数据
    var channelData:[JSON] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.8
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = channelList.dequeueReusableCellWithIdentifier("channel")!
     
        let data:JSON = self.channelData[indexPath.row]
        
        //设置cell标题
        cell.textLabel?.text = data["name"].string
        return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //获取行数
        let rowData:JSON = self.channelData[indexPath.row] as JSON
        //设置选中id
        let channelID:String = rowData["channel_id"].stringValue
        //将频道id反向传给主界面
        delegate?.onChangeChannel(channelID)
        //关闭当前界面
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

protocol ChannelProtocol {
    //回调方法，将频道id传回到代理中
    func onChangeChannel(channelID:String)

}






