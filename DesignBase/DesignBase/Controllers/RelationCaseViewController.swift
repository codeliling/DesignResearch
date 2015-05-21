//
//  RelationCaseViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/5/15.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit
import Alamofire

class RelationCaseViewController: ViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var methodId:String?
    var dataList:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var backTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doHandlerBack:")
        backImage.addGestureRecognizer(backTap)
        
        dataList = NSMutableArray()
       self.doHandlerCaseList()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var methodModel:MethodModel = dataList[indexPath.row] as MethodModel
        var imageCell:CaseListCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as CaseListCell
        imageCell.image.image = UIImage(named: methodModel.iconName)
        
        return imageCell

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func doHandlerCaseList(){
        self.view.makeToastActivity()
        println(methodId)
        if methodId != nil{
            var url:String = RequestURL.ServerMethodURL + methodId!
            println(url)
            Alamofire.request(.GET, url).responseJSON({ (_, _, JSON, error) -> Void in
                
                if (error == nil){
                    var dict:NSDictionary = JSON as NSDictionary
                    var studyCases:[Int] = dict.objectForKey("study_cases") as Array
                    if studyCases.count == 0{
                        self.view.hideToastActivity()
                        self.view.makeToast("无关联案例", duration: 2.0, position:CSToastPositionCenter)
                    }
                    else{
                        self.view.hideToastActivity()
                        var methodModel:MethodModel?
                        for i in studyCases{
                            methodModel = MethodModel()
                            if (i > 9){
                                methodModel?.iconName = "S1408W0" + String(i)
                            }
                            else{
                                methodModel?.iconName = "S1408W00" + String(i)
                            }
                            methodModel?.flag = String(i)
                            self.dataList.addObject(methodModel!)
                        }
                        self.collectionView.reloadData()
                        
                    }
                    
                }
                
            })
        }
        
    }
    
    func doHandlerBack(gesture:UITapGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
