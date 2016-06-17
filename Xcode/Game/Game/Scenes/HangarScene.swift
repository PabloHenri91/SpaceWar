//
//  HangarScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
    var selectedShips = [Spaceship]()
    var slots = [SpaceShipSlot]()
    var playerData = MemoryCard.sharedInstance.playerData
    let ships = MemoryCard.sharedInstance.playerData.motherShip.spaceships as! Set<SpaceshipData>
    
    var buttonBack:Button!
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case mothership
        
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        let background = Control(textureName: "background", x:-53, xAlign: .center, yAlign: .center)
        background.zPosition = -2
        self.addChild(background)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
        self.addChild(Label(color: SKColor.whiteColor(), text: "Naves selecionadas",fontSize: .medium , x: 92, y: 72, horizontalAlignmentMode: .Left))
        
        for ship in ships {
            self.selectedShips.append(Spaceship(spaceshipData: ship))
        }
        
        
        for i in 0..<4 {
            if (i < self.selectedShips.count) {
                self.slots.append(SpaceShipSlot(spaceShip: self.selectedShips[i]))
            } else {
                self.slots.append(SpaceShipSlot(spaceShip: nil))
            }
            
            self.slots[i].screenPosition = CGPoint(x: 50 + (i * 74), y: 140)
            self.slots[i].resetPosition()
            self.addChild(self.slots[i])
        }
        

        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {

            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            
            case states.normal:
                break
                
                
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
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.normal:
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .mothership
                        return
                    }
                    var i = 0
                    for slot in self.slots {
                        if(slot.containsPoint(touch.locationInNode(self))) {
                            print(i)
                            slot.remove()
                            return
                        }
                        i = i+1
                    }
                    
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
}