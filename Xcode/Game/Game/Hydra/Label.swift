//
//  Label.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import SpriteKit

class Label: Control {
    
    var labelNode:SKLabelNode!
    var shadowLabelNode:SKLabelNode!
    
    init(color:SKColor = GameColors.black, text:String, fontSize:CGFloat = 16, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up , verticalAlignmentMode:SKLabelVerticalAlignmentMode = .center, horizontalAlignmentMode:SKLabelHorizontalAlignmentMode = .center, fontName: String = GameFonts.fontName.museo500, shadowColor:SKColor = SKColor.clear, shadowOffset:CGPoint = CGPoint.zero) {
        super.init()
        self.load(color, text:text, fontSize:fontSize, x:x, y:y, xAlign:xAlign, yAlign:yAlign, verticalAlignmentMode:verticalAlignmentMode, horizontalAlignmentMode:horizontalAlignmentMode, fontName: fontName, shadowColor: shadowColor, shadowOffset: shadowOffset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(_ color:SKColor, text:String, fontSize:CGFloat, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, verticalAlignmentMode:SKLabelVerticalAlignmentMode, horizontalAlignmentMode:SKLabelHorizontalAlignmentMode, fontName: String, shadowColor:SKColor, shadowOffset:CGPoint) {
        self.screenPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        
        self.resetPosition()
        
        self.labelNode = SKLabelNode(fontNamed: fontName)
        self.labelNode.text = text.translation()
        self.labelNode.fontSize = fontSize < GameFonts.minFontSize ? GameFonts.minFontSize : fontSize
        self.labelNode.fontColor = color
        self.labelNode.verticalAlignmentMode = verticalAlignmentMode
        self.labelNode.horizontalAlignmentMode = horizontalAlignmentMode
        
        self.shadowLabelNode = SKLabelNode(fontNamed: fontName)
        self.shadowLabelNode.position = shadowOffset
        self.shadowLabelNode.text = self.labelNode.text
        self.shadowLabelNode.fontSize = fontSize < GameFonts.minFontSize ? GameFonts.minFontSize : fontSize
        self.shadowLabelNode.fontColor = shadowColor
        self.shadowLabelNode.verticalAlignmentMode = verticalAlignmentMode
        self.shadowLabelNode.horizontalAlignmentMode = horizontalAlignmentMode
        
        self.addChild(self.shadowLabelNode)
        self.addChild(self.labelNode)
        
        Control.controlList.insert(self)
    }
    
    func getText() -> String{
        if let text = self.labelNode.text {
            return text
        } else {
           return ""
        }
    }
    
    func setText(_ text:String) {
        self.labelNode.text = text.translation()
        self.shadowLabelNode.text = self.labelNode.text
    }
    
    func setText(_ text:String, color:SKColor) {
        self.labelNode.fontColor = color
        self.labelNode.text = text.translation()
        self.shadowLabelNode.text = self.labelNode.text
    }
}
