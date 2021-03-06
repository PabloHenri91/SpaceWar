//
//  BuyMinnerSpaceshipAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 09/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BuyMinnerSpaceshipAlert: Box {
    
    var buttonCancel:Button!
    var buttonBuy:Button!
    
    init() {
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        let spriteNode = SKSpriteNode(imageNamed: "buyMinnerSpaceshipAlert")
        super.init(spriteNode: spriteNode)
        
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 105, y: -60,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
        })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "BUY MINING SPACESHIP" , fontSize: 13, x: -127, y: -48, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        let labelLevel = Label(text: "MINING SPACESHIP LEVEL 1" , fontSize: 11, x: -127, y: -8 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelLevel)
        
        let labelAmount = Label(text: "YOU HAVE ".translation() + playerData.missionSpaceships.count.description + "/4" , fontSize: 11, x: -78, y: 14 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo500, horizontalAlignmentMode: .Left)
        self.addChild(labelAmount)
        
        let labelBuy = Label(text: "BUY" , fontSize: 11, x: 61, y: 14 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelBuy)
        
        let price = 2000 * playerData.missionSpaceships.count
        
        self.buttonBuy = Button(textureName: "buttonOrangeFragments", text: price.description, fontSize: 13, x: 61, y: 26, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
        self.addChild(self.buttonBuy)
        
        let minnerSpaceship = Control(textureName: "minnerSpaceshipTiny", x: -128, y: 9)
        self.addChild(minnerSpaceship)
        
        let minnerSpacehsipImage = Control(textureName: "minnerSpaceship", x: -124, y: 18)
        minnerSpacehsipImage.setScale(0.60)
        self.addChild(minnerSpacehsipImage)
        
        for i in 0..<playerData.missionSpaceships.count {
            let x = -78 + 27 * i
       
            
            let minnerSpacehsipImage = Control(textureName: "minnerSpaceship", x: x+2, y: 35)
            minnerSpacehsipImage.setScale(0.30)

            self.addChild(minnerSpacehsipImage)
        }
        
        for i in playerData.missionSpaceships.count..<4 {
            let x = -78 + 27 * i
           
            
            let minnerSpacehsipImage = Control(textureName: "minnerSpaceshipBlack", x: x+2, y: 35)
            minnerSpacehsipImage.setScale(0.30)
            
            self.addChild(minnerSpacehsipImage)
        }
        
        self.popScale()
    }
    
    func buyMiningSpaceship() -> Bool {
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        let price = 2000 * playerData.missionSpaceships.count
        
        if playerData.points.integerValue >= price {
            let missionSpaceshipData = MemoryCard.sharedInstance.newMissionSpaceshipData()
            playerData.addMissionSpaceshipData(missionSpaceshipData)
            playerData.points = playerData.points.integerValue - price
            return true
        }
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
