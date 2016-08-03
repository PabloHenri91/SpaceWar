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
    var slots = [SpaceshipSlot]()
    var playerData = MemoryCard.sharedInstance.playerData
    let ships = MemoryCard.sharedInstance.playerData.motherShip.spaceships as! Set<SpaceshipData>
    let playerShips = MemoryCard.sharedInstance.playerData.spaceships as! Set<SpaceshipData>
    
    var labelShips:Label!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<HangarSpaceshipCard>!
    var crashedSpaceships:Array<HangarSpaceshipCard>!
    
    var spaceshipListShape: CropBox!
    
    var lastUpdate: NSTimeInterval = 0
    
    
    enum states : String {
        
        //Estado de alertBox
        case alert
        
        case research
        case mission
        case mothership
        case factory
        case hangar
    }
    
    //Estados iniciais
    var state = states.hangar
    var nextState = states.hangar
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
        case .research, .mission, .mothership, .factory:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        case .hangar:
            break
        }
        
        self.addChild(Label(color: SKColor.whiteColor(), text: "Selected spaceships",fontSize: 16, x: 92, y: 72, xAlign: .center, yAlign: .up, horizontalAlignmentMode: .Left))
        
        for ship in ships {
            let spaceship = Spaceship(spaceshipData: ship)
            spaceship.loadAllyDetails()
            self.selectedShips.append(spaceship)
        }
        
        for i in 0..<4 {
            if (i < self.selectedShips.count) {
                self.slots.append(SpaceshipSlot(spaceship: self.selectedShips[i]))
            } else {
                self.slots.append(SpaceshipSlot(spaceship: nil))
            }
            
            self.slots[i].xAlign = .center
            self.slots[i].yAlign = .up
            self.slots[i].screenPosition = CGPoint(x: 6 + (i * 80), y: 91)
            self.slots[i].resetPosition()
            self.addChild(self.slots[i])
        }
        
        self.spaceshipListShape = CropBox(textureName: "spaceshipListShape")
        self.addChild(spaceshipListShape)
        self.spaceshipListShape.screenPosition = CGPoint(x: 20, y: 228)
        self.spaceshipListShape.resetPosition()
        
        
        self.labelShips = Label(color: SKColor.whiteColor(), text: "spaceships on hangar 09/10",fontSize: 16, x: 57, y: 213, xAlign: .center, yAlign: .up, horizontalAlignmentMode: .Left)
        self.addChild(self.labelShips)
        
        self.controlArray = Array<HangarSpaceshipCard>()
        self.crashedSpaceships = Array<HangarSpaceshipCard>()
        
      
        let orderedplayerShips = playerShips.sort({ $0.level.integerValue > $1.level.integerValue })
        
        for item in orderedplayerShips {
            var selected = false
            for slot in self.slots {
                if (slot.spaceship?.spaceshipData == item) {
                    selected = true
                    break
                }
            }
            
            if GameMath.spaceshipFixTime(item.crashDate) < 0 {
                self.controlArray.append(HangarSpaceshipCard(spaceship: Spaceship(spaceshipData: item),selected: selected))
            } else {
                self.crashedSpaceships.append(HangarSpaceshipCard(spaceship: Spaceship(spaceshipData: item),selected: selected))
            }
            
        }
        
        
        
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
        self.spaceshipListShape.addChild(self.scrollNode)
        
        for item in self.crashedSpaceships {
            self.scrollNode.append(item)
        }
        
        switch GameTabBar.lastState {
        case .research, .mission, .mothership, .factory:
            for node in self.children {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.runAction(SKAction.moveTo(nodePosition, duration: actionDuration))
            }
            break
        case .hangar:
            break
        }
        
        self.runAction({ let a = SKAction(); a.duration = actionDuration; return a }(), completion: {
            for node in GameScene.lastChildren {
                node.removeFromParent()
            }
            GameScene.lastChildren = [SKNode]()
        })
        
        self.playerDataCard = PlayerDataCard()
        self.addChild(self.playerDataCard)
        
        self.gameTabBar = GameTabBar(state: GameTabBar.states.hangar)
        self.addChild(self.gameTabBar)
    }
    
    override func setAlertState() {
        self.nextState = .alert
    }
    
    override func setDefaultState() {
        self.nextState = .hangar
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
                
            case states.hangar:
                
                if ((currentTime - self.lastUpdate) > 1) {
                    self.lastUpdate = currentTime
                    for item in self.scrollNode.cells {
                        if let card = item as? HangarSpaceshipCard {
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
                
            case .research:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                self.view?.presentScene(ResearchScene())
                break
                
            case .mission:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                self.view?.presentScene(MissionScene())
                break
                
            case .mothership:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                self.view?.presentScene(MothershipScene())
                break
                
            case .factory:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                self.view?.presentScene(FactoryScene())
                break
                
            case states.hangar:
                self.blackSpriteNode.hidden = true
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
                case states.hangar:
                    
                    if(self.gameTabBar.buttonResearch.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.research
                        return
                    }
                    
                    if(self.gameTabBar.buttonMission.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.mission
                        return
                    }
                    
                    if(self.gameTabBar.buttonMothership.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.mothership
                        return
                    }
                    
                    if(self.gameTabBar.buttonFactory.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.factory
                        return
                    }
                    
                    for slot in self.slots {
                        if(slot.containsPoint(touch.locationInNode(self))) {
                            
                            for item in self.scrollNode.cells {
                                if let card = item as? HangarSpaceshipCard {
                                    if (card.spaceship.spaceshipData == slot.spaceship?.spaceshipData) {
                                        card.removeSpaceship()
                                    }
                                }
                            }
                            slot.remove()
                            return
                        }
                    }
                    
                    
                    if (self.scrollNode.containsPoint(touch.locationInNode(self.spaceshipListShape.cropNode))) {
                        for item in self.scrollNode.cells {
                            if (item.containsPoint(touch.locationInNode(self.scrollNode))) {
                                if let card = item as? HangarSpaceshipCard {
                                    if let buttonSelect = card.buttonSelect{
                                        if (buttonSelect.containsPoint(touch.locationInNode(card))) {
                                            if ((card.position.y < 140) && (card.position.y > -130)) {
                                                
                                                if card.selected {
                                                    
                                                    card.removeSpaceship()
                                                    
                                                    for slot in self.slots {
                                                        if(slot.spaceship?.spaceshipData == card.spaceship.spaceshipData) {
                                                            slot.remove()
                                                            break
                                                        }
                                                    }
                                                    
                                                } else {
                                                    
                                                    var slotEmptyFound = false
                                                    for slot in self.slots {
                                                        if(slot.spaceship == nil) {
                                                            slot.update(card.spaceship.spaceshipData!)
                                                            card.addSpaceship()
                                                            slotEmptyFound = true
                                                            break
                                                        }
                                                    }
                                                    
                                                    if !slotEmptyFound {
                                                        
                                                        let alertBox = AlertBox(title: "Alert!", text: "Mothership full, remove a spaceship.", type: .OK)
                                                        self.addChild(alertBox)
                                                        alertBox.buttonOK.addHandler {
                                                            self.nextState = .hangar
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
                                                let cost = GameMath.spaceshipUpgradeCost(level: card.spaceship.level, type: card.spaceship.type)
                                                if (cost <= self.playerData.points.integerValue) {
                                                    card.upgradeSpaceship(cost)
                                                    self.playerDataCard.updatePoints()
                                                    self.playerDataCard.updateXP()
                                                    
                                                    for slot in self.slots {
                                                        if (slot.spaceship?.spaceshipData == card.spaceship.spaceshipData) {
                                                            slot.updateSpaceshipLevel()
                                                            break
                                                        }
                                                    }
                                                    
                                                } else {
                                                    let alertBox = AlertBox(title: "Alert!", text: "Insuficient points.", type: .OK)
                                                    self.addChild(alertBox)
                                                    alertBox.buttonOK.addHandler {
                                                        self.nextState = .hangar
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