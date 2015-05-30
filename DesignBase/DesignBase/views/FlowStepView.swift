//
//  FlowStepView.swift
//  DesignBase
//
//  Created by lotusprize on 15/5/11.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit

class FlowStepView: UIView {
    
    var topLayer:CALayer!
    var bottomLayer:CALayer!
    var titleName:CATextLayer!
    var titleString:String?
    
    init(frame: CGRect, titleString:String) {
        super.init(frame: frame)
        self.titleString = titleString
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var retinaScreen:Bool = (UIScreen.mainScreen().currentMode?.size.width == 768)
        
        topLayer = CALayer()
        topLayer.contents = UIImage(named: "topArrow")?.CGImage
        topLayer.frame = CGRectMake(0, 0, 69, 32)
        self.layer.addSublayer(topLayer)
        
        bottomLayer = CALayer()
        bottomLayer.contents = UIImage(named: "bottomArrow")?.CGImage
        bottomLayer.frame = CGRectMake(0, 104, 69, 32)
        self.layer.addSublayer(bottomLayer)
        
        titleName = CATextLayer()
        titleName.frame = CGRectMake(15, 43, 40, 55)
        let fontName: CFStringRef = "SourceHanSansCN-Normal"
        //let fontName:CFStringRef = "Helvetica"
        titleName.font = CTFontCreateWithName(fontName, 16, nil)
        titleName.foregroundColor = UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1).CGColor!
        titleName.fontSize = 18;
        titleName.wrapped = true
        if (retinaScreen)
        {
            titleName.contentsScale = 1.0
        }
        else
        {
            titleName.contentsScale = 2.0
        }
        titleName.string = titleString
        titleName.wrapped = true;
        self.layer.addSublayer(titleName)
    }
}
