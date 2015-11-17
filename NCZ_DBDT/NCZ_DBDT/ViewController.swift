//
//  ViewController.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/17.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //背景
    @IBOutlet var bgImage: UIImageView!
    //第二背景-旋转
    @IBOutlet var bgRotationImage: NCZImage!
    //歌曲列表
    @IBOutlet var songList: UITableView!
    
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
        
        
        songList.dataSource = self
        songList.delegate   = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    //tableView代理所需要实现的两个方法
//    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
//    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = songList.dequeueReusableCellWithIdentifier("douban")!
        //设置cell标题
        cell.textLabel?.text = "标题：\(indexPath.row)"
        cell.detailTextLabel?.text = "子标题：\(indexPath.row)"
        //设置缩略图
        cell.imageView?.image = UIImage(named: "thumb")
        return cell
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

