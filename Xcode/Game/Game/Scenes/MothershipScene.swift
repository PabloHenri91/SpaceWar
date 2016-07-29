//
//  MothershipScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipScene: GameScene {
    
    enum states : String {
        
        case alert
        
        //Estados de saida da scene
        case battle
        case social
        
        case research
        case mission
        case mothership
        case factory
        case hangar
    }
    
    //Estados iniciais
    var state = states.mothership
    var nextState = states.mothership
    
    var playerData:PlayerData!
    
    var buttonRanking:Button!
    var buttonSocial:Button!
    
    var buttonBattle:Button!
    
    var batteryControl:BatteryControl!
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
        case .research, .mission:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        case .mothership:
            break
        case .factory, .hangar:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.removeFromParent()
                self.addChild(node)
            }
            break
        }
        
        Music.sharedInstance.playMusicWithType(Music.musicTypes.menu)
        
        self.playerData = MemoryCard.sharedInstance.playerData
        
        self.addChild(Control(textureName: "mothershipBackground", x: -54, y: 0, xAlign: .center, yAlign: .center))
        
        var xpForNextLevel = GameMath.xpForNextLevel(level: self.playerData.motherShip.level.integerValue)
        let xp = self.playerData.motherShip.xp.integerValue
        if (xpForNextLevel <= xp) {
            self.playerData.motherShip.level = NSNumber(int: self.playerData.motherShip.level.integerValue + 1)
            self.playerData.motherShip.xp = NSNumber(integer: xp - xpForNextLevel)
            
            #if os(iOS)
                Metrics.levelUp()
                if let vc = self.view?.window?.rootViewController as? GameViewController {
                    vc.saveLevel(Int(self.playerData.motherShip.level))
                }
            #endif
            
            self.blackSpriteNode.hidden = false
            self.blackSpriteNode.zPosition = 100000
            
            let alertBox = AlertBox(title: "Level up", text: "You go to level " + self.playerData.motherShip.level.description + "! 😃 ", type: AlertBox.messageType.OK)
            alertBox.buttonOK.addHandler({
                self.nextState = .mothership
            })
            self.nextState = .alert
            self.addChild(alertBox)
        }
        
        xpForNextLevel = GameMath.xpForNextLevel(level: self.playerData.motherShip.level.integerValue)
        
        self.batteryControl = BatteryControl(x: 75, y: 229, xAlign: .center, yAlign: .center)
        self.addChild(self.batteryControl)
        
        self.buttonRanking = Button(textureName: "button", text: "Ranking", x: 96, y: 200, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonRanking)
        self.buttonRanking.hidden = true
        
        self.buttonSocial = Button(textureName: "button", text: "Social", x: 96, y: 250, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonSocial)
        self.buttonSocial.hidden = true
        
        self.buttonBattle = Button(textureName: "buttonBattle", text: "BATTLE", x: 74, y: 287, xAlign: .center, yAlign: .down, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 20/100), fontShadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.buttonBattle)
        
        switch GameTabBar.lastState {
        case .research, .mission:
            for node in self.children {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.runAction(SKAction.moveTo(nodePosition, duration: actionDuration))
            }
            break
        case .mothership:
            break
        case .factory, .hangar:
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
        
        self.gameTabBar = GameTabBar(state: GameTabBar.states.mothership)
        self.addChild(self.gameTabBar)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            default:
                self.batteryControl.update()
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
                self.blackSpriteNode.hidden = true
                break
                
            case .factory:
                GameScene.lastChildren = self.children
                self.view?.presentScene(FactoryScene())
                break
                
            case .hangar:
                GameScene.lastChildren = self.children
                self.view?.presentScene(HangarScene())
                break
                
            case .battle:
                self.view?.presentScene(BattleScene())
                break
                
            case .social:
                #if os(iOS)
                    self.view?.presentScene(InviteFriendsScene())
                #endif
                break
            
            case .social:
                #if os(iOS)
                   self.view?.presentScene(SocialScene())
                #else
                   self.nextState = .mothership
                #endif
    
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
                case states.mothership:
                    
                    if(self.buttonRanking.containsPoint(touch.locationInNode(self))) {
                        #if os(iOS)
                            if let vc = self.view?.window?.rootViewController as? GameViewController {
                                vc.showLeader()
                            }
                        #endif
                        return
                    }
                    
                    if(self.buttonBattle.containsPoint(touch.locationInNode(self))) {
                        
                        if let battery = self.playerData.battery {
                            if battery.charge.integerValue > 0 {
                                self.batteryControl.useCharge()
                            } else {
                                
                                self.blackSpriteNode.hidden = false
                                self.blackSpriteNode.zPosition = 100000
                                
                                
                                let teste = AlertBox(title: "Alert!!!", text: "Battery Critically Low", type: .OK)
                                teste.zPosition = self.blackSpriteNode.zPosition + 1
                                self.addChild(teste)
                                teste.buttonOK.addHandler {
                                    self.nextState = .mothership
                                }
                                self.nextState = .alert
                                
                                return
                            }
                        }
                        
                        if (self.playerData.motherShip.spaceships.count == 4) {
                            self.nextState = states.battle
                        } else {
                            self.blackSpriteNode.hidden = false
                            self.blackSpriteNode.zPosition = 100000
                            
                            
                            let teste = AlertBox(title: "Alert!!!", text: "Missing spaceships, go to hangar", type: .OK)
                            teste.zPosition = self.blackSpriteNode.zPosition + 1
                            self.addChild(teste)
                            teste.buttonOK.addHandler {
                                self.nextState = .hangar
                            }
                            self.nextState = .alert
                        }
                        
                        return
                    }
                    
                    if(self.gameTabBar.buttonMission.containsPoint(touch.locationInNode(self.gameTabBar))) {
                            self.nextState = states.mission
                        return
                    }
                    
                    if(self.gameTabBar.buttonHangar.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.hangar
                        return
                    }
                    
                    if(self.gameTabBar.buttonResearch.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.research
                        return
                    }
                    
                    if(self.gameTabBar.buttonFactory.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.factory
                        return
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }

}
