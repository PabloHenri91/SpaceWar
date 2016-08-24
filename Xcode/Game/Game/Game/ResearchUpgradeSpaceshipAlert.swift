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
    
    init(spaceship:Spaceship) {
   
        var imageName = ""
        var rarityColor:SKColor
        
        switch spaceship.type.rarity {
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
        
        super.init(textureName: imageName)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 246, y: 10,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
            })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: spaceship.type.name.uppercaseString + " + " + spaceship.weapon!.type.name.uppercaseString , fontSize: 11, x: 93, y: 22, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        
        let labelRarity = Label(color:rarityColor ,text: spaceship.type.rarity.rawValue.uppercaseString , fontSize: 11, x: 47, y: 22, horizontalAlignmentMode: .Center, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelRarity)
        
        var spaceshipImage:Spaceship!
        
        if let spaceshipData = spaceship.spaceshipData {
            spaceshipImage = Spaceship(spaceshipData: spaceshipData, loadPhysics: false)
        } else {
            spaceshipImage = Spaceship(type: spaceship.type.index, level: spaceship.level)
            if let weapon = spaceship.weapon {
                spaceshipImage.addWeapon(Weapon(type: weapon.type.index, level: spaceship.level))
            }
        }
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 50, y: 90)
        spaceshipImage.resetPosition()
        spaceshipImage.setScale(1.8)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}