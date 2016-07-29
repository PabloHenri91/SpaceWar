//
//  FactoryScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//
import SpriteKit


class FactoryScene: GameScene {
    
    
    var playerData = MemoryCard.sharedInstance.playerData
    let unlockedSpaceships = MemoryCard.sharedInstance.playerData.unlockedSpaceships as! Set<SpaceshipData>
    
    var labelShips:Label!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<FactorySpaceShipCard>!
    
    var spaceShipListShape: CropBox!
    
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
    var state = states.factory
    var nextState = states.factory
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
        case .research, .mission, .mothership:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        case .factory:
            break
        case .hangar:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        }
        
        let line = Control(textureName: "lineHangar", x: 0, y: 194, xAlign: .center, yAlign: .center)
        self.addChild(line)
        
        self.spaceShipListShape = CropBox(textureName: "spaceShipListShape")
        self.addChild(spaceShipListShape)
        self.spaceShipListShape.screenPosition = CGPoint(x: 20, y: 228)
        self.spaceShipListShape.resetPosition()
        
        self.labelShips = Label(color: SKColor.whiteColor(), text: "Unlocked spaceships",fontSize: 16, x: 57, y: 213, xAlign: .center, yAlign: .center, horizontalAlignmentMode: .Left)
        self.addChild(self.labelShips)
        
        self.controlArray = Array<FactorySpaceShipCard>()
        
        for item in self.unlockedSpaceships {
            let spaceship = Spaceship(spaceshipData: item)
            self.controlArray.append(FactorySpaceShipCard(spaceShip: spaceship))
        }
    
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
        self.spaceShipListShape.addChild(self.scrollNode)
        
        switch GameTabBar.lastState {
        case .research, .mission, .mothership:
            for node in self.children {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.runAction(SKAction.moveTo(nodePosition, duration: actionDuration))
            }
            break
        case .factory:
            break
        case .hangar:
            for node in self.children {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.runAction(SKAction.moveTo(nodePosition, duration: actionDuration))
            }
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
        
        self.gameTabBar = GameTabBar(state: GameTabBar.states.factory)
        self.addChild(self.gameTabBar)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
                
            case states.factory:
                break
                
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case .research:
                GameScene.lastChildren = self.children
                self.view?.presentScene(ResearchScene())
                break
                
            case .mission:
                GameScene.lastChildren = self.children
                self.view?.presentScene(MissionScene())
                break
                
            case .mothership:
                GameScene.lastChildren = self.children
                self.view?.presentScene(MothershipScene())
                break
                
            case states.factory:
                self.blackSpriteNode.hidden = true
                break
                
            case .hangar:
                GameScene.lastChildren = self.children
                self.view?.presentScene(HangarScene())
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
                case states.factory:
                    
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
                    
                    if(self.gameTabBar.buttonHangar.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.hangar
                        return
                    }
                    
                    if (self.scrollNode.containsPoint(touch.locationInNode(self.spaceShipListShape.cropNode))) {
                        for item in self.scrollNode.cells {
                            if (item.containsPoint(touch.locationInNode(self.scrollNode))) {
                                if let card = item as? FactorySpaceShipCard {
                                    
                                    if (card.buttonBuy.containsPoint(touch.locationInNode(card))) {
                                        if ((card.position.y < 140) && (card.position.y > -130)) {
                                            
                                            if (self.playerData.points.integerValue > GameMath.spaceshipPrice(card.spaceShip.type)) {
                                                card.buySpaceship()
                                            } else {
                                                
                                                self.blackSpriteNode.hidden = false
                                                self.blackSpriteNode.zPosition = 100000
                                                
                                                
                                                let teste = AlertBox(title: "Alert!!!", text: "Insuficient funds!", type: .OK)
                                                teste.zPosition = self.blackSpriteNode.zPosition + 1
                                                self.addChild(teste)
                                                teste.buttonOK.addHandler {
                                                    self.nextState = .factory
                                                }
                                                self.nextState = .alert
                                            }
                                        }
                                    }
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