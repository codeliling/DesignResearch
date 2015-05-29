//
//  TheoryViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/5/4.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit

class TheoryViewController: ViewController,UIWebViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.delegate = self
        webView.scrollView.alwaysBounceHorizontal = false;
        webView.scrollView.alwaysBounceVertical = true;
        webView.scrollView.delegate = self
        webView.scalesPageToFit = true
        for view in webView.subviews{
            if view.isKindOfClass(UIScrollView.classForCoder()){
                var scrlllView:UIScrollView = view as UIScrollView
                scrlllView.showsHorizontalScrollIndicator = false
            }
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("start...")
        self.view.makeToastActivity()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("finish...")
        self.view.hideToastActivity()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        println("ERROR...")
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSNotificationCenter.defaultCenter().postNotificationName("SubAnimationMenuNotification", object: "CLOSE")
    }
    

    func loadingWithUrl(url:String){
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
