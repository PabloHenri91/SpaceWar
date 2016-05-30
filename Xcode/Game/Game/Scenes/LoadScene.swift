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
        
        self.addChild(Label(color: GameColors.white, text: "LoadScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        self.addChild(Control(textureName: "background", x:-53, xAlign: .center, yAlign: .center))
        
        self.playerData = MemoryCard.sharedInstance.playerData
        
        var spaceships = [Spaceship]()
        for item in self.playerData.spaceships {
            if let spaceshipData = item as? SpaceshipData {
                spaceships.append(Spaceship(spaceshipData: spaceshipData))
            }
        }
        
        var weapons = [Weapon]()
        for item in self.playerData.weapons {
            if let weaponData = item as? WeaponData {
                weapons.append(Weapon(weaponData: weaponData))
            }
        }
        
        let mothership = Mothership(mothershipData: self.playerData.motherShip)
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
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: self.transition)
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
}
