//
//  MenuView.swift
//  DesignBase
//
//  Created by lotusprize on 15/4/23.
//  Copyright (c) 2015年 geekTeam. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    var chineseMenu:CATextLayer!
    var enMenu:CATextLayer!
    var chineseTitle:String!
    var enTitle:String!
    
    override init() {
        super.init()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, chineseTitle:String, enTitle:String) {
        super.init(frame: frame)
        self.chineseTitle = chineseTitle
        self.enTitle = enTitle
        chineseMenu = CATextLayer()
        enMenu = CATextLayer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var retinaScreen:Bool = (UIScreen.mainScreen().currentMode?.size.width == 768)
       
        if chineseMenu != nil{
        let fontName: CFStringRef = "SourceHanSansCN-Normal"
        //let fontName:CFStringRef = "Helvetica"
        chineseMenu.font = CTFontCreateWithName(fontName, 16, nil)
        chineseMenu.frame = CGRectMake(15, 15, 180, 25)
        chineseMenu.fontSize = 16;
        if (retinaScreen)
        {
            chineseMenu.contentsScale = 1.0
        }
        else
        {
            chineseMenu.contentsScale = 2.0
        }
        self.layer.addSublayer(chineseMenu)
        
        chineseMenu.string = chineseTitle
        }
        
        if (enMenu != nil){
            
        let enFontName:CFStringRef = "Candara"
        enMenu.font = CTFontCreateWithName(enFontName, 10, nil)
        enMenu.frame = CGRectMake(15, 40, 180, 30)
        enMenu.fontSize = 10
        
        if (retinaScreen)
        {
            enMenu.contentsScale = 1.0
        }
        else
        {
            enMenu.contentsScale = 2.0
        }
        self.layer.addSublayer(enMenu)
        
        enMenu.string = enTitle
        }
     }
    
    func updateTextColor(color:UIColor){
        chineseMenu?.foregroundColor = color.CGColor!
        enMenu?.foregroundColor = color.CGColor!
    }
    
    func updateFrame(x:CGFloat){
        chineseMenu?.frame = CGRectMake(15 + x, 5, 170, 25)
        enMenu?.frame = CGRectMake(15 + x, 30, 170, 30)
    }
}
