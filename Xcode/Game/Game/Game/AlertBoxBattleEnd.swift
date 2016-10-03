//
//  AlertBoxBattleEnd.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/29/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class AlertBoxBattleEnd: Box {
    
    var buttonOK: Button!
    
    enum types {
        case win
        case lose
        case draw
    }
    
    init(type: types, xp: Int, xpMax: Int, points: Int, pointsMax: Int, killerSpaceship: Spaceship? = nil) {
        
        var textureName = ""
        var buttonTextureName = ""
        
        var titleText = ""
        
        switch type {
        case .win:
            textureName = "alertBoxBattleWinBackground"
            buttonTextureName = "rateButtonOk"
            titleText = "YOU WIN!"
            break
        case .lose:
            textureName = "alertBoxBattleLoseBackground"
            buttonTextureName = "rateButtonCancel"
            titleText = "YOU LOSE."
            break
        case .draw:
            textureName = "alertBoxBattleDrawBackground"
            buttonTextureName = "alertButtonRemindLater"
            titleText = "DRAW."
            break
        }
        
        super.init(textureName: textureName)
        
        let gameScene = Control.gameScene
        gameScene.blackSpriteNode.hidden = false
        gameScene.blackSpriteNode.alpha = 1
        gameScene.blackSpriteNode.zPosition = 100000
        self.zPosition = 1000000
        
        self.addChild(Control(textureName: "alertBoxBattleBackground1", x: 0, y: 59))
        
        let fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.addChild(Label(color: fontColor, text: titleText, fontSize: 16, x: 142, y: 21, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        self.buttonOK = Button(textureName: buttonTextureName, text: "FINISH", fontSize: 13, x: 77, y: 333, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonOK)
        
        self.jump()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
