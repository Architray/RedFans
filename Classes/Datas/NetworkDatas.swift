//
//  NetworkDatas.swift
//  RedFans
//
//  Created by 思水 on 2024/3/18.
//

import Foundation

@objc class NetworkDatas: NSObject {
    
    @objc class func networkData(_ request: NSURLRequest, response: URLResponse, data: Data, error: NSError, startTime: TimeInterval) {
        let contentType = request.value(forHTTPHeaderField: "Content-Type")
        if (contentType?.contains("multipart/form-data") ?? false) {
            return
        }
        if let url = request.url?.absoluteString {
            let mimeType = response.mimeType ?? ""
            
            let unMatchTypes = [
                "text/html",
                "text/plain",
                "image/jpeg",
                "text/css",
                "image/png",
                "text/json",
            ]
            let matchTypes = [
                "application/json",
                "",
            ]
            
            if (unMatchTypes.contains(mimeType)) {
                return
            }
            if mimeType.contains("javascript") {
                return
            }
            if !matchTypes.contains(mimeType) {
                
            }
        }
        let dataString = String(data: data, encoding: .utf8)
        if let jsonString = dataString,
           !jsonString.isEmpty,
           let jsonData = jsonString.data(using: .utf8)
        {
            do {
                // 尝试解析JSON数据为Dictionary
                if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    let success = dictionary["success"] as? Bool
                    if success == false {
//                    if success == true {
                        return
                    }
                }
            } catch {
                print("解析错误:", response.mimeType ?? "")
                print("解析错误:", jsonString)
                print("解析错误:", error)
            }
        }
        print("\n\n\n")
        print("URL:\(request.url?.absoluteString ?? ""), \ndata:\(dataString ?? "")")
        if dataString == nil {
            return
        }
        return
        
        print("curl '\(request.url?.absoluteString ?? "")' \\")
        print("-X '\(request.httpMethod ?? "")' \\")
        let header = request.allHTTPHeaderFields ?? [:]
        for key in header.keys {
            let value = header[key]
            print("-H '\(key): \(value ?? "")' \\")
        }
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("--data-binary '\(bodyString)'")
        }
    }
    
}
