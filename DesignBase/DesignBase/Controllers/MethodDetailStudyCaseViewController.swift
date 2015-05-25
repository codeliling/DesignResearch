//
//  MethodDetailStudyCaseViewController.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/28.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit
import Foundation

class MethodDetailStudyCaseViewController: UIViewController {

    var textView:UITextView!
    var showView:UIView?
    var bgImageView:UIImageView!
    
    var threeCoordinate:[(CGFloat,CGFloat)] = [(238.0, 255.0),(366.0, 255.0),(495.0, 255.0)]
    var fourCoordinate:[(CGFloat,CGFloat)] = [(160.0, 255.0),(280.0, 255.0),(400.0, 255.0),(520.0, 255.0)]
    var fiveCoordinate:[(CGFloat,CGFloat)] = [(127.0, 255.0),(248.0, 255.0),(376.0, 255.0),(505.0, 255.0),(627.0, 255.0)]
    let viewWidth:CGFloat = 69.0
    let viewHeight:CGFloat = 167.0
    
    var data:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView = UITextView()
        
        textView.frame.size = CGSizeMake(150, 200)
        textView.font = UIFont(name: "SourceHanSansCN-Normal", size: 12)
        textView.backgroundColor = UIColor.clearColor()
        textView.hidden = true
        textView.textColor = UIColor.darkGrayColor()
        textView.alpha = 0
        
        self.view.addSubview(textView)
        
        bgImageView = UIImageView(image: UIImage(named: "textbg"))
        bgImageView?.frame.size = CGSizeMake(170, 230)
        bgImageView.hidden = true
        self.view.addSubview(bgImageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("view did appear")
    }
    
    func addStepsView(){
        if data != nil{
            
            if (data?.count == 3){
                var i = 0
                for dict in data!{
                    var stepObject:NSDictionary = dict as NSDictionary
                    let (x, y) = threeCoordinate[i]
                    self.addFlowStepView(x, y: y, tagId:i, dict: dict as NSDictionary)
                    i++;
                    
                }
            }
            else if (data?.count == 4){
                var i = 0
                for dict in data!{
                    var stepObject:NSDictionary = dict as NSDictionary
                    let (x, y) = fourCoordinate[i]
                    self.addFlowStepView(x, y: y, tagId:i, dict: dict as NSDictionary)
                    i++;
                }
            }
            else if (data?.count == 5){
                var i = 0
                for dict in data!{
                    var stepObject:NSDictionary = dict as NSDictionary
                    let (x, y) = fiveCoordinate[i]
                    self.addFlowStepView(x, y: y, tagId:i, dict: dict as NSDictionary)
                    i++;
                }
            }
        }
    }
    
    func addFlowStepView(x:CGFloat, y:CGFloat,tagId:Int, dict:NSDictionary){
        var flowStepView:FlowStepView = FlowStepView(frame: CGRectMake(x, y, viewWidth, viewHeight), titleString: dict.objectForKey("name") as String!)
        flowStepView.backgroundColor = UIColor.clearColor()
        flowStepView.tag = tagId
        self.view.addSubview(flowStepView)
        var swipGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"swipAction:")
        swipGesture.direction = UISwipeGestureRecognizerDirection.Up
        flowStepView.addGestureRecognizer(swipGesture)
    }
    
    func swipAction(gesture:UIGestureRecognizer){
        println("gesture")
        
        var viewTag:Int = 0
        if let view = gesture.view{
            viewTag = view.tag
        }
        
        var dict:NSDictionary = data?.objectAtIndex(viewTag) as NSDictionary
        textView.text = dict.objectForKey("description_text") as String
        
        if let sView = showView{
            recoverStateByAnimation(sView, formerView: gesture.view!)
        }
        else
        {
            self.textView.center = CGPointMake(gesture.view!.center.x, gesture.view!.center.y + 150)
            self.bgImageView.center = CGPointMake(gesture.view!.center.x, gesture.view!.center.y + 80)
            animationFunction(gesture.view!)
        }
        gesture.view?.hidden
    }
    
    func animationFunction(view:UIView){
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            view.alpha = 0
        }) { (Bool) -> Void in
            view.hidden = true
        }
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            var point:CGPoint? = view.center
            point?.y -= 100
            view.center = point!
        }) { (Bool) -> Void in
            view.hidden = true
        }
        
        self.textView.hidden = false
        UIView.animateWithDuration(1.5, delay: 0.4, options: nil, animations: { () -> Void in
             self.textView!.alpha = 1
        }) { (Bool) -> Void in
            
        }
        
        self.bgImageView.hidden = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bgImageView.alpha = 1
            }) { (Bool) -> Void in
        }
        
        UIView.animateWithDuration(1.5, delay: 0.4, options: nil, animations: { () -> Void in
            self.textView.center = CGPointMake(view.center.x, self.textView.center.y - 80)
            }) { (Bool) -> Void in
                self.bgImageView.hidden = false
            
        }
        showView = view
    }
    
    func recoverStateByAnimation(view:UIView, formerView:UIView){
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            view.alpha = 1
            }) { (Bool) -> Void in
                view.hidden = false
        }
        
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            var point:CGPoint? = view.center
            point?.y += 100
            view.center = point!
            }) { (Bool) -> Void in
                view.hidden = false
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bgImageView.alpha = 0
            }) { (Bool) -> Void in
                self.bgImageView.hidden = true
                self.bgImageView.center = CGPointMake(formerView.center.x, formerView.center.y + 80)
        }
        
        self.textView.hidden = false
        UIView.animateWithDuration(0.5, delay: 0.1, options: nil, animations: { () -> Void in
            self.textView!.alpha = 0
            }) { (Bool) -> Void in
                
        }
        
        UIView.animateWithDuration(0.5, delay: 0.1, options: nil, animations: { () -> Void in
            self.textView.center = CGPointMake(view.center.x, self.textView.center.y + 150)
            }) { (Bool) -> Void in
                self.textView.hidden = true
                self.textView.alpha = 0
                self.textView.center = CGPointMake(formerView.center.x, formerView.center.y + 150)
                self.animationFunction(formerView)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
