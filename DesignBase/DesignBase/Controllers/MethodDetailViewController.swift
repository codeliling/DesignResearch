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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plistpath = NSBundle.mainBundle().pathForResource("methodDetailMenuList", ofType: "plist")!
        methodDetailMenuList = NSMutableArray(contentsOfFile: plistpath)
        
        var view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view;
        //tableListView.backgroundView = nil
        tableView.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1);
        tableView.bounces = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        var backTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backTapClick:")
        backIcon.addGestureRecognizer(backTap)
        
        var mainBundle:NSBundle = NSBundle.mainBundle()
        self.mdscController = MethodDetailStudyCaseViewController(nibName:"methodProcessView",bundle:mainBundle)
        self.mdscController?.view.frame = CGRectMake(210, 0, 814, 768)
        self.addChildViewController(self.mdscController!)
        if let view = self.mdscController?.view{
            self.view.addSubview(view)
            view.hidden = true
        }
        
        self.mcController = MethodCaseViewController(nibName:"methodCaseView",bundle:mainBundle)
        self.mcController?.view.frame = CGRectMake(210, 0, 814, 768)
        self.addChildViewController(self.mcController!)
        if let view = self.mcController?.view{
            self.view.addSubview(view)
            view.hidden = true
        }
        
        self.loadingMethodContent(RequestURL.ServerMethodURL + methodId)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.hidden = false
        animateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier:NSString = "Cell";
        var cell:MenuCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MenuCell;
        
        if (cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("menuCell", owner: nil, options: nil)[0] as? MenuCell
            
        }
        
        //cell?.backgroundColor = UIColor.clearColor()
        
        if var menuView:MenuView = cell?.menuView{
            var dict:NSDictionary = methodDetailMenuList.objectAtIndex(indexPath.row) as NSDictionary
            var cnName:String = dict.objectForKey("cnName") as String
            var enName:String = dict.objectForKey("enName") as String
            menuView.chineseTitle = cnName
            menuView.enTitle = enName
            menuView.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
            menuView.updateTextColor(UIColor.whiteColor())
            menuView.setNeedsDisplay()
        }
        
        cell?.selectedBackgroundView.backgroundColor = UIColor(red: 247/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        //cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!;
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        var cell:MenuCell?
        if lastSelectRow != nil{
            cell = tableView.cellForRowAtIndexPath(lastSelectRow!) as? MenuCell
            cell?.menuView.updateTextColor(UIColor.whiteColor())
        }
        cell = tableView.cellForRowAtIndexPath(indexPath) as? MenuCell
        cell?.menuView.updateTextColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
        
        lastSelectRow = indexPath
        
        if indexPath.row == 2
        {
            mdscController?.view.hidden = false
            webView.hidden = true
            mcController?.view.hidden = true
            
            if (contentDict != nil){
                var array:NSArray = self.contentDict?.objectForKey("process_list") as NSArray
                mdscController?.data = array
                mdscController?.addStepsView()
            }
        }
        else if indexPath.row == 3
        {
            mcController?.view.hidden = false
            mdscController?.view.hidden = true
            webView.hidden = true
            var array:[Int] = self.contentDict?.objectForKey("study_cases") as Array
            mcController?.caseList = array
            mcController?.refreshMagnifier()
            mcController?.initScrollView()
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
}
