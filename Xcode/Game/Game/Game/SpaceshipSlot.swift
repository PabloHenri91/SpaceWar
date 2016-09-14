//
//  SpaceshipSlot.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceshipSlot: Control {
    
    var spaceship:Spaceship?
    
    let playerData = MemoryCard.sharedInstance.playerData
    
    var labelLevel:Label?
    
    init(spaceship:Spaceship?) {
        super.init(textureName: "spaceshipSlotBackground")
        
        self.spaceship = spaceship
        
        if let spaceship = spaceship {
            self.addChild(spaceship)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func update(spaceshipData: SpaceshipData) {
        //self.playerData.motherShip.addSpaceshipData(spaceshipData, index: spaceshipData.index)
        
        let spaceship = Spaceship(spaceshipData: spaceshipData)
        
        spaceship.setScale(min(58/spaceship.size.width, 45/spaceship.size.height))
        if spaceship.xScale > 2 {
            spaceship.setScale(2)
        }
        
        spaceship.zPosition = spaceship.zPosition + 1
        self.addChild(spaceship)
        spaceship.loadJetEffect(nil, color: SKColor(red: 0/255, green: 84/255, blue: 143/255, alpha: 1))
        spaceship.emitterNodeParticleBirthRate = spaceship.defaultEmitterNodeParticleBirthRate
        spaceship.updateEmitters()
        
        self.spaceship = spaceship
    }
    
    func setSpaceshipSlotDetails(spaceship:Spaceship) {
        
        var imageName = ""
        let lableLevelShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100)
        switch spaceship.type.rarity {
        case .common:
            imageName = "rarityIndicatorCommon"
            break
        case .rare:
            imageName = "rarityIndicatorRare"
            break
        case .epic:
            imageName = "rarityIndicatorEpic"
            break
        case .legendary:
            imageName = "rarityIndicatorLegendary"
            break
        }
        
        let spriteNode = SKSpriteNode(imageNamed: imageName)
        spriteNode.texture?.filteringMode = Display.filteringMode
        spriteNode.position = CGPoint(x: 34, y: -55)
        self.addChild(spriteNode)
        
        self.labelLevel = Label(color: SKColor.whiteColor(), text: "Level ".translation() + spaceship.level.description, fontSize: 13, fontName: GameFonts.fontName.museo1000, shadowColor: lableLevelShadowColor, shadowOffset: CGPoint(x: 0, y: -1))
        spriteNode.addChild(self.labelLevel!)
    }
    
    func updateSpaceshipLevel() {
        if let spaceship = self.spaceship {
            if let labelLevel = self.labelLevel {
                if let spaceshipData = spaceship.spaceshipData {
                    let text = "Level ".translation() + spaceshipData.level.description
                    
                    labelLevel.setText(text)
                    
                    let duration:Double = 0.10
                    var actions = [SKAction]()
                    actions.append(SKAction.scaleTo(1.5, duration: duration))
                    actions.append(SKAction.scaleTo(1.0, duration: duration))
                    let action = SKAction.sequence(actions)
                    
                    labelLevel.runAction(action)
                }
            }
        }
    }
    
    override func addChild(node: SKNode) {
        super.addChild(node)
        if let spaceship = node as? Spaceship {
            spaceship.position = CGPoint(x: 34, y: -24)
            self.setSpaceshipSlotDetails(spaceship)
        }
    }
}