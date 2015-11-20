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
import MediaPlayer

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
    
    //定义媒体播放器实例
    var audioPlayer:MPMoviePlayerController = MPMoviePlayerController()
    
    //申明计时器
    var timer:NSTimer?
    
    @IBOutlet var playTime: UILabel!
    @IBOutlet var progressLine: UIImageView!
    
    //按钮
    //播放按钮
    @IBOutlet var btnPlay: NCZButton!
    //下一首按钮
    @IBOutlet var btnNext: UIButton!
    //前一首按钮
    @IBOutlet var btnBack: UIButton!
    //当前播放
    var currentIndex:Int = 0
    
    @IBOutlet var btnOrder: OrderButton!
    
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
        
        //添加按钮动作
        btnPlay.addTarget(self, action: "onPlay:", forControlEvents: UIControlEvents.TouchUpInside)
        btnNext.addTarget(self, action: "onNext:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.addTarget(self, action: "onBack:", forControlEvents: UIControlEvents.TouchUpInside)
        btnOrder.addTarget(self, action: "onOrder:", forControlEvents: UIControlEvents.TouchUpInside)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playFinish", name: MPMoviePlayerPlaybackDidFinishNotification, object: audioPlayer)
        
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
//        print(url)
//        Alamofire.request(Method.GET, url!).response { (_, _, data, error) -> Void in
//            let img = UIImage(data: data!)
//            cell.imageView?.image = img
//        }        
        onGetCacheImage(url!, imgView: cell.imageView!)
        
        
        return cell
    }
    //设置cell的显示动画
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        UIView.animateWithDuration(0.25) { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }

    //HttpProtocol需要实现的方法
    func didReceivedResults(results:AnyObject) {
        print("\(results)")
        
        let json = JSON(results)
        if let channels = json["channels"].array {
            self.channelListData = channels
        }else if let song = json["song"].array {
            isAutoFinish = false
            self.songListData = song
//            print(song)

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
        
        //频道改变，当前的数目也要初始化
        isAutoFinish = false
        currentIndex = 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        isAutoFinish = false
        onSelectRow(indexPath.row)
        currentIndex = indexPath.row
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
        
        //播放音乐
        //获取音乐文件地址
        let url:String = rowData["url"].string!
        //播放音乐
        onSetAudio(url)
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
    
    //播放音乐的方法
    func onSetAudio(url:String) {
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = NSURL(string: url)
        self.audioPlayer.play()
        
        //播放音乐，按钮一直停留在播放状态
        btnPlay.onPlay()
        
        //先停下计时器
        timer?.invalidate()
        //计时器归零
        playTime.text = "00:00"
        //启动计时器
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        
        isAutoFinish = false
        
    }
    
    //计时器更新方法
    func onUpdate() {
        //获取当前播放时间
        let t = audioPlayer.currentPlaybackTime
        if t>0.0 {
            let currentTime:Int = Int(t)
            let sec:Int = currentTime%60
            let min:Int = Int(currentTime/60)
            
            var time:String = ""
            if min < 10 {
                time = "0\(min):"
            }else {
                time = "\(min):"
            }
            
            if sec < 10 {
                time += "0\(sec)"
            } else {
                time += "\(sec)"
            }
            playTime.text = time
            
            //歌曲总时间
            let totalTime:Double = audioPlayer.duration
            //百分比
            let pro:CGFloat = CGFloat(t/totalTime)
            progressLine.frame.size.width = view.frame.size.width*pro
        }
    }
    
    func onPlay(btn:NCZButton) {
        if btn.isPlay {
            audioPlayer.play()
        }else {
            audioPlayer.pause()
        }
    }
    
    func onBack(btn:UIButton) {
        isAutoFinish = false
//        currentIndex--
//        if currentIndex < 0 {
//            currentIndex = self.songListData.count - 1
//        }
//        onSelectRow(currentIndex)
        playOrder()
    }
    
    func onNext(btn:UIButton) {
        isAutoFinish = false
//        currentIndex++
//        if currentIndex > self.songListData.count-1 {
//            currentIndex  = 0
//        }
//        onSelectRow(currentIndex)
        playOrder()
    }
    
    func onOrder(btn:OrderButton) {
        var message:String = ""
        switch(btn.order) {
        case 1:
            message = "顺序播放"
        case 2:
            message = "随机播放"
        case 3:
            message = "单曲循环"
        default:
            message = "E R R O R"
        }
        self.view.makeToast(message: message, duration: 0.5, position: "center")
    }
    
    //是否为自动结束。因为认为结束，切换频道啊，点击下一首/上一首啊，都会执行playFinish
    //只有自然结束才会执行playFinish为true，其他会触发这个方法的地方，都修改此参数
    var isAutoFinish:Bool = true

    //歌曲播放结束执行方法
    func playFinish() {
        if isAutoFinish {
            playOrder()
        }
    }
    
    func playOrder() {
        switch(btnOrder.order) {
        case 1:
            //顺序播放
            currentIndex++
            if currentIndex > self.songListData.count-1 {
                currentIndex  = 0
            }
            onSelectRow(currentIndex)
        case 2:
            //随机播放
            currentIndex = random() % songListData.count
            onSelectRow(currentIndex)
        case 3:
            //单曲循环
            onSelectRow(currentIndex)
        default:
            print("default")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

