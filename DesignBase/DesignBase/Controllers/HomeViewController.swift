//
//  HomeViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/18.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController:UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var methodList:[MethodModel] = []
    
    var menuViewController:MenuViewController?
    var subMenuViewController:SubMenuViewController?
    var theoryViewController:TheoryViewController?
    
    var mainMenuIsSpread:Bool = false
    var subMenuIsSpread:Bool = false
    
    var isAddPanel:Bool = false
    var isAddAboutPanel:Bool = false
    var panel:UIView = UIView(frame: CGRectMake(673, 0, 235, 235))
    var menuType:Int = MenuType.METHOD.rawValue
    
    var centerPointList:[CGPoint] = Array()
    
    var panelClickMethodModel:MethodModel?
    
    @IBOutlet weak var backBtn: UIButton!
    
    var baiduStatistic:BaiduMobStat = BaiduMobStat.defaultStat()
    
    var aboutView:UIView!
    var offset:CGFloat = 0.0
    var tipsView:TipsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var mainBundle:NSBundle = NSBundle.mainBundle()
        theoryViewController = TheoryViewController(nibName:"theoryPanel", bundle:mainBundle)
        theoryViewController?.view.frame = CGRectMake(0, 0, 1024, 768)
        self.addChildViewController(theoryViewController!)
        if let view = theoryViewController?.view{
            self.view.addSubview(view)
            theoryViewController?.view.hidden = true
        }
        
        self.view.insertSubview(backBtn, aboveSubview: theoryViewController!.view)
        
        var methodModel:MethodModel
        
        let plistpath = NSBundle.mainBundle().pathForResource("methodList", ofType: "plist")!
        var methodMenuList:NSMutableArray = NSMutableArray(contentsOfFile: plistpath)!
        
        for dict in methodMenuList {
            methodModel = MethodModel()
            methodModel.cnName = dict.objectForKey("cnName") as? String
            methodModel.enName = dict.objectForKey("enName") as? String
            methodModel.iconName = dict.objectForKey("iconName") as String
            methodModel.flag = dict.objectForKey("flag") as? String
            
            methodList.append(methodModel)
        }
        
        if (methodList.count >= 13){
            panelClickMethodModel = methodList[13]
        }
        subMenuViewController = SubMenuViewController()
        subMenuViewController?.view.frame = CGRectMake(-210, 0, 210, 768)
        subMenuViewController?.view.backgroundColor = UIColor(red: 247/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        self.addChildViewController(subMenuViewController!)
        if let subMenuView = subMenuViewController?.view{
            subMenuView.alpha = 0.8
            self.view.addSubview(subMenuView)
        }
        subMenuViewController?.view.hidden = true
        
        menuViewController = MenuViewController(nibName:"menuPanel",bundle:mainBundle)
        menuViewController?.view.frame = CGRectMake(-210, 0,210,768)
        self.addChildViewController(menuViewController!)
        if let view = menuViewController?.view{
            self.view.addSubview(view)
            menuViewController?.view.hidden = true
        }
        
        var panPanel:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:"doHandlePanAction:")
        panel.addGestureRecognizer(panPanel)
        
        var tapPanel:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doHandleTapAction:")
        panel.addGestureRecognizer(tapPanel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animationOfReceivedNotification:", name: "SubAnimationMenuNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eyeOfReceivedNotification:", name: "EyeAnimationMenuNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "typeReceivedNotification:", name: "TypeMenuNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentReceivedNotification:", name: "ListContentNotification", object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "theoryReceivedNotification:", name: "TheoryContentNotification", object: nil)
        
        aboutView = UIView()
        aboutView.frame = CGRectMake(0, 768, 1024, 768)
        aboutView.backgroundColor = UIColor.whiteColor()
        var aboutLayer:CALayer = CALayer()
        aboutLayer.frame = CGRectMake(212, 0, 600, 768)
        aboutLayer.contents = UIImage(named: "aboutContent")?.CGImage
        aboutView.layer.addSublayer(aboutLayer)
        
        var leftLayer:CALayer = CALayer()
        leftLayer.frame = CGRectMake(199, 0, 13, 768)
        leftLayer.contents = UIImage(named: "line")?.CGImage
        leftLayer.opacity = 0.5
        self.aboutView.layer.addSublayer(leftLayer)
        
        var rightLayer:CALayer = CALayer()
        rightLayer.frame = CGRectMake(833, 0, 13, 768)
        rightLayer.contents = UIImage(named: "line")?.CGImage
        rightLayer.opacity = 0.5
        self.aboutView.layer.addSublayer(rightLayer)
        
        var aboutPanelCloseBtn:UIButton = UIButton(frame: CGRectMake(792, 0, 40, 40))
        aboutPanelCloseBtn.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
        aboutPanelCloseBtn.addTarget(self, action: "aboutPanelClose:", forControlEvents: UIControlEvents.TouchUpInside)
        aboutView.addSubview(aboutPanelCloseBtn)
        self.view.addSubview(aboutView)
        
        tipsView = TipsView()
        tipsView.center = CGPointMake((1024 - 420)/2 + 310, 768/2 - 100)
        tipsView.frame.size = CGSizeMake(125, 68)
        tipsView.hidden = true
        self.view.addSubview(tipsView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        baiduStatistic.pageviewStartWithName("启动首页")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        baiduStatistic.pageviewEndWithName("关闭首页")
    }
    
    @IBAction func popMenu(sender: AnyObject) {
        println(mainMenuIsSpread)
        if (!mainMenuIsSpread){
            self.mainMenuIsSpread = true
            menuViewController?.view.hidden = false
            self.view.insertSubview(self.backBtn, belowSubview: self.theoryViewController!.view)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                var point:CGPoint? = self.menuViewController?.view.center
                point?.x += 210
                self.menuViewController?.view.center = point!
                }) { (Bool) -> Void in
                    println("....pop spread over")
            }
            baiduStatistic.logEvent("TapMainMenu", eventLabel: "弹出主菜单")
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return methodList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var methodModel:MethodModel = methodList[indexPath.row]
        var imageCell:HomeListCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as HomeListCell
        imageCell.iconView.image = UIImage(named: methodModel.iconName)
        
        var result:Bool = false
        for centerPoint in centerPointList{
            if (imageCell.center == centerPoint){
                result = true
                break
            }
        }
        
        if !result{
            centerPointList.append(imageCell.center)
        }
        return imageCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("click collection...")
        var methodModel:MethodModel = methodList[indexPath.row]
        
        if menuType == MenuType.METHOD.rawValue{
            var detailViewController:MethodDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("methodDetail") as MethodDetailViewController
            if methodModel.flag != nil{
                detailViewController.methodId = methodModel.flag!
            }
            self.presentViewController(detailViewController, animated: true, completion: { () -> Void in
                
            })
            
        }
        else if menuType == MenuType.CASE.rawValue{
            var detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("caseDetail") as CaseViewController
            println(methodModel.cnName)
            detailViewController.chineseTitle = methodModel.cnName
            detailViewController.enTitle = methodModel.enName
            detailViewController.url = RequestURL.ServerCaseURL + methodModel.flag!
            self.presentViewController(detailViewController, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationOfReceivedNotification(notification:NSNotification)
    {
        var menuStatus:String = notification.object as String
        
        if menuStatus == "CLOSE"{
            if (subMenuIsSpread){
                closeSubMenu()
            }
            if (mainMenuIsSpread){
                closeMainMenu()
            }
        }
        else if menuStatus == "OPEN"{
            if !subMenuIsSpread{
                 self.subMenuIsSpread = true
                self.subMenuViewController?.view.hidden = false
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    var point:CGPoint? = self.subMenuViewController?.view.center
                    point?.x += 420
                    self.subMenuViewController?.view.center = point!
                    }) { (Bool) -> Void in
                        println("spread over")
                       
                }
            }
        }
    }
    
    func eyeOfReceivedNotification(notification:NSNotification)
    {
        var eyeOrAbout:String = notification.object as String
        if (eyeOrAbout == "EYE"){
            if methodList.count > 0{
                if !isAddPanel{
                    var bgColor:UIColor = UIColor(patternImage: UIImage(named: "panelBg")!)
                    panel.backgroundColor = bgColor
                    self.collectionView.addSubview(panel)
                    UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        if self.methodList.count > 10{
                            self.panel.frame = CGRectMake(595, 172 + CGFloat(Int(self.offset / 192)*192), 235, 235)
                        }
                        else{
                            self.panel.frame = CGRectMake(595, -20 + CGFloat(Int(self.offset / 192)*192), 235, 235)
                        }
                        }) { (Bool) -> Void in
                            self.isAddPanel = true
                    }
                }
                else
                {
                    panel.removeFromSuperview();
                    self.isAddPanel = false
                    self.panel.frame = CGRectMake(675, 160 + CGFloat(Int(self.offset / 192)*192), 235, 235)
                }
            }
            else{
                self.view.makeToast("无数据!", duration: 2.0, position:CSToastPositionCenter)
            }
        }
        else if (eyeOrAbout == "ABOUT"){
            aboutPanelClose(nil)
        }
    }
    
    func typeReceivedNotification(notification:NSNotification)
    {
        menuType = notification.object as Int
        
        if menuType == MenuType.THEORY.rawValue{
            theoryViewController?.view.hidden = false
            var url:String = RequestURL.ServerBookURL + "1.1"
            
            self.loadingTheoryContent(url)
        }
        else if menuType == MenuType.CASE.rawValue{
            theoryViewController?.view.hidden = true
            methodList.removeAll(keepCapacity: true)
            var methodModel:MethodModel
            
            let plistpath = NSBundle.mainBundle().pathForResource("caseList", ofType: "plist")!
            var methodMenuList:NSMutableArray = NSMutableArray(contentsOfFile: plistpath)!
            
            for dict in methodMenuList {
                methodModel = MethodModel()
                methodModel.cnName = dict.objectForKey("cnName") as? String
                methodModel.enName = dict.objectForKey("enName") as? String
                methodModel.iconName = dict.objectForKey("iconName") as String
                methodModel.flag = dict.objectForKey("flag") as? String
                
                methodList.append(methodModel)
            }
            if (methodList.count == 0){
                tipsView.showNothingTips()
            }
            collectionView.reloadData()
            
            if isAddPanel{
                self.panel.hidden = true
            }
        }
        else if menuType == MenuType.METHOD.rawValue{
            theoryViewController?.view.hidden = true
            methodList.removeAll(keepCapacity: true)
            var methodModel:MethodModel
            let plistpath = NSBundle.mainBundle().pathForResource("methodList", ofType: "plist")!
            var methodMenuList:NSMutableArray = NSMutableArray(contentsOfFile: plistpath)!
            
            for dict in methodMenuList {
                methodModel = MethodModel()
                methodModel.cnName = dict.objectForKey("cnName") as? String
                methodModel.enName = dict.objectForKey("enName") as? String
                methodModel.iconName = dict.objectForKey("iconName") as String
                methodModel.flag = dict.objectForKey("flag") as? String
                
                methodList.append(methodModel)
            }
            if (methodList.count == 0){
                tipsView.showNothingTips()
            }
           collectionView.reloadData()
            if isAddPanel{
                self.panel.hidden = false
            }
        }
        if (subMenuIsSpread){
            closeSubMenu()
        }
    }
    
    func contentReceivedNotification(notification:NSNotification){
        methodList.removeAll(keepCapacity: true)
        var array:[MethodModel] = notification.object as Array
        for methodModel in array{
            methodList.append(methodModel)
        }
        
        collectionView.reloadData()
        if array.count == 0{
            tipsView.showNothingTips()
        }
    }
    
    func theoryReceivedNotification(notification:NSNotification){
       
        var chapter:SubMenuModel = notification.object as SubMenuModel
        println(chapter.chapterID)
        
        if chapter.chapterID? != nil{
            
            var url:String = RequestURL.ServerBookURL + chapter.chapterID!
           
            self.loadingTheoryContent(url)
        }
    }
    
    func closeSubMenu(){
        self.subMenuIsSpread = false
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            var point:CGPoint? = self.subMenuViewController?.view.center
            point?.x -= 420
            self.subMenuViewController?.view.center = point!
            }) { (Bool) -> Void in
                println("close over")
                self.subMenuViewController?.view.hidden = true
        }
    }
    
    func closeMainMenu(){
        //self.theoryViewController?.view.hidden = true
        self.view.bringSubviewToFront(self.backBtn)
        self.mainMenuIsSpread = false
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            var point:CGPoint? = self.menuViewController?.view.center
            point?.x -= 210
            self.menuViewController?.view.center = point!
            }) { (Bool) -> Void in
                println("close over")
                self.menuViewController?.view.hidden = true
        }
    }
    
    func loadingTheoryContent(url:String){
        self.view.makeToastActivity()
        Alamofire.request(.GET, url).responseJSON({ (_, _, JSON, error) -> Void in
            println(error)
            if (error == nil){
                println("success")
                var dict:NSDictionary = JSON as NSDictionary
                self.theoryViewController?.webView.loadHTMLString(dict.objectForKey("content") as String, baseURL: nil)
            }
            else{
                var filePath:String! = NSBundle.mainBundle().pathForResource("404", ofType: "html")
                var url:NSURL = NSURL(string: filePath, relativeToURL: NSURL(fileURLWithPath: filePath.stringByDeletingLastPathComponent, isDirectory: true))!
                var request:NSURLRequest = NSURLRequest(URL: url)
                self.theoryViewController?.webView.loadRequest(request)
            }
            self.view.hideToastActivity()
        })
    }
    
    func doHandlePanAction(paramSender:UIPanGestureRecognizer){
        
        var point:CGPoint = paramSender.translationInView(self.collectionView)
        var view:UIView = paramSender.view!
        
        paramSender.view?.center = CGPointMake(view.center.x + point.x, view.center.y + point.y);
        
        var i:Int = 0
        
        paramSender.setTranslation(CGPointZero, inView: self.collectionView)
        if (paramSender.state == UIGestureRecognizerState.Ended){
            println("Pan is end...\(centerPointList.count)")
            var center:CGPoint = CGPointZero
            var distance:CGFloat = 1200.0
            for centerPoint in centerPointList{
                var tempDistance = self.distanceBetweenPoint(centerPoint, point2: paramSender.view!.center)
                if tempDistance < distance{
                    distance = tempDistance
                    center = centerPoint
                }
            }
            println(center)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                var point:CGPoint? = paramSender.view?.center
                point = CGPointMake(center.x - 2, center.y)
                paramSender.view?.center = point!
                }) { (Bool) -> Void in
                    
            }
            
            for centerPoint in centerPointList{
                
                if (center == centerPoint){
                    break
                }
                i++
            }
            
            panelClickMethodModel = methodList[i]
            println("\(i), \(panelClickMethodModel?.flag)")
        }
    }
    
    func doHandleTapAction(gesture:UITapGestureRecognizer){
        println("\(panelClickMethodModel?.cnName), \(panelClickMethodModel?.flag)")
        var detailViewController:RelationCaseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RelationCaseView") as RelationCaseViewController
        if (panelClickMethodModel?.flag != nil){
            
            detailViewController.methodId = panelClickMethodModel?.flag
        }
        
        self.presentViewController(detailViewController, animated: true) { () -> Void in
            
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if (subMenuIsSpread){
            closeSubMenu()
        }
        if (mainMenuIsSpread){
            closeMainMenu()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        offset = scrollView.contentOffset.y
    }
    
    func distanceBetweenPoint(point1:CGPoint, point2:CGPoint)->CGFloat{
        var xDelta:CGFloat = point1.x - point2.x
        var xDeltaPF:CGFloat = pow(xDelta, 2)
        
        var yDelta:CGFloat = point1.y - point2.y
        var yDeltaPF:CGFloat = pow(yDelta, 2)
        
        return sqrt(xDeltaPF + yDeltaPF)
    }
    
    func aboutPanelClose(target:UIButton!)
    {
        if !isAddAboutPanel{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                var point:CGPoint? = self.aboutView.center
                point?.y -= 768
                self.aboutView.center = point!
                }) { (Bool) -> Void in
                    println("spread over")
                    self.isAddAboutPanel = true
            }
        }
        else{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                var point:CGPoint? = self.aboutView.center
                point?.y += 768
                self.aboutView.center = point!
                }) { (Bool) -> Void in
                    println("close over")
                    self.isAddAboutPanel = false
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SubAnimationMenuNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "EyeAnimationMenuNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TypeMenuNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ListContentNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "TheoryContentNotification", object: nil)
    }
}
