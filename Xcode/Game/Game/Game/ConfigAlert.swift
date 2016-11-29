//
//  ConfigAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 07/11/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//



import SpriteKit

class ConfigAlert: Box {
    
    var buttonCancel:Button!
    var buttonOK:Button!
    var musicSwitch:Switch!
    var soundFxSwitch:Switch!
    var playerData = MemoryCard.sharedInstance.playerData

    
    
    
    init() {
        
        
        super.init(textureName: "darkBlueBox282x285")
        
        let scene = Control.gameScene
        scene.blackSpriteNode.hidden = false
        scene.blackSpriteNode.zPosition = 1000000000
        
        self.zPosition = scene.blackSpriteNode.zPosition + 1
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "CONFIG" , fontSize: 14, x: 141, y: 26, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        
        
        let fontShadowColor = SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 1)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.musicSwitch = Switch(textureName: "music", on: self.playerData.musicEnabled.boolValue, x: 72, y: 66)
        self.musicSwitch.setBlock { 
            self.playerData.musicEnabled = NSNumber(bool: self.musicSwitch.on)
            Music.sharedInstance.play()
        }
        self.addChild(self.musicSwitch)
        
        
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "MUSIC", fontSize: 12, x: 92, y: 118, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        
        self.soundFxSwitch = Switch(textureName: "soundFx", on: self.playerData.soundEnabled.boolValue, x: 178, y: 66)
        self.soundFxSwitch.setBlock {
            self.playerData.soundEnabled = NSNumber(bool: self.soundFxSwitch.on)
        }
        self.addChild(self.soundFxSwitch)
        
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "SOUND FX", fontSize: 12, x: 195, y: 118, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        
        
        let buttonCredits = Button(textureName: "buttonDarkBlue131x30", text: "CREDITS", fontSize: 11, x: 77, y: 183, fontColor: SKColor.whiteColor(), fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(buttonCredits)
        
        buttonCredits.addHandler {
            self.addChild(Credits())
        }
        
        
        self.buttonOK = Button(textureName: "buttonDarkBlue131x30", text: "OK", fontSize: 11, x: 77, y: 234, fontColor: SKColor.whiteColor(), fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonOK)
        
        self.buttonOK.addHandler {
            scene.blackSpriteNode.hidden = true
            scene.setDefaultState()
            self.removeFromParent()
        }
        
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 246, y: 10,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel!)
        
        self.buttonCancel!.addHandler({ [weak self] in
            scene.blackSpriteNode.hidden = true
            scene.setDefaultState()
            self?.removeFromParent()
            })
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
