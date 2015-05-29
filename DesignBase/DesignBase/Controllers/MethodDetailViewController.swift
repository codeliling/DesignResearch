//
//  MethodDetailViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/25.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit
import Alamofire

class MethodDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var backIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var webView: UIWebView!
    
    var methodDetailMenuList:NSMutableArray!
    var lastSelectRow:NSIndexPath?
    var mdscController:MethodDetailStudyCaseViewController?
    var mcController:MethodCaseViewController?
    
    var methodId:String = "2"
    
    var contentDict:NSDictionary?
    
    @IBOutlet weak var menuPanel: UIView!
    var isMenuPanelSpread:Bool = true
    
    var popMenuBtn:UIButton!
    
    var mainBundle:NSBundle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plistpath = NSBundle.mainBundle().pathForResource("methodDetailMenuList", ofType: "plist")!
        methodDetailMenuList = NSMutableArray(contentsOfFile: plistpath)
        
        var view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
        tableView.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
        tableView.bounces = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        
        var backTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backTapClick:")
        backIcon.addGestureRecognizer(backTap)
        
        mainBundle = NSBundle.mainBundle()
        self.mdscController = MethodDetailStudyCaseViewController(nibName:"methodProcessView",bundle:mainBundle)
        self.mdscController?.view.frame = CGRectMake(210, 0, 814, 768)
        self.addChildViewController(self.mdscController!)
        if let view = self.mdscController?.view{
            self.view.addSubview(view)
            view.hidden = true
        }
        
        self.mcController = MethodCaseViewController(nibName:"methodCaseView",bundle:mainBundle)
        self.mcController?.view.frame = CGRectMake(0, 0, 1024, 768)
        self.addChildViewController(self.mcController!)
        if let view = self.mcController?.view{
            self.view.addSubview(view)
            view.hidden = true
        }
        
        self.loadingMethodContent(RequestURL.ServerMethodURL + methodId)
        
        popMenuBtn = UIButton(frame: CGRectMake(0, 0, 50, 50))
        popMenuBtn.setBackgroundImage(UIImage(named: "mainMenuBg"), forState: UIControlState.Normal)
        popMenuBtn.addTarget(self, action: "popMenuBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(popMenuBtn)
        
        self.view.bringSubviewToFront(tableView.superview!)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "animationOfReceivedNotification:", name: "MethodAnimationMenuNotification", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.hidden = false
        animateTable()
        
        var first:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.selectRowAtIndexPath(first, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
        if indexPath.row == 0{
            var cell:MenuCell = cell as MenuCell
            for subView in cell.contentView.subviews{
                if (subView.isKindOfClass(MenuView.classForCoder()))
                {
                    var view:MenuView = subView as MenuView
                    view.updateTextColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
                }
            }
            lastSelectRow = indexPath
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier:NSString = "Cell";
        var cell:MenuCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MenuCell;
        
        if (cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("menuCell", owner: nil, options: nil)[0] as? MenuCell
            
        }
        
        var dict:NSDictionary = methodDetailMenuList.objectAtIndex(indexPath.row) as NSDictionary
        var cnName:String = dict.objectForKey("cnName") as String
        var enName:String = dict.objectForKey("enName") as String
        var menuView:MenuView = MenuView(frame: CGRectMake(0, 0, 195, 54), chineseTitle: cnName, enTitle: enName)
        menuView.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
        menuView.updateTextColor(UIColor.whiteColor())
        cell?.contentView.addSubview(menuView)
        var viewFrame:CGRect? = cell?.frame
        cell?.selectedBackgroundView = UIView(frame: viewFrame!)
        cell?.selectedBackgroundView.backgroundColor = UIColor.whiteColor()
        return cell!;
    }
    
    override func viewDidLayoutSubviews() {
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 100, 0)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 100, 0)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methodDetailMenuList.count;
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:MenuCell? = tableView.cellForRowAtIndexPath(indexPath) as? MenuCell
        if let views = cell?.contentView.subviews{
            for subView in views{
                if (subView.isKindOfClass(MenuView.classForCoder()))
                {
                    var view:MenuView = subView as MenuView
                    view.updateTextColor(UIColor.whiteColor())
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        var cell:MenuCell? = tableView.cellForRowAtIndexPath(indexPath) as? MenuCell
       
        if let views = cell?.contentView.subviews{
            for subView in views{
                if (subView.isKindOfClass(MenuView.classForCoder()))
                {
                    var view:MenuView = subView as MenuView
                    view.updateTextColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
                }
            }
        }
        if indexPath.row == 2
        {
            mdscController?.view.hidden = false
            //mdscController?.initTextView()
            webView.hidden = true
            mcController?.view.hidden = true
            
            if (contentDict != nil ){
                if (mdscController?.initFlag == 0){
                    var array:NSArray = self.contentDict?.objectForKey("process_list") as NSArray
                    mdscController?.data = array
                    mdscController?.addStepsView()
                }
            }
            else{
                self.view.makeToast("无数据或者网络错误", duration: 2.0, position:CSToastPositionCenter)
            }
        }
        else if indexPath.row == 3
        {
            mcController?.view.hidden = false
            mdscController?.view.hidden = true
            webView.hidden = true
            if (contentDict != nil){
                var array:[Int] = self.contentDict?.objectForKey("study_cases") as Array
                mcController?.caseList = array
                mcController?.refreshMagnifier()
                mcController?.initScrollView()
            }
            else{
                self.view.makeToast("无数据或者网络错误", duration: 2.0, position:CSToastPositionCenter)
            }
        }
        else
        {
            webView.hidden = false
            mdscController?.view.hidden = true
            mcController?.view.hidden = true
            if indexPath.row == 0{
                if (contentDict != nil){
                    var introduction_text:String = self.contentDict?.objectForKey("introduction_text") as String
                    self.webView.loadHTMLString(introduction_text, baseURL: nil)
                }
            }
            else if indexPath.row == 1{
                if (contentDict != nil){
                    var scene_text:String = self.contentDict?.objectForKey("scene_text") as String
                    self.webView.loadHTMLString(scene_text, baseURL: nil)
                }
            }
            
        }
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    func loadingMethodContent(url:String){
        println(url)
        self.view.makeToastActivity()
        Alamofire.request(.GET, url).responseJSON({ (_, _, JSON, error) -> Void in
            if (error == nil){
                println(JSON)
                self.contentDict = JSON as? NSDictionary
                var introduction_text:String = self.contentDict?.objectForKey("introduction_text") as String
                self.webView.loadHTMLString(introduction_text, baseURL: nil)
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
    
    func backTapClick(gesture:UIGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("close view...")
        })
    }
    
    func animationOfReceivedNotification(notification:NSNotification){
        if isMenuPanelSpread{
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                var point:CGPoint? = self.menuPanel.center
                point?.x -= 210
                self.menuPanel.center = point!
                }) { (Bool) -> Void in
                    println("close over")
                    self.isMenuPanelSpread = false
            }
        }
    }
    
    func popMenuBtnClick(target:UIButton!){
        if !isMenuPanelSpread{
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                var point:CGPoint? = self.menuPanel.center
                point?.x += 210
                self.menuPanel.center = point!
                }) { (Bool) -> Void in
                    println("close over")
                    self.isMenuPanelSpread = true
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MethodAnimationMenuNotification", object: nil)
    }
}
