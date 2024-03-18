//
//  ViewController.swift
//  RedFans
//
//  Created by 思水 on 2024/3/18.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var getBtn: NSButton!
    
    @IBOutlet weak var markBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.xiaohongshu.com/explore")
        webView.load(URLRequest(url: url!))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func getInfo(_ sender: NSButton) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html, error) in
            guard let html = html as? String else { return }
            print(html)
        }
    }
    
    @IBAction func markUser(_ sender: Any) {
    }
    
}

