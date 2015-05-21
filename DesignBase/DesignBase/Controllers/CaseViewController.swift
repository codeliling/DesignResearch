//
//  CaseViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/5/7.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit
import Alamofire

class CaseViewController: ViewController {
    
    var lineLayer:CALayer?
    var menuView:MenuView?
    var chineseTitle:String?
    var enTitle:String?
    var url:String?
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var abstructTextView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorNumLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineLayer = CALayer()
        lineLayer?.frame = CGRectMake(20, 230, 170, 2)
        lineLayer?.backgroundColor = UIColor.whiteColor().CGColor
        self.view.layer.addSublayer(lineLayer)
        // Do any additional setup after loading the view, typically from a nib.
        
        var tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backImageClick:")
        backImage.addGestureRecognizer(tapGesture)
        
        if (menuView == nil){
            menuView = MenuView()
            menuView?.frame = CGRectMake(10, 170, 170, 60)
            menuView?.chineseTitle = chineseTitle
            menuView?.enTitle = enTitle
            menuView?.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
            menuView?.setNeedsDisplay()
            self.view.addSubview(menuView!)
        }
        
        self.loadingTheoryContent(url!)
        
        webView.backgroundColor = UIColor.whiteColor()
        
    }
    
    func loadingTheoryContent(url:String){
        println(url)
        self.view.makeToastActivity()
        Alamofire.request(.GET, url).responseJSON({ (_, _, JSON, error) -> Void in
            println(error)
            if (error == nil){
                var dict:NSDictionary = JSON as NSDictionary
                self.webView.loadHTMLString(dict.objectForKey("content") as String, baseURL: nil)
                self.abstructTextView.text = dict.objectForKey("abstract") as String
                self.authorLabel.text = dict.objectForKey("author") as? String
                self.authorNumLabel.text = dict.objectForKey("author_no") as? String
                if let teacher = dict.objectForKey("mentor") as? String{
                    self.teacherLabel.text = "指导老师:" + teacher
                }
                
                for view in self.webView.subviews{
                    if view.isKindOfClass(UIScrollView.classForCoder()){
                        var scrollView:UIScrollView = view as UIScrollView
                        scrollView.showsHorizontalScrollIndicator = false
                        scrollView.alwaysBounceHorizontal = true
                    }
                }
            }
            else
            {
                var filePath:String! = NSBundle.mainBundle().pathForResource("404", ofType: "html")
                var url:NSURL = NSURL(string: filePath, relativeToURL: NSURL(fileURLWithPath: filePath.stringByDeletingLastPathComponent, isDirectory: true))!
                var request:NSURLRequest = NSURLRequest(URL: url)
                self.webView.loadRequest(request)
            }
            self.view.hideToastActivity()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func backImageClick(gesture:UIGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
