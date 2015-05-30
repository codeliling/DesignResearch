//
//  TipsView.swift
//  DesignBase
//
//  Created by lotusprize on 15/5/29.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import Foundation


class TipsView: UIView {
    
    convenience init(){
        self.init(frame:CGRectZero)
        self.layer.contents = UIImage(named: "nothing")?.CGImage
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
    func showNothingTips(){
        self.hidden = false
        UIView.animateWithDuration(2.5, animations: { () -> Void in
            var alpha:CGFloat = self.alpha
            alpha -= 1.0
            self.alpha = alpha
            }) { (Bool) -> Void in
                self.hidden = true
                self.alpha = 1.0
        }
    }
}