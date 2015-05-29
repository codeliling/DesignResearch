//
//  SubMenuView.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/23.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit

class SubMenuView: UIView {
    var chineseMenu:CATextLayer!
    var enMenu:CATextLayer!
    var chineseTitle:String!
    var enTitle:String!
    var bgLayer:CALayer!
    
    override init() {
        super.init()
        chineseMenu = CATextLayer()
        enMenu = CATextLayer()
        bgLayer = CALayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    init(frame: CGRect, chineseTitle:String, enTitle:String) {
        super.init(frame: frame)
        self.chineseTitle = chineseTitle
        self.enTitle = enTitle
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var retinaScreen:Bool = (UIScreen.mainScreen().currentMode?.size.width == 1024)
        
        if bgLayer != nil{
            bgLayer.frame = CGRectMake(0, 0, 80, 56)
            self.layer.addSublayer(bgLayer)
        }
        
        if chineseMenu != nil{
            
            let fontName: CFStringRef = "SourceHanSansCN-Normal"
            //let fontName:CFStringRef = "Helvetica"
            chineseMenu.font = CTFontCreateWithName(fontName, 14, nil)
            chineseMenu.frame = CGRectMake(8, 12, 80, 25)
            chineseMenu.fontSize = 16;
            if (retinaScreen)
            {
                chineseMenu.contentsScale = 1.0
            }
            else
            {
                chineseMenu.contentsScale = 2.0
            }
            chineseMenu.string = chineseTitle
            self.layer.addSublayer(chineseMenu)
        }
        
        
        
        if enMenu != nil{
            
            let enFontName:CFStringRef = "Candara"
            enMenu.font = CTFontCreateWithName(enFontName, 8, nil)
            enMenu.frame = CGRectMake(8, 35, 80, 30)
            enMenu.fontSize = 10
            if (retinaScreen)
            {
                enMenu.contentsScale = 1.0
            }
            else
            {
                enMenu.contentsScale = 2.0
            }
            enMenu.string = enTitle
            self.layer.addSublayer(enMenu)
        }
        
        var path:CGMutablePathRef = CGPathCreateMutable()
        var rect:CGRect = CGRectMake(0, 0, 80, 56);
        CGPathAddRect(path, nil, rect)
        var context:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path)
        CGContextSetRGBFillColor(context, 247/255.0, 248.0/255.0, 248.0/255.0, 1)
        UIColor(red: 102/255.0, green: 59/255.0, blue: 209/255.0, alpha: 1).setStroke()
        
        CGContextSetLineWidth(context, 5)
        CGContextDrawPath(context,kCGPathFillStroke)
    }
    
    func updateTextColor(color:UIColor){
        chineseMenu?.foregroundColor = color.CGColor!
        enMenu?.foregroundColor = color.CGColor!
    }
    
    func updateBgColor(color:UIColor){
        bgLayer.backgroundColor = color.CGColor!
        
    }
}
