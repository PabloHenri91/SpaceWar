//
//  MissionScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class MissionScene: GameScene {
    
    var playerData = MemoryCard.sharedInstance.playerData
    let missionShips = MemoryCard.sharedInstance.playerData.missionSpaceships
    
    var selectedSpaceship: MissionSpaceship?
    
    var buttonBack:Button!
    
    var playerDataCard:PlayerDataCard!
    
    var missionHeaderControl: Control!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<MissionSpaceshipCard>!
    
    enum states : String {
        
        case research
        case mission
        case mothership
        case factory
        case hangar
        
        case chooseMission
    }
    
    //Estados iniciais
    var state = states.mission
    var nextState = states.mission
    
    var gameTabBar:GameTabBar!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
        case .research:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        case .mission:
            break
        case .mothership, .factory, .hangar:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        }
        
        self.controlArray = Array<MissionSpaceshipCard>()
        
        for item in missionShips {
            self.controlArray.append(MissionSpaceshipCard(missionSpaceship: MissionSpaceship(missionSpaceshipData: item as! MissionSpaceshipData)))
        }
        
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 20, y: 130, xAlign: .center, spacing: 16 , scrollDirection: .vertical)
        self.addChild(self.scrollNode)
        
        
        self.missionHeaderControl = Control(textureName: "missionSceneHeader", x:0, y:63, xAlign: .center, yAlign: .center)
        self.addChild(self.missionHeaderControl)
        
        let labelTitle = Label(text: "MINNER SPACESHIPS" , fontSize: 14, x: 160, y: 99, xAlign: .center , shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        
        switch GameTabBar.lastState {
        case .research:
            for node in self.children {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.runAction(SKAction.moveTo(nodePosition, duration: actionDuration))
            }
            break
        case .mission:
            break
        case .mothership, .factory, .hangar:
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
        
        self.gameTabBar = GameTabBar(state: GameTabBar.states.mission)
        self.addChild(self.gameTabBar)
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .mission:
                
                for item in self.scrollNode.cells {
                    if let card = item as? MissionSpaceshipCard {
                        card.update(currentTime)
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
                GameScene.lastChildren = self.children
                self.view?.presentScene(ResearchScene())
                break
                
            case .mission:
                break
                
            case .mothership:
                GameScene.lastChildren = self.children
                self.view?.presentScene(MothershipScene())
                break
                
            case .factory:
                GameScene.lastChildren = self.children
                self.view?.presentScene(FactoryScene())
                break
                
            case .hangar:
                GameScene.lastChildren = self.children
                self.view?.presentScene(HangarScene())
                break
                
            case .chooseMission:
                if let spaceship = self.selectedSpaceship {
                    self.view?.presentScene(ChooseMissionScene(missionSpaceship: spaceship))
                } else {
                    #if DEBUG
                        fatalError()
                    #endif
                }
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
                case states.mission:
                    
                    if(self.gameTabBar.buttonResearch.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.research
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
                    
                    if(self.gameTabBar.buttonHangar.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.hangar
                        return
                    }
                    
                   
                    
                    if (self.missionHeaderControl.containsPoint(touch.locationInNode(self))){
                        return
                    }
                    
                    if (self.playerDataCard.containsPoint(touch.locationInNode(self))) {
                        return
                    }
                    
                    if (self.scrollNode.containsPoint(touch.locationInNode(self))) {
                        for item in self.scrollNode.cells {
                            if (item.containsPoint(touch.locationInNode(self.scrollNode))) {
                                if let card = item as? MissionSpaceshipCard {
                                        if let buttonBegin = card.buttonBegin{
                                            if (buttonBegin.containsPoint(touch.locationInNode(card))) {
                                                self.nextState = .chooseMission
                                                self.selectedSpaceship = card.missionSpaceship
                                                return
                                            }
                                        }
                                        
                                        if let buttonColect = card.buttonColect {
                                            if(buttonColect.containsPoint(touch.locationInNode(card))) {
                                                card.colect()
                                                return
                                            }
                                        }
                                        
                                        if let buttonSpeedUp = card.buttonSpeedUp {
                                            if(buttonSpeedUp.containsPoint(touch.locationInNode(card))) {
                                                print("SpeedUP")
                                                return
                                            }
                                        }
                                        
   
                                        if let buttonUpgrade = card.buttonUpgrade {
                                            if(buttonUpgrade.containsPoint(touch.locationInNode(card))) {
                                                let alertBox = AlertBox(title: "Price", text: "It will cost 2000 frags, want upgrade", type: AlertBox.messageType.OKCancel)
                                                
                                                alertBox.buttonOK.addHandler(
                                                    {
                                                        if card.upgrade() == false {
                                                            let alertBox2 = AlertBox(title: "Price", text: "No enough bucks bro 😢😢", type: AlertBox.messageType.OK)
                                                            self.addChild(alertBox2)
                                                        }
                                                    }
                                                )
                                                
                                                self.addChild(alertBox)
                                                return
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