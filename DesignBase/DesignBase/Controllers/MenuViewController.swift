//
//  MenuViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/19.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit

class MenuViewController:UIViewController,UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var typeMenuScrollView: UIScrollView!
    
    @IBOutlet weak var tableListView: UITableView!
    
    var view1:UIView?
    var view2:UIView?
    var view3:UIView?
    var methodMenuList:NSMutableArray!
    var theorySubMenuList:NSArray?
    
    var lastSelectRow:NSIndexPath?
    var currentType = MenuType.METHOD
    var isEyeClicked:Bool = false
    var isAboutIconClicked:Bool = false
    
    let blueBg = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
    var baiduStatistic:BaiduMobStat = BaiduMobStat.defaultStat()
    @IBOutlet weak var backIcon: UIImageView!
    
    @IBOutlet weak var eysImageView: UIImageView!
    
    @IBOutlet weak var aboutIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableListView.delegate = self;
        tableListView.dataSource = self;
        
        //tableListView.registerNib(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "Cell")
        //tableListView.registerClass(MenuCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        let plistpath = NSBundle.mainBundle().pathForResource("methodMenuList", ofType: "plist")!
        //读取plist内容放到NSMutableArray内
        methodMenuList = NSMutableArray(contentsOfFile: plistpath)
        
        var view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableListView.tableFooterView = view;
        //tableListView.backgroundView = nil
        tableListView.backgroundColor = blueBg;
        
        tableListView.bounces = false
        initMainMenu()
        
        var tabBackIcon:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "clickBackIcon:")
        backIcon.addGestureRecognizer(tabBackIcon)
        
        var tapEyeIcon:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "clickEyeIcon:")
        eysImageView.addGestureRecognizer(tapEyeIcon)
        
        var tapAboutIcon:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "clickAboutIcon:")
        aboutIcon.addGestureRecognizer(tapAboutIcon)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if currentType == MenuType.THEORY{
            return methodMenuList.count
        }
        else
        {
            return 1
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentType == MenuType.THEORY{
            if (section == 0){
                return 55
            }
            else
            {
                return 80
            }
            
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if currentType == MenuType.THEORY{
            var view:UIView = UIView(frame: CGRectMake(0, 0, 210, 80))
            var dict:NSDictionary =  methodMenuList.objectAtIndex(section) as NSDictionary
            theorySubMenuList = dict.objectForKey("list") as? NSArray
            var cnName:String = dict.objectForKey("cnName") as String
            var enName:String = dict.objectForKey("enName") as String
            var frame:CGRect?
            var lineFrame:CGRect?
            
            if (section == 0){
                frame = CGRectMake(0, 0, 180, 40)
                lineFrame = CGRectMake(15, 45, 180, 1)
            }
            else{
                frame = CGRectMake(0, 30, 180, 40)
                lineFrame = CGRectMake(15, 75, 180, 1)
            }
            var titleSection:MenuView = MenuView(frame:frame!, chineseTitle: cnName, enTitle: enName)
            titleSection.backgroundColor = UIColor.clearColor()
            view.addSubview(titleSection)
            view.backgroundColor = blueBg
            /*
            var lineLayer:CALayer = CALayer()
            lineLayer.frame = lineFrame!
            lineLayer.backgroundColor = UIColor.whiteColor().CGColor
            view.layer.addSublayer(lineLayer)*/
            return view
        }
        else
        {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier:NSString = "Cell";
        //var cell:MenuCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MenuCell;
        
        var cell:MenuCell? = NSBundle.mainBundle().loadNibNamed("menuCell", owner: nil, options: nil)[0] as? MenuCell
        /*
        if (cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("menuCell", owner: nil, options: nil)[0] as? MenuCell
            
        }*/
        //cell?.backgroundColor = UIColor.clearColor()
        /*
        if (lastSelectRow != nil && currentType != MenuType.THEORY){
            cell?.menuView.updateTextColor(UIColor.whiteColor())
            cell?.menuView?.updateBgColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
        }*/
        if var menuView:MenuView = cell?.menuView{
            var dict:NSDictionary!
            if currentType == MenuType.THEORY{
                var tempDict:NSDictionary =  methodMenuList.objectAtIndex(indexPath.section) as NSDictionary
                theorySubMenuList = tempDict.objectForKey("list") as? NSArray
                dict = theorySubMenuList?.objectAtIndex(indexPath.row) as NSDictionary
                menuView.updateFrame(10.0)
            }
            else
            {
                dict = methodMenuList.objectAtIndex(indexPath.row) as? NSDictionary
                menuView.updateFrame(0.0)
            }
            var cnName:String = dict?.objectForKey("cnName") as String
            
            var enName:String = dict?.objectForKey("enName") as String
            
            menuView.chineseTitle = cnName
            menuView.enTitle = enName
            menuView.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
            menuView.updateTextColor(UIColor.whiteColor())
            //menuView.setNeedsDisplay()
            
        }
        
        cell?.selectedBackgroundView.backgroundColor = UIColor(red: 247/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        //cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentType == MenuType.THEORY{
            var dict:NSDictionary =  methodMenuList.objectAtIndex(section) as NSDictionary
            var list:NSArray = dict.objectForKey("list") as NSArray
            return list.count
        }
        else
        {
            return methodMenuList.count;
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.backgroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
        if (currentType == MenuType.THEORY) && indexPath.row == 0 && indexPath.section == 0{
            
            var cell:MenuCell = cell as MenuCell
            cell.menuView.updateTextColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
            //cell.menuView.updateBgColor(UIColor.whiteColor())
            
            lastSelectRow = indexPath

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        var cell:MenuCell?
        if lastSelectRow != nil{
            cell = tableView.cellForRowAtIndexPath(lastSelectRow!) as? MenuCell
            cell?.menuView.updateTextColor(UIColor.whiteColor())
            cell?.menuView?.updateBgColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
        }
        cell = tableView.cellForRowAtIndexPath(indexPath) as? MenuCell
        cell?.menuView.updateTextColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
        cell?.menuView?.updateBgColor(UIColor.whiteColor())
        cell?.selectionStyle = UITableViewCellSelectionStyle.Default
        
        lastSelectRow = indexPath
        var subMenuModel:SubMenuModel = SubMenuModel()
        
        switch currentType{
        case .CASE://案例
            println("case")
            subMenuModel.type = MenuType.CASE
        case .THEORY:
            println("theory")
            subMenuModel.type = MenuType.THEORY
        case .METHOD:
            println("method")
            subMenuModel.type = MenuType.METHOD
           
        }
        
        if (currentType.rawValue != MenuType.THEORY.rawValue){
            var dict:NSDictionary = methodMenuList.objectAtIndex(indexPath.row) as NSDictionary
            subMenuModel.cnName = dict.objectForKey("cnName") as String
            subMenuModel.enName = dict.objectForKey("enName") as String
            var flag: AnyObject? = dict.objectForKey("flag")
            if (flag != nil){
                subMenuModel.tableIndex = Int(flag!.integerValue)
            }
            else{
                subMenuModel.tableIndex = 0
            }
            NSNotificationCenter.defaultCenter().postNotificationName("SubAnimationMenuNotification", object: "OPEN")
            NSNotificationCenter.defaultCenter().postNotificationName("addSubMenuNotification", object: subMenuModel)
            
            
        }
        else{
            var fatherDict:NSDictionary = methodMenuList.objectAtIndex(indexPath.section) as NSDictionary
            var subList:NSArray = fatherDict.objectForKey("list") as NSArray
            var dict:NSDictionary = subList.objectAtIndex(indexPath.row) as NSDictionary
            subMenuModel.chapterID = dict.objectForKey("flag") as? String
            
            NSNotificationCenter.defaultCenter().postNotificationName("TheoryContentNotification", object: subMenuModel)
        }
    
        if (currentType.rawValue == MenuType.METHOD.rawValue){
            var plistpath:String?
            switch indexPath.row{
            case 0:
                plistpath = NSBundle.mainBundle().pathForResource("methodStage", ofType: "plist")
            case 1:
                plistpath = NSBundle.mainBundle().pathForResource("methodRequirement", ofType: "plist")
            case 2:
                plistpath = NSBundle.mainBundle().pathForResource("methodCategory", ofType: "plist")
            case 3:
                plistpath = NSBundle.mainBundle().pathForResource("methodObject", ofType: "plist")
            case 4:
                plistpath = NSBundle.mainBundle().pathForResource("methodDomain", ofType: "plist")
            default:
                break
            }
            var methodList:NSMutableArray = NSMutableArray(contentsOfFile: plistpath!)!
            var methodArray:Array = [MethodModel]()
            var methodModel:MethodModel?
            for dict in methodList{
                var list:NSArray = dict.objectForKey("list") as NSArray
                for tempDict in list{
                    methodModel = MethodModel()
                    methodModel?.cnName = tempDict.objectForKey("cnName") as? String
                    println(methodModel?.cnName)
                    methodModel?.iconName = tempDict.objectForKey("iconName") as String
                    println(methodModel?.iconName)
                    methodModel?.flag = tempDict.objectForKey("flag") as? String
                    println(methodModel?.flag)
                    methodArray.append(methodModel!)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ListContentNotification", object: methodArray)
        }
        else if (currentType.rawValue == MenuType.CASE.rawValue){
            var plistpath:String?
            switch indexPath.row{
            case 0:
                plistpath = NSBundle.mainBundle().pathForResource("caseStage", ofType: "plist")
            case 1:
                plistpath = NSBundle.mainBundle().pathForResource("caseRequirement", ofType: "plist")
            case 2:
                plistpath = NSBundle.mainBundle().pathForResource("caseCategory", ofType: "plist")
            case 3:
                plistpath = NSBundle.mainBundle().pathForResource("caseObject", ofType: "plist")
            case 4:
                plistpath = NSBundle.mainBundle().pathForResource("caseDomain", ofType: "plist")
            default:
                break
            }
            var caseList:NSMutableArray = NSMutableArray(contentsOfFile: plistpath!)!
            var caseArray:Array = [MethodModel]()
            var caseModel:MethodModel?
            for dict in caseList{
                var list:NSArray = dict.objectForKey("list") as NSArray
                for tempDict in list{
                    caseModel = MethodModel()
                    caseModel?.cnName = tempDict.objectForKey("cnName") as? String
                    caseModel?.iconName = tempDict.objectForKey("iconName") as? String
                    caseModel?.flag = tempDict.objectForKey("flag") as? String
                    caseArray.append(caseModel!)
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName("ListContentNotification", object: caseArray)
        }
    }

    
    func initMainMenu(){
        view1 = UIView(frame: CGRectMake(0, 0, 210, 100))
        var theoryBtn1:UIImageView = UIImageView(image: UIImage(named:"theoryBtn"))
        theoryBtn1.frame = CGRectMake(20, 17, 38, 65)
        theoryBtn1.contentMode = UIViewContentMode.ScaleAspectFit
        view1!.addSubview(theoryBtn1)
        var methodBtn1:UIImageView = UIImageView(image: UIImage(named:"methodBtn"))
        methodBtn1.frame = CGRectMake(85, 17, 38, 65)
        methodBtn1.contentMode = UIViewContentMode.ScaleAspectFit
        methodBtn1.tag = MenuType.CASE.rawValue
        view1!.addSubview(methodBtn1)
        var caseBtn1:UIImageView = UIImageView(image: UIImage(named:"caseBtn"))
        caseBtn1.frame = CGRectMake(150, 17, 38, 65)
        caseBtn1.contentMode = UIViewContentMode.ScaleAspectFit
        view1!.addSubview(caseBtn1)
        typeMenuScrollView.addSubview(view1!)
        
        view2 = UIView(frame: CGRectMake(210, 0, 210, 100))
        var theoryBtn2:UIImageView = UIImageView(image: UIImage(named:"theoryBtn"))
        theoryBtn2.frame = CGRectMake(150, 17, 38, 65)
        theoryBtn2.contentMode = UIViewContentMode.ScaleAspectFit
        view2!.addSubview(theoryBtn2)
        var methodBtn2:UIImageView = UIImageView(image: UIImage(named:"methodBtn"))
        methodBtn2.frame = CGRectMake(20, 17, 38, 65)
        methodBtn2.contentMode = UIViewContentMode.ScaleAspectFit
        methodBtn2.tag = MenuType.THEORY.rawValue
        view2!.addSubview(methodBtn2)
        var caseBtn2:UIImageView = UIImageView(image: UIImage(named:"caseBtn"))
        caseBtn2.frame = CGRectMake(85, 17, 38, 65)
        caseBtn2.contentMode = UIViewContentMode.ScaleAspectFit
        view2!.addSubview(caseBtn2)
        typeMenuScrollView.addSubview(view2!)
        
        view3 = UIView(frame: CGRectMake(420, 0, 210, 100))
        var theoryBtn3:UIImageView = UIImageView(image: UIImage(named:"theoryBtn"))
        theoryBtn3.frame = CGRectMake(85, 17, 38, 65)
        theoryBtn3.contentMode = UIViewContentMode.ScaleAspectFit
        view3!.addSubview(theoryBtn3)
        var methodBtn3:UIImageView = UIImageView(image: UIImage(named:"methodBtn"))
        methodBtn3.frame = CGRectMake(150, 17, 38, 65)
        methodBtn3.contentMode = UIViewContentMode.ScaleAspectFit
        methodBtn3.tag = MenuType.METHOD.rawValue
        view3!.addSubview(methodBtn3)
        var caseBtn3:UIImageView = UIImageView(image: UIImage(named:"caseBtn"))
        caseBtn3.frame = CGRectMake(20, 17, 38, 65)
        caseBtn3.contentMode = UIViewContentMode.ScaleAspectFit
        view3!.addSubview(caseBtn3)
        typeMenuScrollView.addSubview(view3!)
        typeMenuScrollView.contentSize = CGSizeMake(630, 0)
        typeMenuScrollView.delegate = self
    }
  
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (!scrollView.isKindOfClass(UITableView))
        {
            var pageWidth:CGFloat = scrollView.frame.size.width
            var currentPage:Int = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            
            if (currentPage == 0)
            {
                var view:UIView = view3!;
                self.view3 = self.view2;
                self.view2 = self.view1;
                self.view1 = view;
            }
            
            if (currentPage == 2)
            {
                //换指针
                var view:UIView = view1!;
                self.view1 = self.view2;
                self.view2 = self.view3;
                self.view3 = view;
            }
            
            //恢复原位
            self.view1!.frame = CGRectMake(0, 0, 210, 130)
            self.view2!.frame = CGRectMake(210, 0, 210, 130)
            self.view3!.frame = CGRectMake(420, 0, 210, 130)
            self.typeMenuScrollView.contentOffset = CGPointMake(210, 0);
            
            if let views = view1?.subviews{
                for view in views{
                    if view.isKindOfClass(UIImageView.classForCoder()){
                        if view.tag == MenuType.CASE.rawValue{
                            //案例
                            let plistpath = NSBundle.mainBundle().pathForResource("caseMenuList", ofType: "plist")!
                            methodMenuList = NSMutableArray(contentsOfFile: plistpath)
                            currentType = MenuType.CASE
                            eysImageView.hidden = true
                            aboutIcon.hidden = true
                            NSNotificationCenter.defaultCenter().postNotificationName("TypeMenuNotification", object: MenuType.CASE.rawValue)
                        }
                        else if view.tag == MenuType.THEORY.rawValue{
                            //理论
                            let plistpath = NSBundle.mainBundle().pathForResource("theoryMenuList", ofType: "plist")!
                            methodMenuList = NSMutableArray(contentsOfFile: plistpath)
                            currentType = MenuType.THEORY
                            eysImageView.hidden = true
                            aboutIcon.hidden = true
                            NSNotificationCenter.defaultCenter().postNotificationName("TypeMenuNotification", object: MenuType.THEORY.rawValue)
                        }
                        else if view.tag == MenuType.METHOD.rawValue{
                            //方法
                            let plistpath = NSBundle.mainBundle().pathForResource("methodMenuList", ofType: "plist")!
                            methodMenuList = NSMutableArray(contentsOfFile: plistpath)
                            currentType = MenuType.METHOD
                            eysImageView.hidden = false
                            aboutIcon.hidden = false
                            NSNotificationCenter.defaultCenter().postNotificationName("TypeMenuNotification", object: MenuType.METHOD.rawValue)
                        }
                        tableListView.reloadData()
                        baiduStatistic.logEvent("ScrollMenuType", eventLabel: "滚动类型菜单")
                    }
                }
            }
        }
    }
    
    
    func clickBackIcon(recognizer:UITapGestureRecognizer){
        println("Back...")
        NSNotificationCenter.defaultCenter().postNotificationName("SubAnimationMenuNotification", object: "CLOSE")
    }
    
    func clickAboutIcon(recognizer:UITapGestureRecognizer){
        if (!isAboutIconClicked){
            aboutIcon.alpha = 0.8
            isAboutIconClicked=true
        }
        else{
            
            aboutIcon.alpha = 0.5
            isAboutIconClicked=false
        }
    }
    
    func clickEyeIcon(recognizer:UITapGestureRecognizer){
        
        if (!isEyeClicked){
            eysImageView.alpha = 0.8
            isEyeClicked=true
        }
        else{
            
            eysImageView.alpha = 0.5
            isEyeClicked=false
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("EyeAnimationMenuNotification", object: nil)
    }
}