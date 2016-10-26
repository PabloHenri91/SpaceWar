//
//  FactorySpaceshipCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 30/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class FactorySpaceshipCard: Control {
    
    var spaceship: Spaceship!
    
    var buttonBuy: Button!
    var labelTypeCount:Label!
    var typeCount = 0
    var isUnlocked:Bool
    
    init(spaceship: Spaceship, unlocked: Bool = true) {
        
        self.isUnlocked = unlocked
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        self.spaceship = spaceship
        
        self.spaceship.setScale(min(66/self.spaceship.size.width, 77/self.spaceship.size.height))
        if self.spaceship.xScale > 2 {
            self.spaceship.setScale(2)
        }
        
        for item in playerData.spaceships {
            if let spaceshipData = item as? SpaceshipData {
                if spaceshipData.type.integerValue == spaceship.type.index {
                    self.typeCount += 1
                }
            }
        }
        
        var textureName = ""
        var textRarity = ""
        var textColor = SKColor.blackColor()
        
        switch spaceship.type.rarity {
        case .common:
            textureName = "factorySpaceshipCardCommon"
            textRarity = "Common".uppercaseString
            textColor = SKColor(red: 63/255, green: 119/255, blue: 73/255, alpha: 1)
            break
        case .rare:
            textureName = "factorySpaceshipCardRare"
            textRarity = "Rare".uppercaseString
            textColor = SKColor(red: 164/255, green: 69/255, blue: 48/255, alpha: 1)
            break
        case .epic:
            textureName = "factorySpaceshipCardEpic"
            textRarity = "Epic".uppercaseString
            textColor = SKColor(red: 63/255, green: 68/255, blue: 119/255, alpha: 1)
            break
        case .legendary:
            textureName = "factorySpaceshipCardLegendary"
            textRarity = "Legendary".uppercaseString
            textColor = SKColor(red: 76/255, green: 60/255, blue: 77/255, alpha: 1)
            break
        }
        
        super.init(textureName: textureName)
        
        self.addChild(Control(textureName: "factorySpaceshipCardSpaceshipBackground", x: 11, y: 43))
        spaceship.screenPosition = CGPoint(x: 49, y: 86)
        spaceship.resetPosition()
        self.addChild(spaceship)
        
        
        var fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        let textOffset = CGPoint(x: 8, y: 0)
        
        self.addChild(Label(color: textColor, text: textRarity, fontSize: 8, x: 43, y: 21, verticalAlignmentMode: .Baseline, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        
        self.buttonBuy = Button(textureName: "buttonOrange84x25", text: GameMath.spaceshipPrice(spaceship.type).description, fontSize: 13, x: 145, y: 106, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: CGPoint(x: 0, y: -2), fontName: fontName, textOffset: textOffset)
        self.addChild(self.buttonBuy)
        self.buttonBuy.addChild(Control(textureName: "fragIconForButton", x: 6, y: 5))
        
        let textTypeCount = self.typeCount.description + "/4"
        fontColor = SKColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        
        self.labelTypeCount = Label(color: fontColor, text: textTypeCount, fontSize: 11, x: 265, y: 16, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
        self.addChild(self.labelTypeCount)
        
        if unlocked {
        
        let speedIcon = Control(textureName: "speedIcon", x: 97, y: 54 - 11)
        speedIcon.setScale(min(11/speedIcon.size.width, 11/speedIcon.size.height))
        self.addChild(speedIcon)
        
        let labelSpeedLabel = Label(color: fontColor, text: "Speed: ", fontSize: 11, x: 97 + 15, y: 54, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo900, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
        self.addChild(labelSpeedLabel)
        self.addChild(Label(color: fontColor, text: spaceship.speedAtribute.description, fontSize: 11, x: 97 + 15 + Int(labelSpeedLabel.calculateAccumulatedFrame().size.width), y: 54, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        
        let lifeIcon = Control(textureName: "lifeIcon", x: 97, y: 68 - 11)
        lifeIcon.setScale(min(11/lifeIcon.size.width, 11/lifeIcon.size.height))
        self.addChild(lifeIcon)
        
        let labelAlrmorLabel = Label(color: fontColor, text: "Armor: ", fontSize: 11, x: 97 + 15, y: 68, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo900, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
        self.addChild(labelAlrmorLabel)
        self.addChild(Label(color: fontColor, text: spaceship.maxHealth.description, fontSize: 11, x: 97 + 15 + Int(labelAlrmorLabel.calculateAccumulatedFrame().size.width), y: 68, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        if let weapon = spaceship.weapon {
            
            self.addChild(Label(color: SKColor.whiteColor(), text: spaceship.displayName().uppercaseString, fontSize: 11, x: 90, y: 21, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
            
            let damageIcon = Control(textureName: "damageIcon", x: 191, y: 54 - 11)
            damageIcon.setScale(min(11/damageIcon.size.width, 11/damageIcon.size.height))
            self.addChild(damageIcon)
            
            let labelDamageLabel = Label(color: fontColor, text: "Damage: ", fontSize: 11, x: 191 + 15, y: 54, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo900, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
            self.addChild(labelDamageLabel)
            self.addChild(Label(color: fontColor, text: weapon.damage.description, fontSize: 11, x: 191 + 15 + Int(labelDamageLabel.calculateAccumulatedFrame().size.width), y: 54, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
            
            let rangeIcon = Control(textureName: "rangeIcon", x: 191, y: 68 - 11)
            rangeIcon.setScale(min(11/rangeIcon.size.width, 11/rangeIcon.size.height))
            self.addChild(rangeIcon)
            
            let labelRangeLabel = Label(color: fontColor, text: "Range: ", fontSize: 11, x: 191 + 15, y: 68, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo900, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
            self.addChild(labelRangeLabel)
            self.addChild(Label(color: fontColor, text: weapon.range.description, fontSize: 11, x: 191 + 15 + Int(labelRangeLabel.calculateAccumulatedFrame().size.width), y: 68, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
            
            let fireRateIcon = Control(textureName: "fireRateIcon", x: 191, y: 82 - 11)
            fireRateIcon.setScale(min(11/fireRateIcon.size.width, 11/fireRateIcon.size.height))
            self.addChild(fireRateIcon)
            
            let labelFireRateLabel = Label(color: fontColor, text: "Fire Rate: ", fontSize: 11, x: 191 + 15, y: 82, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo900, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
            self.addChild(labelFireRateLabel)
            self.addChild(Label(color: fontColor, text: (1/weapon.fireInterval).description, fontSize: 11, x: 191 + 15 + Int(labelFireRateLabel.calculateAccumulatedFrame().size.width), y: 82, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        }
        
        self.labelTypeCount.setText(self.typeCount.description + "/4")
        
        if self.typeCount >= 4 {
            self.buttonBuy.hidden = true
        }
        
        } else {
            self.buttonBuy.hidden = true
            
            self.addChild(Label(color: SKColor.whiteColor(), text: "???", fontSize: 11, x: 90, y: 21, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
            
            let spaceshipMask = SKSpriteNode(imageNamed: spaceship.type.bodyType.skin + "Mask")
            spaceshipMask.texture?.filteringMode = Display.filteringMode
            spaceshipMask.setScale(min(spaceship.size.width/spaceshipMask.size.width, spaceship.size.height/spaceshipMask.size.height))
            spaceshipMask.color = SKColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            spaceshipMask.colorBlendFactor = 1
            //spaceshipMask.position = CGPoint(x: spaceship.size.width/2, y: -spaceship.size.height/2)
            spaceshipMask.zPosition = spaceship.zPosition + 3
            spaceship.addChild(spaceshipMask)
            
            let lockedIcon = Control(textureName: "lockedIcon", x: 170, y: 61)
            self.addChild(lockedIcon)
            
            self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "LOCKED", fontSize: 12, x: 159, y: 110, fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
            
            

        }
        
    }
    
    func updateLabelTypeCount() {
        self.typeCount += 1
        let textTypeCount = self.typeCount.description + "/4"
        self.labelTypeCount.setText(textTypeCount)
        
        if self.typeCount >= 4 {
            self.buttonBuy.hidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
