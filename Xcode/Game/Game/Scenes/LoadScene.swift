//
//  GameScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    enum states : String {
        //Estado principal
        case load
        
        //Estados de saida da scene
        case mothership
    }
    
    //Estados iniciais
    var state = states.load
    var nextState = states.load

    
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
        
        //print(spaceships)
        
        var weapons = [Weapon]()
        for item in self.playerData.weapons {
            weapons.append(Weapon(weaponData: item as! WeaponData))
        }
        
        print(weapons)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .load:
                self.nextState = .mothership
                break
            default:
                break
            }
        } else {
            //Próximo estado
            switch (self.nextState) {
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: self.transition)
                break
            default:
                fatalError()
                break
            }
        }
    }
}
