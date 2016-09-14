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
    var spaceshipImage: Spaceship!
    
    init(spaceship:Spaceship, x:Int, y:Int) {
        
        
        self.spaceship = spaceship
        
        var imageName = ""
        
        switch self.spaceship.type.rarity {
        case .common:
            imageName = "commonHangarSpaceshipCard"
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
       

        self.spaceshipImage = Spaceship(spaceshipData: spaceship.spaceshipData!)
        self.addChild(self.spaceshipImage)
        self.spaceshipImage.screenPosition = CGPoint(x: 74, y: 62)
        self.spaceshipImage.resetPosition()
        
        self.spaceshipImage.setScale(min(139/self.spaceshipImage.size.width, 54/self.spaceshipImage.size.height))
        
        if self.spaceshipImage.xScale > 2 {
            self.spaceshipImage.setScale(2)
        }
            
        self.buttonUpgrade = Button(textureName: "buttonGreen92x25", text: "UPGRADE", fontSize: 13 ,  x: 31, y: 120, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.buttonUpgrade)

        self.labelLevel = Label(color: SKColor.whiteColor(), text: "Level ".translation() + self.spaceship.level.description , fontSize: 13 ,  x: 75, y: 100, shadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelLevel)
        
        
        self.labelName = Label(color: SKColor.whiteColor(), text: (self.spaceship.factoryDisplayName()).uppercaseString , fontSize: 12 ,  x: 76, y: 14, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelName)
        
        self.buttonChange = Button(textureName: "buttonBlue92x25", text: "CHANGE", fontSize: 13 ,  x: 31, y: 150, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.buttonChange)

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func reloadCard() {
        
        self.labelLevel.setText("Level ".translation() + self.spaceship.level.description)
        self.labelName.setText((self.spaceship.factoryDisplayName()).uppercaseString)
        
        self.spaceshipImage.removeFromParent()
        
        self.spaceshipImage = Spaceship(spaceshipData: spaceship.spaceshipData!)
        
        self.addChild(self.spaceshipImage)
        self.spaceshipImage.screenPosition = CGPoint(x: 74, y: 62)
        self.spaceshipImage.resetPosition()
        
        self.spaceshipImage.setScale(min(139/self.spaceshipImage.size.width, 54/self.spaceshipImage.size.height))
        
        if self.spaceshipImage.xScale > 2 {
            self.spaceshipImage.setScale(2)
        }
    }
    
}

