//
//  RateAlert.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/26/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class RateAlert: Box {
    
    var buttonOk: Button!
    var buttonCancel: Button!
    var buttonRemindLater: Button!
    
    init(rateMyApp: RateMyApp) {
        super.init(textureName: "alertBackground284x291")
        
        let gameScene = Control.gameScene
        gameScene.blackSpriteNode.hidden = false
        gameScene.blackSpriteNode.alpha = 1
        gameScene.blackSpriteNode.zPosition = 1000000
        self.zPosition = 10000000
        gameScene.setAlertState()
        
        let fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        let fontSize: CGFloat = 11
        
        self.addChild(Label(color: fontColor, text: rateMyApp.alertTitle.uppercaseString, fontSize: 12, x: 142, y: 24, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        self.addChild(MultiLineLabel(text: rateMyApp.alertMessage, color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), fontSize: 12, x: 142, y: 70, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        self.buttonOk = Button(textureName: "rateButtonOk", text: rateMyApp.alertOKTitle.uppercaseString, fontSize: fontSize, x: 77, y: 150, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonOk)
        self.buttonOk.addHandler { [weak rateMyApp, weak self] in
            rateMyApp?.okButtonPressed()
            self?.removeFromParent()
            gameScene?.blackSpriteNode.hidden = true
            gameScene?.setDefaultState()
        }
        
        self.buttonRemindLater = Button(textureName: "alertButtonRemindLater", text: rateMyApp.alertRemindLaterTitle.uppercaseString, fontSize: fontSize, x: 77, y: 195, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonRemindLater)
        self.buttonRemindLater.addHandler { [weak rateMyApp, weak self] in
            rateMyApp?.remindLaterButtonPressed()
            self?.removeFromParent()
            gameScene?.blackSpriteNode.hidden = true
            gameScene?.setDefaultState()
        }
        
        self.buttonCancel = Button(textureName: "rateButtonCancel", text: rateMyApp.alertCancelTitle.uppercaseString, fontSize: fontSize, x: 77, y: 240, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonCancel)
        self.buttonCancel.addHandler { [weak rateMyApp, weak self, weak gameScene] in
            rateMyApp?.cancelButtonPressed()
            self?.removeFromParent()
            gameScene?.blackSpriteNode.hidden = true
            gameScene?.setDefaultState()
        }
        
        self.pop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pop() {
        let x = self.position.x - (self.size.width/2) * 0.1
        let y = self.position.y + (self.size.height/2) * 0.1
        
        self.setScale(0)
        self.position = CGPoint(x: Display.currentSceneSize.width/2, y: -Display.currentSceneSize.height/2)
        
        let duration:Double = 0.10
        
        let action1 = SKAction.group([
            SKAction.scaleTo(1.1, duration: duration),
            SKAction.moveTo(CGPoint(x: x, y: y), duration: duration)
            ])
        
        let action2 = SKAction.group([
            SKAction.scaleTo(1, duration: duration),
            SKAction.moveTo(self.getPositionWithScreenPosition(self.screenPosition), duration: duration)
            ])
        
        self.runAction(SKAction.sequence([action1, action2]))
    }
}
