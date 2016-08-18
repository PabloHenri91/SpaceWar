//
//  HangarSpaceshipCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarSpaceshipCard: Control {
    
    var spaceship: Spaceship!
    var buttonUpgrade: Button!
    var buttonChange: Button!
    var labelLevel: Label!
    var labelName: Label!
    var playerData = MemoryCard.sharedInstance.playerData
    
    init(spaceship:Spaceship, x:Int, y:Int) {
        
        
        self.spaceship = spaceship
        
        var imageName = ""
        
        switch self.spaceship.type.rarity {
        case .commom:
            imageName = "commomHangarSpaceshipCard"
            break
        case .rare:
            imageName = "rareHangarSpaceshipCard"
            break
        case .epic:
            imageName = "epicHangarSpaceshipCard"
            break
        case .legendary:
            imageName = "legendaryHangarSpaceshipCard"
            break
        }

        super.init(textureName: imageName, x: x, y: y, xAlign: .center, yAlign: .center)
       

        let spaceshipImage = Spaceship(spaceshipData: spaceship.spaceshipData!)
        spaceshipImage.loadAllyDetails()
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 74, y: 62)
        spaceshipImage.resetPosition()
        

            
        self.buttonUpgrade = Button(textureName: "hangarButtonGray", text: "UPGRADE", fontSize: 13 ,  x: 31, y: 120, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.buttonUpgrade)

        self.labelLevel = Label(color: SKColor.whiteColor(), text: "Level " + self.spaceship.level.description , fontSize: 13 ,  x: 75, y: 100, shadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelLevel)
        
        
        self.labelName = Label(color: SKColor.whiteColor(), text: self.spaceship.type.name.uppercaseString , fontSize: 13 ,  x: 76, y: 14, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelName)
        
        self.buttonChange = Button(textureName: "hangarButtonGreen", text: "CHANGE", fontSize: 13 ,  x: 31, y: 150, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.buttonChange)

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func upgradeSpaceship(cost: Int) {
        let xp = GameMath.spaceshipUpgradeXPBonus(level: self.spaceship.level, type: self.spaceship.type)
        self.spaceship.upgrade()
        self.playerData.points = self.playerData.points.integerValue - cost
        self.playerData.motherShip.xp = NSNumber(integer: self.playerData.motherShip.xp.integerValue + xp)
        self.reloadCard()
    }
    
    func reloadCard() {
        
        self.labelLevel.setText(self.spaceship.level.description)
    }
    
}

