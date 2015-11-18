//
//  HttpController.swift
//  NCZ_DBDT
//
//  Created by 弄潮者 on 15/11/18.
//  Copyright © 2015年 弄潮者. All rights reserved.
//

import Foundation
import Alamofire
//import UIKit


class HttpController:NSObject {
    //定义代理
    var delegate:HttpProtocol?
    
    //接收网址，回调代理方法传回数据
    func onSearch(url:String) {
//        Alamofire.request(.GET, url).response { (request, response, data, error) -> Void in
//            self.delegate?.didReceivedResults(data!)
//        }
//        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
//            self.delegate?.didReceivedResults(response.data!)
//        }

        Alamofire.request(.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (response) -> Void in
            self.delegate?.didReceivedResults(response.result.value!)
        }

    }
}

//定义http协议
protocol HttpProtocol {
    //定义一个方法，接受一个参数：AnyObject
    func didReceivedResults(results:AnyObject)
}