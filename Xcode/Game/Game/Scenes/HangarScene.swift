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
    let playerShips = MemoryCard.sharedInstance.playerData.spaceships as! Set<SpaceshipData>
    
    var labelShips:Label!
    var buttonBack:Button!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<HangarSpaceShipCard>!
    
    var spaceShipListShape: CropBox!
    
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estado principal
        case alert
        
        
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
        
        let line = Control(textureName: "lineHangar")
        self.addChild(line)
        line.screenPosition = CGPoint(x: 0, y: 194)
        line.resetPosition()
        
        self.spaceShipListShape = CropBox(textureName: "spaceShipListShape")
        self.addChild(spaceShipListShape)
        self.spaceShipListShape.screenPosition = CGPoint(x: 20, y: 228)
        self.spaceShipListShape.resetPosition()
        
        
        self.labelShips = Label(color: SKColor.whiteColor(), text: "Naves no hangar 09/10",fontSize: .medium , x: 57, y: 213, horizontalAlignmentMode: .Left)
        self.addChild(self.labelShips)
        
        self.controlArray = Array<HangarSpaceShipCard>()
        
      
       
        for item in playerShips {
            var selected = false
            for slot in self.slots {
                if (slot.spaceShip?.spaceshipData == item) {
                    selected = true
                    break
                }
            }
            self.controlArray.append(HangarSpaceShipCard(spaceShip: Spaceship(spaceshipData: item),selected: selected))
        }
        
     
        
        self.scrollNode = ScrollNode(name: "scrollDeFalos", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
       
    
        self.spaceShipListShape.addChild(self.scrollNode)
        
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
                self.blackSpriteNode.hidden = true
                break
                
                
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: self.transition)
                break
                
            case .alert:
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
                    for slot in self.slots {
                        if(slot.containsPoint(touch.locationInNode(self))) {
                            
                            for item in self.scrollNode.cells {
                                if let card = item as? HangarSpaceShipCard {
                                    if (card.spaceShip.spaceshipData == slot.spaceShip?.spaceshipData) {
                                        card.removeSpaceship()
                                    }
                                }
                            }
                            slot.remove()
                            return
                        }
                    }
                    
                    
                    if (self.scrollNode.containsPoint(touch.locationInNode(self.spaceShipListShape.cropNode))) {
                        for item in self.scrollNode.cells {
                            if (item.containsPoint(touch.locationInNode(self.scrollNode))) {
                                if let card = item as? HangarSpaceShipCard {
                                    if (card.buttonSelect.containsPoint(touch.locationInNode(card))) {
                                        print(card.position.y)
                                        if ((card.position.y < 140) && (card.position.y > -130)) {
                                            
                                            if card.selected {
                                                
                                                card.removeSpaceship()
                                                
                                                for slot in self.slots {
                                                    if(slot.spaceShip?.spaceshipData == card.spaceShip.spaceshipData) {
                                                        slot.remove()
                                                        break
                                                    }
                                                }
                                                
                                            } else {
                                                
                                                var slotEmptyFound = false
                                                for slot in self.slots {
                                                    if(slot.spaceShip == nil) {
                                                        slot.update(card.spaceShip)
                                                        card.addSpaceship()
                                                        slotEmptyFound = true
                                                        break
                                                    }
                                                }
                                                
                                                if !slotEmptyFound {
                                                 
                                                    
                                                    self.blackSpriteNode.hidden = false
                                                    self.blackSpriteNode.zPosition = 100000
                                                    
                                                    
                                                    let teste = AlertBox(title: "Alerta!!!", text: "Nave mae lotada, remova uma nave!", type: .OK)
                                                    teste.zPosition = self.blackSpriteNode.zPosition + 1
                                                    self.addChild(teste)
                                                    teste.buttonOK.addHandler {
                                                        print("ok")
                                                        self.nextState = .normal
                                                    }
                                                    self.nextState = .alert
                                                    
                                                }
                                            }
                                        }
                                    }
                                    return
                                }
                            }
                        }
                 
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
}