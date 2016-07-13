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
    var crashedSpaceships:Array<HangarSpaceShipCard>!
    
    var spaceShipListShape: CropBox!
    
    var lastUpdate: NSTimeInterval = 0
    
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estado de alertBox
        case alert
        
        
        //Estados de saida da scene
        case mothership
        
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
        self.addChild(Label(color: SKColor.whiteColor(), text: "Selected spaceships",fontSize: GameFonts.fontSize.medium.rawValue, x: 92, y: 72, xAlign: .center, yAlign: .up, horizontalAlignmentMode: .Left))
        
        for ship in ships {
            let spaceship = Spaceship(spaceshipData: ship)
            spaceship.loadAllyDetails()
            self.selectedShips.append(spaceship)
        }
        
        
        for i in 0..<4 {
            if (i < self.selectedShips.count) {
                self.slots.append(SpaceShipSlot(spaceShip: self.selectedShips[i]))
            } else {
                self.slots.append(SpaceShipSlot(spaceShip: nil))
            }
            
            self.slots[i].xAlign = .center
            self.slots[i].yAlign = .up
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
        
        
        self.labelShips = Label(color: SKColor.whiteColor(), text: "Spaceships on hangar 09/10",fontSize: GameFonts.fontSize.medium.rawValue, x: 57, y: 213, xAlign: .center, yAlign: .up, horizontalAlignmentMode: .Left)
        self.addChild(self.labelShips)
        
        self.controlArray = Array<HangarSpaceShipCard>()
        self.crashedSpaceships = Array<HangarSpaceShipCard>()
        
      
        let orderedplayerShips = playerShips.sort({ $0.level.integerValue > $1.level.integerValue })
        
        for item in orderedplayerShips {
            var selected = false
            for slot in self.slots {
                if (slot.spaceShip?.spaceshipData == item) {
                    selected = true
                    break
                }
            }
            
            if GameMath.spaceshipFixTime(item.crashDate) < 0 {
                self.controlArray.append(HangarSpaceShipCard(spaceShip: Spaceship(spaceshipData: item),selected: selected))
            } else {
                self.crashedSpaceships.append(HangarSpaceShipCard(spaceShip: Spaceship(spaceshipData: item),selected: selected))
            }
            
        }
        
        
        
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
        self.spaceShipListShape.addChild(self.scrollNode)
        
        for item in self.crashedSpaceships {
            self.scrollNode.append(item)
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
                
            case states.normal:
                
                if ((currentTime - self.lastUpdate) > 1) {
                    self.lastUpdate = currentTime
                    for item in self.scrollNode.cells {
                        if let card = item as? HangarSpaceShipCard {
                            card.update()
                        }
                    }
                    
                }
                
                break

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
                self.view?.presentScene(MothershipScene(), transition: GameScene.transition)
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
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
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
                                    if let buttonSelect = card.buttonSelect{
                                        if (buttonSelect.containsPoint(touch.locationInNode(card))) {
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
                                                            slot.update(card.spaceShip.spaceshipData!)
                                                            card.addSpaceship()
                                                            slotEmptyFound = true
                                                            break
                                                        }
                                                    }
                                                    
                                                    if !slotEmptyFound {
                                                        
                                                        
                                                        self.blackSpriteNode.hidden = false
                                                        self.blackSpriteNode.zPosition = 100000
                                                        
                                                        
                                                        let teste = AlertBox(title: "Alert!!!", text: "Mothership full, remove a spaceship!", type: .OK)
                                                        teste.zPosition = self.blackSpriteNode.zPosition + 1
                                                        self.addChild(teste)
                                                        teste.buttonOK.addHandler {
                                                            self.nextState = .normal
                                                        }
                                                        self.nextState = .alert
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    if let buttonUpgrade = card.buttonUpgrade {
                                        
                                        if(buttonUpgrade.containsPoint(touch.locationInNode(card))) {
                                            if ((card.position.y < 140) && (card.position.y > -130)) {
                                                let cost = GameMath.spaceshipUpgradeCost(level: card.spaceShip.level, type: card.spaceShip.type)
                                                if (cost < self.playerData.points.integerValue) {
                                                    card.upgradeSpaceship(cost)
                                                } else {
                                                    let teste = AlertBox(title: "Alert!!!", text: "Insuficient points", type: .OK)
                                                    teste.zPosition = self.blackSpriteNode.zPosition + 1
                                                    self.addChild(teste)
                                                    teste.buttonOK.addHandler {
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