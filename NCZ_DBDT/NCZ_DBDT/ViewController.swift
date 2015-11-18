//
//  ViewController.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/17.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol,ChannelProtocol {
    //背景
    @IBOutlet var bgImage: UIImageView!
    //第二背景-旋转
    @IBOutlet var bgRotationImage: NCZImage!
    //歌曲列表
    @IBOutlet var songList: UITableView!
    
    //网络操作类的实例
    var zHTTP:HttpController = HttpController()
    
    //网络数据接收
    var songListData:[JSON] = []
    //频道选择接收
    var channelListData:[JSON] = []
    
    //图片缓存的字典
    var imageCache = Dictionary<String,UIImage>()
    
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
        
        
        
        //网络操作类设置代理
        zHTTP.delegate = self
        //获取频道数据
        zHTTP.onSearch("http://www.douban.com/j/app/radio/channels")
        //获取频道为0歌曲数据
        zHTTP.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")


        songList.dataSource = self
        songList.delegate   = self
        songList.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //tableView代理所需要实现的两个方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songListData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = songList.dequeueReusableCellWithIdentifier("douban")!
        cell.backgroundColor = UIColor.clearColor()
        //获取cell数据
        let data:JSON = songListData[indexPath.row]
        
        //设置cell标题
        cell.textLabel?.text = data["title"].string
        cell.detailTextLabel?.text = data["artist"].string

        //设置缩略图
        cell.imageView?.image = UIImage(named: "thumb")
        cell.imageView?.sizeToFit()
        let url = data["picture"].string
        print(url)
//        Alamofire.request(Method.GET, url!).response { (_, _, data, error) -> Void in
//            let img = UIImage(data: data!)
//            cell.imageView?.image = img
//        }        
        onGetCacheImage(url!, imgView: cell.imageView!)
        
        
        return cell
        
    }

    //HttpProtocol需要实现的方法
    func didReceivedResults(results:AnyObject) {
        print("\(results)")
        
        let json = JSON(results)
        if let channels = json["channels"].array {
            self.channelListData = channels
        }else if let song = json["song"].array {
            self.songListData = song
            print(song)

            self.songList.reloadData()
            
            //本来是多行的。第一次显示第一行的背景。但是跟教程不同的是，返回的内容只有一首歌
            onSelectRow(0)
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //获取跳转目标
        let channelC:ChannelViewController = segue.destinationViewController as! ChannelViewController
        //设置代理
        channelC.delegate = self
        //传输频道列表数据
        channelC.channelData = self.channelListData
        
    }
    
    
    //频道协议的回调方法
    func onChangeChannel(channelID:String) {
        //拼凑频道列表的歌曲数据网络地址
//        http://douban.fm/j/mine/playlist?type=n&channel= 频道id &from=mainsite
        let url:String = "http://douban.fm/j/mine/playlist?type=n&channel=\(channelID)&from=mainsite"
        zHTTP.onSearch(url)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        onSelectRow(indexPath.row)
    }
    
    //选中哪一行
    func onSelectRow(index:Int) {
        //构建indexpath
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        //选中效果
        songList.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        //获取行数据
        let rowData:JSON = self.songListData[index] as JSON
        //获取地址
        let imageUrl = rowData["picture"].string
        //设置封面及背景
        onSetImage(imageUrl!)
    }
    //设置歌曲的封面及背景
    func onSetImage(url:String) {
//        Alamofire.request(.GET, url).response { (_, _, data, error) -> Void in
//            let image = UIImage(data: data!)
//            self.bgImage.image = image
//            self.bgRotationImage.image = image
//        }
        onGetCacheImage(url, imgView: self.bgImage)
        onGetCacheImage(url, imgView: self.bgRotationImage)
    }
    
    //图片缓存方法
    func onGetCacheImage(url:String,imgView:UIImageView) {
        let image:UIImage? = self.imageCache[url]
        if image == nil {
            Alamofire.request(.GET, url).response(completionHandler: { (_, _, data, error) -> Void in
                let img = UIImage(data: data!)
                imgView.image = img
                self.imageCache[url] = img
            })
        }else {
            //有缓存，直接拿出来用
            imgView.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

