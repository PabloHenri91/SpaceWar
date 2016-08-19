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
    
    init?(spaceship: Spaceship) {
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        self.spaceship = spaceship
        
        for item in playerData.spaceships {
            if let spaceshipData = item as? SpaceshipData {
                if spaceshipData.type.integerValue == spaceship.type.index {
                    if let weaponData = spaceshipData.weapons.anyObject() as? WeaponData {
                        if weaponData.type.integerValue == spaceship.weapon!.type.index {
                            self.typeCount += 1
                        }
                    }
                }
            }
        }
        
        if self.typeCount >= 4 {
            return nil
        }
        
        var textureName = ""
        var textRarity = ""
        var textColor = SKColor.blackColor()
        
        switch spaceship.type.rarity {
        case .common:
            textureName = "factorySpaceshipCardCommon"
            textRarity = "Common"
            textColor = SKColor(red: 63/255, green: 119/255, blue: 73/255, alpha: 1)
            break
        case .rare:
            textureName = "factorySpaceshipCardRare"
            textRarity = "Rare"
            textColor = SKColor(red: 164/255, green: 69/255, blue: 48/255, alpha: 1)
            break
        case .epic:
            textureName = "factorySpaceshipCardEpic"
            textRarity = "Epic"
            textColor = SKColor(red: 63/255, green: 68/255, blue: 119/255, alpha: 1)
            break
        case .legendary:
            textureName = "factorySpaceshipCardLegendary"
            textRarity = "Legendary"
            textColor = SKColor(red: 76/255, green: 60/255, blue: 77/255, alpha: 1)
            break
        }
        
        super.init(textureName: textureName)
        
        self.addChild(Control(textureName: "factorySpaceshipCardSpaceshipBackground", x: 11, y: 43))
        spaceship.screenPosition = CGPoint(x: 49, y: 86)
        spaceship.resetPosition()
        spaceship.loadAllyDetails()
        self.addChild(spaceship)
        
        
        var fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        let textOffset = CGPoint(x: 8, y: 0)
        
        self.buttonBuy = Button(textureName: "buttonGray82x23", text: GameMath.spaceshipPrice(spaceship.type).description, fontSize: 13, x: 145, y: 106, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName, textOffset: textOffset)
        self.addChild(self.buttonBuy)
        self.buttonBuy.addChild(Control(textureName: "fragIconForButton", x: 6, y: 5))
        
        self.addChild(Label(color: textColor, text: textRarity, fontSize: 8, x: 43, y: 21, verticalAlignmentMode: .Baseline, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        self.addChild(Label(color: SKColor.whiteColor(), text: spaceship.factoryDisplayName(), fontSize: 11, x: 90, y: 21, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        let textTypeCount = self.typeCount.description + "/4"
        fontColor = SKColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        
        self.labelTypeCount = Label(color: fontColor, text: textTypeCount, fontSize: 11, x: 265, y: 16, fontName: fontName, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset)
        self.addChild(self.labelTypeCount)
        
        
        let labelSpeedText = "Speed " + spaceship.speedAtribute.description
        self.addChild(Label(color: fontColor, text: labelSpeedText, fontSize: 11, x: 97, y: 54, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        let labelArmorText = "Armor " + spaceship.maxHealth.description
        self.addChild(Label(color: fontColor, text: labelArmorText, fontSize: 11, x: 97, y: 68, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
        
        if let weapon = spaceship.weapon {
            
            let labelDamageText = "Damage " + weapon.damage.description
            self.addChild(Label(color: fontColor, text: labelDamageText, fontSize: 11, x: 191, y: 54, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
            
            let labelRangeText = "Range " + weapon.range.description
            self.addChild(Label(color: fontColor, text: labelRangeText, fontSize: 11, x: 191, y: 68, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
            
            let labelFireRateText = "Fire Rate " + (1/weapon.fireInterval).description
            self.addChild(Label(color: fontColor, text: labelFireRateText, fontSize: 11, x: 191, y: 82, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: fontShadowOffset))
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
