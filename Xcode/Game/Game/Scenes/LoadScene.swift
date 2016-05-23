//
//  GameScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    var playerData:PlayerData! = nil
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        MemoryCard.sharedInstance.reset()
        
        self.playerData = MemoryCard.sharedInstance.playerData
        
        var spaceships = [Spaceship]()
        for item in self.playerData.spaceships {
            spaceships.append(Spaceship(spaceshipData: item as! SpaceshipData))
        }
        
        print(spaceships)
        
    }
}
