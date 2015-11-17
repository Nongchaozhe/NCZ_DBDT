//
//  ChannelViewController.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/17.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet var channelList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = channelList.dequeueReusableCellWithIdentifier("channel")!
        //设置cell标题
        cell.textLabel?.text = "标题：\(indexPath.row)"
        return cell
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
