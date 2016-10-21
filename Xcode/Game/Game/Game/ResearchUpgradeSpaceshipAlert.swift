//
//  ResearchUpgradeSpaceshipAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 24/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class ResearchUpgradeSpaceshipAlert:Box {
    
    var buttonCancel: Button!
    var buttonGoToHangar: Button!
    var spaceship: Spaceship!
    
    init(research:Research) {
   
        var imageName = ""
        var rarityColor:SKColor!
        
        if let spaceshipUnlockedIndex = research.researchType.spaceshipUnlockedIndex {
            
            let spaceshipType = Spaceship.types[spaceshipUnlockedIndex]
            
            switch spaceshipType.rarity {
                case .common:
                imageName = "researchUpgradeSpaceshipCommom"
                rarityColor = SKColor(red: 63/255, green: 119/255, blue: 73/255, alpha: 1)
                break
                case .rare:
                imageName = "researchUpgradeSpaceshipRare"
                rarityColor = SKColor(red: 164/255, green: 69/255, blue: 48/255, alpha: 1)
                break
                case .epic:
                imageName = "researchUpgradeSpaceshipEpic"
                rarityColor = SKColor(red: 65/255, green: 70/255, blue: 123/255, alpha: 1)
                break
                case .legendary:
                imageName = "researchUpgradeSpaceshipLegendary"
                rarityColor = SKColor(red: 76/255, green: 60/255, blue: 77/255, alpha: 1)
                break
                }
            
                self.spaceship = Spaceship(type: spaceshipType.index, level: 1)
                self.spaceship?.position = CGPoint(x:33, y: -33)
        }
        
       
        
        super.init(textureName: imageName)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 246, y: 10,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
            })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: spaceship.displayName().uppercaseString, fontSize: 11, x: 93, y: 22, horizontalAlignmentMode: .Left, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2))
        
        self.addChild(labelTitle)
        
        let labelRarity = Label(color:rarityColor ,text: spaceship.type.rarity.rawValue.uppercaseString , fontSize: 11, x: 47, y: 22, horizontalAlignmentMode: .Center, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelRarity)
        
        var spaceshipImage:Spaceship!
        
        if let spaceshipData = self.spaceship.spaceshipData {
            spaceshipImage = Spaceship(spaceshipData: spaceshipData, loadPhysics: false)
        } else {
            spaceshipImage = Spaceship(type: spaceship.type.index, level: spaceship.level)
        }
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 50, y: 90)
        spaceshipImage.resetPosition()
        spaceshipImage.setScale(1.8)
        
        let labelUnlocked = MultiLineLabel(text: "You unlocked more levels to upgrade your ship!", maxWidth: 165, x: 96, y: 68, fontName: GameFonts.fontName.museo1000, fontSize: 11, horizontalAlignmentMode: .Left)
        self.addChild(labelUnlocked)
        
        let labelHangar = MultiLineLabel(text: "Go to hangar to upgrade this ship!", maxWidth: 165, x: 96, y: 97, fontName: GameFonts.fontName.museo500, fontSize: 11, horizontalAlignmentMode: .Left)
        self.addChild(labelHangar)
        
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "NEW MAX LEVEL", fontSize: 12, x: 15, y: 166, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        
        let levelUpIcon = Control(textureName: "levelUpIcon", x: 18, y: 184)
        self.addChild(levelUpIcon)
        
        let maxLevel = research.researchData.spaceshipMaxLevel.integerValue - 10
        
        let labelMaxLevel = Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "MAX LEVEL: " + maxLevel.description , fontSize: 12, x: 35, y: 190, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2))
        
        self.addChild(labelMaxLevel)
        
        let labelLevelUp = Label(color: SKColor(red: 104/255, green: 181/255, blue: 59/255, alpha: 1), text: " + 10" , fontSize: 12, x: Int(labelMaxLevel.position.x + labelMaxLevel.calculateAccumulatedFrame().width) , y: 190, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2))
        
        self.addChild(labelLevelUp)
        
        
        let fontShadowColor = SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 1)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.buttonGoToHangar = Button(textureName: "buttonDarkBlue131x30", text: "GO TO HANGAR", fontSize: 11, x: 76, y: 246, fontColor: SKColor.whiteColor(), fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonGoToHangar)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}