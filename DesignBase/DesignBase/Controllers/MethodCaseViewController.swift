//
//  MethodCaseViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/29.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit
import Alamofire

class MethodCaseViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var summary: UITextView!
    
    var magnifierView:MagnifierView!
    
    var contentView:UIView!
    var webView:UIWebView!
    
    var caseList:[Int] = []
    
    var moreContent:String?
    var closeImage:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        magnifierView = MagnifierView()
        magnifierView.viewToMagnify = self.view
        magnifierView.touchPoint = CGPointMake(665, 230)
        magnifierView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(magnifierView)
       
        webView = UIWebView(frame: CGRectMake(0, 768, 1024, 768))
        webView.scrollView.delegate = self
        self.view.addSubview(webView)
        
        closeImage = UIImageView(frame: CGRectMake(960, 10, 54, 51))
        closeImage?.image = UIImage(named: "close")
        closeImage?.userInteractionEnabled = true
        var closeTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeTapClickAction:")
        closeImage?.addGestureRecognizer(closeTap)
        closeImage?.hidden = true
        
        webView.addSubview(closeImage!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initScrollView(){
        
        if caseList.count == 0{
            self.view.makeToast("无关联案例", duration: 2.0, position:CSToastPositionCenter)
        }
        else
        {
            self.loadCase(caseList[0])
            
            contentView = UIView(frame: CGRectMake(0, 0, 910, 130))
            
            var whiteView1:UIView = UIView(frame: CGRectMake(0, 0, 130, 130))
            var whiteView2:UIView = UIView(frame: CGRectMake(130, 0, 130, 130))
            
            contentView.addSubview(whiteView1)
            contentView.addSubview(whiteView2)
            var num:Int = 0
            for i in caseList{
                println(i)
                var imageName:String = "S1408W0"
                if i < 9{
                    imageName += "0" + String(i)
                }
                else{
                    imageName += String(i)
                }
                var image:UIImageView = UIImageView(image: UIImage(named:imageName))
                var x = num * 130 + 260
                image.frame = CGRectMake(CGFloat(x), 0, 130, 130)
                image.contentMode = UIViewContentMode.ScaleAspectFit
                contentView.addSubview(image)
                num++
            }
            
            var whiteView3:UIView = UIView(frame: CGRectMake(650, 0, 130, 130))
            var whiteView4:UIView = UIView(frame: CGRectMake(780, 0, 130, 130))
            
            contentView.addSubview(whiteView3)
            contentView.addSubview(whiteView4)
            scrollView.addSubview(contentView)
            scrollView.contentSize = CGSizeMake(130 * 7, 130)
            scrollView.delegate = self
            scrollView.bounces = false
        }
        
        
    }
    
    func refreshMagnifier(){
        magnifierView.setNeedsDisplay()
    }
    
    func scrollViewDidEndDragging(_scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!_scrollView.superview!.isKindOfClass(UIWebView.classForCoder())){
            var offset:CGFloat = _scrollView.contentOffset.x
            
            if offset < 100
            {
                scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
                if (caseList.count > 0){
                    loadCase(caseList[0])
                }
            }
            else if offset > 100 && offset < 180
            {
                scrollView.setContentOffset(CGPointMake(130, 0), animated: true)
                if (caseList.count > 1){
                    loadCase(caseList[1])
                }
            }
            else if offset > 180
            {
                scrollView.setContentOffset(CGPointMake(253, 0), animated: true)
                if (caseList.count > 2){
                    loadCase(caseList[2])
                }
            }
        }
        
    }
    
    func scrollViewDidScroll(_scrollView: UIScrollView) {
        if(!_scrollView.superview!.isKindOfClass(UIWebView.classForCoder())){
            magnifierView.setNeedsDisplay()
        }
    }
    
    func scrollViewWillBeginDragging(_scrollView: UIScrollView) {
        if(_scrollView.superview!.isKindOfClass(UIWebView.classForCoder())){
            NSNotificationCenter.defaultCenter().postNotificationName("MethodAnimationMenuNotification", object: nil)
        }
    }
    
    func loadCase(caseId:Int){
        var url:String = RequestURL.ServerCaseURL + String(caseId)
        self.view.makeToastActivity()
        Alamofire.request(.GET, url).responseJSON({ (_, _, JSON, error) -> Void in
            println(error)
            if (error == nil){
                println(JSON)
                var dict:NSDictionary =  JSON as NSDictionary
                self.titleView.text = dict.objectForKey("name") as? String
                println(dict.objectForKey("name") as? String)
                self.timeLabel.text = dict.objectForKey("date_record") as? String
                self.summary.text = dict.objectForKey("abstract") as? String
                self.moreContent = dict.objectForKey("content") as? String
            }
            self.view.hideToastActivity()
        })
    }
    
    @IBAction func moreBtnClick(sender: AnyObject) {
        webView.loadHTMLString(moreContent, baseURL: nil)
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            var point:CGPoint? = self.webView.center
            point?.y -= 768
            self.webView.center = point!
            }) { (Bool) -> Void in
                println()
              self.closeImage?.hidden = false
        }
    }
    
    func closeTapClickAction(gesture:UIGestureRecognizer){
        self.closeImage?.hidden = true
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            var point:CGPoint? = self.webView.center
            point?.y += 768
            self.webView.center = point!
            }) { (Bool) -> Void in
                println("spread over")
                self.webView.loadHTMLString("", baseURL: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}