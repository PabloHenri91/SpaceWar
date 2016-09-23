//
//  TutorialAlertBox.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 02/09/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class TutorialAlertBox:Box {
    var buttonOk: Button!
    
    init (text: String, buttonText: String) {
        
        super.init(textureName: "darkBlueBox281x192")
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "TUTORIAL" , fontSize: 14, x: 141, y: 26, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        self.addChild(MultiLineLabel(text: text, maxWidth: 240, color: SKColor.blackColor(), fontSize: 12, x: 141, y: 87, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000))
        
        
        let fontShadowColor = SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 1)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.buttonOk = Button(textureName: "buttonDarkBlue131x30", text: buttonText, fontSize: 11, x: 77, y: 150, fontColor: SKColor.whiteColor(), fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonOk)
        
        self.buttonOk.addHandler {
            self.removeFromParent()
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}