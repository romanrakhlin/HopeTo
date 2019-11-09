//
//  ViewController.swift
//  noName
//
//  Created by Roman Rakhlin on 09.11.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        let myURL = URL(string: "http://www.instagram.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

