//
//  NewsView.swift
//  StockTrack
//
//  Created by Matin Massoudi on 12/11/20.
//

import UIKit
import WebKit

class NewsView: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView?.navigationDelegate = self
        if let url = URL(string: "https://google.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func back(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: Any) {
        webView.goForward()
    }
    
    //MARK: - WebKit delgate functions.
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)
    {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print(#function)
    }
    
    
    
    
}
