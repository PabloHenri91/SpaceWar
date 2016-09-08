//
//  TutorialDangerAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 06/09/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class TutorialDangerAlert:Box {
    var buttonOk: Button!
    
    init () {
        
        super.init(textureName: "redBox281x192")
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "DANGER" , fontSize: 14, x: 141, y: 26, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        self.addChild(MultiLineLabel(text: "Dont click on enemy to atack, click near. The ship only shot on enemys after stops moving.", maxWidth: 240, color: SKColor.blackColor(), fontSize: 12, x: 141, y: 75, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000))
        
        
        let fontShadowColor = SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 1)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.buttonOk = Button(textureName: "redButton131x30", text: "OK, I UNDERSTAND", fontSize: 11, x: 77, y: 155, fontColor: SKColor.whiteColor(), fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonOk)
        
        self.buttonOk.addHandler {
            self.removeFromParent()
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}