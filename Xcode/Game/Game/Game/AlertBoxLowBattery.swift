//
//  AlertBoxLowBattery.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/28/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class AlertBoxLowBattery: Box {
    
    var buttonOK:Button!
    var buttonCancel:Button!
    
    init() {
        super.init(textureName: "alertBoxRed")
        
        let gameScene = Control.gameScene
        gameScene.blackSpriteNode.hidden = false
        gameScene.blackSpriteNode.alpha = 1
        gameScene.blackSpriteNode.zPosition = 100000
        self.zPosition = 1000000
        gameScene.setAlertState()
        
        let fontColor0 = SKColor.whiteColor()
        let fontColor1 = SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1)
        let fontShadowColor0 = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowColor1 = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        let label0 = Label(color: fontColor0, text: "NO ENERGY TO BATTLE", fontSize: 12, x: 15, y: 21, horizontalAlignmentMode: .Left, shadowColor: fontShadowColor0, shadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(label0)
        
        let label1 = Label(color: fontColor1, text: "Ooops!", fontSize: 14, x: 142, y: 76, shadowColor: fontShadowColor1, shadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(label1)
        
        let label2 = Label(color: fontColor1, text: "It looks like you have no energy to fight.", fontSize: 11, x: 142, y: 91, shadowColor: fontShadowColor1, shadowOffset: fontShadowOffset, fontName: GameFonts.fontName.museo500)
        self.addChild(label2)
        
        let label3 = Label(color: fontColor1, text: "You can recharge at the", fontSize: 11, x: 142, y: 117, verticalAlignmentMode: .Baseline, horizontalAlignmentMode: .Right, shadowColor: fontShadowColor1, shadowOffset: fontShadowOffset, fontName: GameFonts.fontName.museo500)
        self.addChild(label3)
        
        let label4 = Label(color: fontColor1, text: "SPACE SHOP.", fontSize: 11, x: 142, y: 117, verticalAlignmentMode: .Baseline, horizontalAlignmentMode: .Left, shadowColor: fontShadowColor1, shadowOffset: fontShadowOffset, fontName: GameFonts.fontName.museo1000)
        self.addChild(label4)
        
        let positionX: CGFloat = 142
        let positionY: CGFloat = 117
        
        let translateX: CGFloat = (label3.calculateAccumulatedFrame().width - label4.calculateAccumulatedFrame().width)/2
        
        label3.screenPosition = CGPoint(x: positionX + translateX, y: positionY)
        label3.resetPosition()
        
        label4.screenPosition = CGPoint(x: positionX + translateX, y: positionY)
        label4.resetPosition()
        
        self.buttonCancel = Button(textureName: "buttonCloseRed", x: 247, y: 10, top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonOK = Button(textureName: "rateButtonCancel", text: "GO TO SPACE SHOP", fontSize: 11, x: 76, y: 169, fontColor: fontColor0, fontShadowColor: fontShadowColor0, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonOK)
        
        
        
        
        self.jump()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
