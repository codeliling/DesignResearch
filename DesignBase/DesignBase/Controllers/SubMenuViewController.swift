//
//  SubMenuViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/22.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit

class SubMenuViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var titleView:MenuView?
    var collectionView:UICollectionView?
    var subMenuData:NSMutableArray!
    let blueColor:UIColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1)
    let lightGrayColor:UIColor = UIColor(red: 247/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
    var lastCellSubMenuView:SubMenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        subMenuData = NSMutableArray()
        
        var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.itemSize = CGSizeMake(100, 80);
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        
        collectionView = UICollectionView(frame: CGRectMake(0, 180, 210, 650),collectionViewLayout:layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = lightGrayColor
        
        collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(collectionView!)
        
        titleView = MenuView(frame: CGRectMake(10, 110, 130, 50))
        titleView?.backgroundColor = lightGrayColor
        self.view.addSubview(titleView!)
        
        var lineLayer:CALayer = CALayer()
        lineLayer.frame = CGRectMake(23, 165, 170, 3)
        lineLayer.backgroundColor = blueColor.CGColor
        self.view.layer.addSublayer(lineLayer)
        
        var verticalLineLayer:CALayer = CALayer()
        verticalLineLayer.frame = CGRectMake(209, 0, 13, 768)
        verticalLineLayer.contents = UIImage(named: "line")?.CGImage
        self.view.layer.addSublayer(verticalLineLayer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification:", name: "addSubMenuNotification", object: nil)
    }
    
    func methodOfReceivedNotification(notification: NSNotification){
        //Action take on Notification
        var subMenuModel = notification.object as SubMenuModel
        switch subMenuModel.type.rawValue{
        case MenuType.CASE.rawValue:
            println("...case \(subMenuModel.type.rawValue), \(subMenuModel.tableIndex)")
            titleView?.chineseTitle = subMenuModel.cnName
            titleView?.enTitle = subMenuModel.enName
            titleView?.updateTextColor(blueColor)
            titleView?.setNeedsDisplay()
            addCaseSubMenuList(subMenuModel.tableIndex!)
        case MenuType.THEORY.rawValue:
            println("...theory \(subMenuModel.type.rawValue), \(subMenuModel.tableIndex)")
        case MenuType.METHOD.rawValue:
            println("...method \(subMenuModel.type.rawValue), \(subMenuModel.tableIndex)")
            titleView?.chineseTitle = subMenuModel.cnName
            titleView?.enTitle = subMenuModel.enName
            titleView?.updateTextColor(blueColor)
            titleView?.setNeedsDisplay()
            addMethodSubMenuList(subMenuModel.tableIndex!)
        default:
            println("...fault type")
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subMenuData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var dict:NSDictionary = subMenuData?.objectAtIndex(indexPath.row) as NSDictionary
        var cell:UICollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? UICollectionViewCell
        println(indexPath.row)
        
        if let views = cell?.contentView.subviews{
            var isHasSubMenuView:Bool = false
            for subMenuView in views{
                if (subMenuView.isKindOfClass(SubMenuView.classForCoder()))
                {
                    var subMenuView = subMenuView as SubMenuView
                    subMenuView.chineseTitle = dict.objectForKey("cnName") as String
                    subMenuView.enTitle = dict.objectForKey("enName") as String
                    subMenuView.bgLayer.backgroundColor = UIColor.clearColor().CGColor!
                    subMenuView.updateTextColor(blueColor)
                    subMenuView.setNeedsDisplay()
                    if (indexPath.row % 2 == 0){
                        subMenuView.frame = CGRectMake(20, 10, 80, 56)
                    }
                    else{
                        subMenuView.frame = CGRectMake(5, 10, 80, 56)
                    }
                    
                    isHasSubMenuView = true
                }
            }
            println(isHasSubMenuView)
            if (!isHasSubMenuView)
            {
                var subMenuView:SubMenuView = SubMenuView()
                subMenuView.chineseTitle = dict.objectForKey("cnName") as String
                subMenuView.enTitle = dict.objectForKey("enName") as String
                if (indexPath.row % 2 == 0){
                    subMenuView.frame = CGRectMake(20, 10, 80, 56)
                }
                else{
                    subMenuView.frame = CGRectMake(5, 10, 80, 56)
                }
                cell?.contentView.addSubview(subMenuView)
            }
            
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.row) is click...")
        var dict:NSDictionary = subMenuData?.objectAtIndex(indexPath.row) as NSDictionary
        var methodList =  [MethodModel]()
        
        var mModel:MethodModel;
        for methodModel in dict.objectForKey("list") as NSArray{
            var dict:NSDictionary = methodModel as NSDictionary
            mModel = MethodModel()
            mModel.cnName = dict.objectForKey("cnName") as? String
            mModel.flag = dict.objectForKey("flag") as? String
            mModel.iconName = dict.objectForKey("iconName") as? String
            if let object: AnyObject = dict.objectForKey("enName"){
                mModel.enName = dict.objectForKey("enName") as? String
            }
            methodList.append(mModel)
        }
        
        if lastCellSubMenuView != nil{
            lastCellSubMenuView?.updateTextColor(blueColor)
            lastCellSubMenuView?.updateBgColor(UIColor.clearColor())
        }
        
        var cell:UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        for subMenuView in cell.contentView.subviews{
            if (subMenuView.isKindOfClass(SubMenuView.classForCoder()))
            {
                var subMenu:SubMenuView = subMenuView as SubMenuView
                subMenu.updateTextColor(UIColor.whiteColor())
                subMenu.updateBgColor(UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1))
                subMenu.layer.insertSublayer(subMenu.bgLayer, atIndex: 0)
                lastCellSubMenuView = subMenu
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("ListContentNotification", object: methodList)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func addMethodSubMenuList(rowIndex:Int){
        var pListPath:String?
        switch rowIndex{
        case MethodTypeList.APPLICATION_PHASE.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("methodStage", ofType: "plist")
        case MethodTypeList.DESIGN_REQUIREMENT.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("methodRequirement", ofType: "plist")
        case MethodTypeList.RESEARCH_CLASSIFICATION.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("methodCategory", ofType: "plist")
        case MethodTypeList.USING_OBJECT.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("methodObject", ofType: "plist")
        case MethodTypeList.MAIN_FIELD.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("methodDomain", ofType: "plist")
        default:
            println("method menu fault")
        }
        
        subMenuData = NSMutableArray(contentsOfFile: pListPath!)
        println("sub menu data count:\(subMenuData.count)")
        collectionView?.reloadData()
    }
    
    func addCaseSubMenuList(rowIndex:Int){
        var pListPath:String?
        switch rowIndex{
        case CaseTypeList.TIME_SPECIFIC_YEAR.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("caseStage", ofType: "plist")
        case CaseTypeList.DESIGN_REQUIREMENT.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("caseRequirement", ofType: "plist")
        case CaseTypeList.RESEARCH_CLASSIFICATION.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("caseCategory", ofType: "plist")
        case CaseTypeList.USING_OBJECT.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("caseObject", ofType: "plist")
        case CaseTypeList.MAIN_FIELD.rawValue:
            pListPath = NSBundle.mainBundle().pathForResource("caseDomain", ofType: "plist")
        default:
            println("method menu fault")
        }
        
        subMenuData = NSMutableArray(contentsOfFile: pListPath!)
        println("sub menu data count:\(subMenuData.count)")
        lastCellSubMenuView = nil
        collectionView?.reloadData()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "addSubMenuNotification", object: nil)
    }
}
