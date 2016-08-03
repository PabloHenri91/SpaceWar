//
//  SpaceShipSlot.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceshipSlot: Control {
    
    var spaceship:Spaceship?
    
    var sprite:SKSpriteNode!
    let motherShip = MemoryCard.sharedInstance.playerData.motherShip
    init(spaceship:Spaceship?) {
        
        super.init()
        Control.controlList.insert(self)
        
        self.sprite = SKSpriteNode(imageNamed: "spaceshipSlotEmpty")
        
        if let spaceshipFromInit = spaceship {
            self.addChild(spaceshipFromInit)
            self.spaceship = spaceshipFromInit
        } else {
            self.addChild(self.sprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove() {
        if let item = self.spaceship {
            item.removeFromParent()
            self.addChild(self.sprite)
            if let spaceshipDataItem = item.spaceshipData {
               motherShip.removeSpaceshipData(spaceshipDataItem)
            }
            self.spaceship = nil
        }
    }
    
    func update(spaceshipData: SpaceshipData) {
        
        
        motherShip.addSpaceshipData(spaceshipData)
        
        let spaceship = Spaceship(spaceshipData: spaceshipData)
        spaceship.loadAllyDetails()
        self.spaceship = spaceship
        self.sprite.removeFromParent()
        self.addChild(spaceship)
        self.spaceship = spaceship
    }
    
    
}