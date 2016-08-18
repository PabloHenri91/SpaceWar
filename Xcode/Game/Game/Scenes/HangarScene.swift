//
//  HangarScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
   
    var playerData = MemoryCard.sharedInstance.playerData
    let spaceshipsData = MemoryCard.sharedInstance.playerData.motherShip.spaceships as! Set<SpaceshipData>
    var spaceships = [Spaceship]()
    
    var hangarCardsArray:Array<HangarSpaceshipCard>!
    
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
                node.moveToParent(self)
            }
            break
        case .hangar:
            break
        }
        
        
        let hangarHeaderControl = Control(textureName: "missionSceneHeader", x:0, y:63, xAlign: .center, yAlign: .center)
        self.addChild(hangarHeaderControl)
        
        let labelTitle = Label(text: "SELECT SPACESHIPS" , fontSize: 14, x: 160, y: 99, xAlign: .center , shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
       
        self.hangarCardsArray = Array<HangarSpaceshipCard>()
        
        var index = 0
        for spaceshipData in spaceshipsData {
            let spaceship = Spaceship(spaceshipData: spaceshipData)
            spaceship.loadAllyDetails()
            
            var x = 0
            var y = 0
            
            switch index {
            case 0:
                x = 3
                y = 131
                break
                
            case 1:
                x = 165
                y = 131
                break
                
            case 2:
                x = 3
                y = 323
                break
                
            case 3:
                x = 165
                y = 323
                break
                
            default:
                break
            }
            
            let card = HangarSpaceshipCard(spaceship: spaceship, x: x, y: y)
            self.addChild(card)
            
            self.hangarCardsArray.append(card)
            index += 1
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
                
            case .hangar:
                self.playerDataCard.update()
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
                
            case .hangar:
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
    
    override func touchesBegan(touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let point = touch.locationInNode(self)
                switch (self.state) {
                case .hangar:
                    if self.playerDataCard.containsPoint(point) {
                        self.playerDataCard.statistics.updateOnTouchesBegan()
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for _ in touches {
                switch (self.state) {
                case .hangar:
                    self.playerDataCard.statistics.updateOnTouchesEnded()
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case .hangar:
                    
                    if self.playerDataCard.statistics.isOpen {
                        return
                    }
                    
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

                    
                    break
//                    let cost = GameMath.spaceshipUpgradeCost(level: card.spaceship.level, type: card.spaceship.type)
//                    if (cost <= self.playerData.points.integerValue) {
//                        card.upgradeSpaceship(cost)
//                        self.playerDataCard.updatePoints()
//                        self.playerDataCard.updateXP()
//                        
//                    } else {
//                        let alertBox = AlertBox(title: "Alert!", text: "Insuficient points.", type: .OK)
//                        self.addChild(alertBox)
//                        alertBox.buttonOK.addHandler {
//                            self.nextState = .hangar
//                        }
//                        self.nextState = .alert
//                    }

                    
                default:
                    break
                }
            }
        }
        
    }
    
}