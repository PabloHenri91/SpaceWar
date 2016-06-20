//
//  SpaceShipSlot.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpaceShipSlot: Control {
    
    var spaceShip:Spaceship?
    
    var sprite:SKSpriteNode!
    let motherShip = MemoryCard.sharedInstance.playerData.motherShip
    init(spaceShip:Spaceship?) {
        
        super.init()
        
        self.sprite = SKSpriteNode(imageNamed: "spaceShipSlotEmpty")
        
        if let spaceShipeFromInit = spaceShip {
            self.addChild(spaceShipeFromInit)
            self.spaceShip = spaceShipeFromInit
        } else {
            self.addChild(self.sprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove() {
        if let item = self.spaceShip {
            item.removeFromParent()
            self.addChild(self.sprite)
            if let spaceShipDataItem = item.spaceshipData {
               motherShip.removeSpaceshipData(spaceShipDataItem)
            }
            self.spaceShip = nil
        }
    }
    
    func update(spaceShip: Spaceship) {
        self.sprite.removeFromParent()
        self.addChild(spaceShip)
        self.spaceShip = spaceShip
        
        if let spaceShipDataItem = spaceShip.spaceshipData {
            motherShip.addSpaceshipData(spaceShipDataItem)
        }
    }
    
    
}