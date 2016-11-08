//
//  BuySpaceshipAlert.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 8/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BuySpaceshipAlert: Box {

    var buttonCancel:Button!
    var buttonBuy:Button!
    
    var spaceship: Spaceship!
    
    init(spaceship: Spaceship, count: Int) {
        let spriteNode = SKSpriteNode(imageNamed: "buyMinnerSpaceshipAlert")
        super.init(spriteNode: spriteNode)
        
        self.spaceship = spaceship
        
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 105, y: -60,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
            })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "BUY SPACESHIP" , fontSize: 13, x: -127, y: -48, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        let labelLevel = Label(text: spaceship.displayName().uppercaseString, fontSize: 11, x: -127, y: -8 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelLevel)
        
        let labelAmount = Label(text: "YOU HAVE ".translation() + count.description + "/4" , fontSize: 11, x: -78, y: 14 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo500, horizontalAlignmentMode: .Left)
        self.addChild(labelAmount)
        
        let labelBuy = Label(text: "BUY" , fontSize: 11, x: 61, y: 14 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelBuy)
        
        self.buttonBuy = Button(textureName: "buttonOrangeFragments", text: GameMath.spaceshipPrice(spaceship.type).description, fontSize: 13, x: 61, y: 26, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
        self.addChild(self.buttonBuy)
        
        
        
        let minnerSpaceship = Control(textureName: "minnerSpaceshipTiny", x: -128, y: 9, alpha: 0)
        self.addChild(minnerSpaceship)
        
        let minnerSpaceshipTinySpaceship = Spaceship(type: spaceship.type.index, level: spaceship.level)
        minnerSpaceshipTinySpaceship.setScale(min(minnerSpaceship.size.width/minnerSpaceshipTinySpaceship.size.width, minnerSpaceship.size.height/minnerSpaceshipTinySpaceship.size.height))
        minnerSpaceshipTinySpaceship.position = CGPoint(x: minnerSpaceship.size.width/2, y: -minnerSpaceship.size.height/2)
        minnerSpaceship.addChild(minnerSpaceshipTinySpaceship)
        
        
        for i in 0..<count {
            let x = -78 + 27 * i
            let minnerSpaceship = Control(textureName: "minnerSpaceshipSmallBuyed", x: x, y: 30, alpha: 0)
            self.addChild(minnerSpaceship)
            
            let minnerSpaceshipTinySpaceship = Spaceship(type: spaceship.type.index, level: spaceship.level)
            minnerSpaceshipTinySpaceship.setScale(min(minnerSpaceship.size.width/minnerSpaceshipTinySpaceship.size.width, minnerSpaceship.size.height/minnerSpaceshipTinySpaceship.size.height))
            minnerSpaceshipTinySpaceship.position = CGPoint(x: minnerSpaceship.size.width/2, y: -minnerSpaceship.size.height/2)
            minnerSpaceship.addChild(minnerSpaceshipTinySpaceship)
        }
        
        for i in count..<4 {
            let x = -78 + 27 * i
            let minnerSpaceship = Control(textureName: "minnerSpaceshipUnlocked", x: x, y: 30, alpha: 0)
            self.addChild(minnerSpaceship)
            
            let minnerSpaceshipTinySpaceship = SKSpriteNode(imageNamed: spaceship.type.bodyType.skin + "Mask")
            minnerSpaceshipTinySpaceship.texture?.filteringMode = Display.filteringMode
            minnerSpaceshipTinySpaceship.setScale(min(minnerSpaceship.size.width/minnerSpaceshipTinySpaceship.size.width, minnerSpaceship.size.height/minnerSpaceshipTinySpaceship.size.height))
            minnerSpaceshipTinySpaceship.color = SKColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            minnerSpaceshipTinySpaceship.colorBlendFactor = 1
            minnerSpaceshipTinySpaceship.position = CGPoint(x: minnerSpaceship.size.width/2, y: -minnerSpaceship.size.height/2)
            minnerSpaceship.addChild(minnerSpaceshipTinySpaceship)
        }
        
        self.popScale()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buySpaceship() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        let spaceshipData = MemoryCard.sharedInstance.newSpaceshipData(type: self.spaceship.type.index)
        playerData.addSpaceshipData(spaceshipData)
        
        playerData.points = playerData.points.integerValue - GameMath.spaceshipPrice(self.spaceship.type)
    }
}
