//
//  ViewController.swift
//  RedFansApp
//
//  Created by 思水 on 2024/3/18.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var switcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let JavaScriptFunction = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        let config = webView.configuration
//        let userContentController = webView.configuration.userContentController
//        let script = WKUserScript(source: JavaScriptFunction, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
//        userContentController.addUserScript(script)
//        config.applicationNameForUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.2 Safari/605.1.15"
        
//        webView.uiDelegate = self
        
        let url = URL(string: "https://www.xiaohongshu.com/explore")
        webView.load(URLRequest(url: url!))
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        
    }
    
    @IBAction func pcMode(_ sender: UIButton) {
        webView.reload()
//        let JavaScriptFunction = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        webView.evaluateJavaScript(JavaScriptFunction) { (html, error) in
//            guard let html = html as? String else { return }
//            print(html)
//        }
    }


}

