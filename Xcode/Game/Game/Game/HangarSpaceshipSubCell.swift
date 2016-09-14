//
//  HangarSpaceshipSubCell.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 22/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarSpaceshipSubCell: Control {
    
    var spaceship: Spaceship
    
    init(spaceship: Spaceship, x: Int) {
        
        self.spaceship = spaceship
        
        var imageName = ""
        
        switch self.spaceship.type.rarity {
        case .common:
            imageName = "hangarCommomSelectCard"
            break
        case .rare:
            imageName = "hangarRareSelectCard"
            break
        case .epic:
            imageName = "hangarEpicSelectCard"
            break
        case .legendary:
            imageName = "hangarLegendarySelectCard"
            break
        }
        
        
        let spriteNode = SKSpriteNode(imageNamed: imageName)
        super.init(spriteNode: spriteNode, x:x)
        
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
     
        
        let spaceshipImage = Spaceship(spaceshipData: self.spaceship.spaceshipData!)
        
        spaceshipImage.setScale(min(58/spaceshipImage.size.width, 45/spaceshipImage.size.height))
        if spaceshipImage.xScale > 2 {
            spaceshipImage.setScale(2)
        }
        
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 0, y: -10)
        spaceshipImage.resetPosition()
        
        let labelLevel = Label(color:SKColor.whiteColor() ,text: "Level ".translation() + self.spaceship.level.description , fontSize: 13, x: 0, y: 30, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelLevel)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
