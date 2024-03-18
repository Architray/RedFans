//
//  NetworkDatas.swift
//  RedFans
//
//  Created by 思水 on 2024/3/18.
//

import Foundation

@objc class NetworkDatas: NSObject {
    
    @objc class func networkData(_ request: NSURLRequest, response: URLResponse, data: Data, error: NSError, startTime: TimeInterval) {
//        print("URL:\(request.url?.absoluteString ?? ""), \ndata:\(String(data: data, encoding: .utf8) ?? "")")
    }
    
}
