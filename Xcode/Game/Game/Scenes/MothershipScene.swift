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
        
        //Estado de alertBox
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
    
    var buttonSocial:Button!
    
    var buttonBattle:Button!
    
    var batteryControl:BatteryControl!
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    var nextEvents:NextEvents!
    
    var spaceshipSlots = [SpaceshipSlot]()
    
    var lastShake: Double = 0
    
    var gameStore: GameStore?
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
        case .research, .mission:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.moveToParent(self)
            }
            break
            
        case .mothership:
            break
            
        case .factory, .hangar:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.moveToParent(self)
            }
            break
        }
        
        Music.sharedInstance.playMusicWithType(Music.musicTypes.menu)
        
        self.playerData = MemoryCard.sharedInstance.playerData
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 246/255, green: 251/255, blue: 255/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 67, size: CGSize(width: self.size.width,
                height: 56)))
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 123, size: CGSize(width: self.size.width,
                height: 3)))
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "BATTLESHIPS", fontSize: 14, x: 160, y: 101, xAlign: .center, yAlign: .up, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        self.batteryControl = BatteryControl(x: 75, y: 231, xAlign: .center, yAlign: .center)
        self.addChild(self.batteryControl)
        
        self.buttonSocial = Button(textureName: "button", text: "Social", x: 96, y: 250, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonSocial)
        self.buttonSocial.hidden = true
        
        self.buttonBattle = Button(textureName: "buttonBattle", text: "BATTLE", x: 74, y: 289, xAlign: .center, yAlign: .down, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 20/100), fontShadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, textOffset:CGPoint(x: 0, y: 1))
        self.addChild(self.buttonBattle)
        
        
        for i in 0..<4 {
            let spaceshipSlot = SpaceshipSlot(spaceship: nil)
            spaceshipSlot.xAlign = .center
            spaceshipSlot.yAlign = .up
            spaceshipSlot.screenPosition = CGPoint(x: 6 + (i * 80), y: 144)
            spaceshipSlot.resetPosition()
            self.addChild(spaceshipSlot)
            spaceshipSlots.append(spaceshipSlot)
        }
        
        var i = 0
        for item in self.playerData.motherShip.spaceships {
            if let spaceshipData = item as? SpaceshipData {
                spaceshipSlots[i].update(spaceshipData)
            }
            i += 1
        }
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 173/255, green: 177/255, blue: 180/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 352, size: CGSize(width: self.size.width,
                height: 2)))
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 232/255, green: 237/255, blue: 241/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 354, size: CGSize(width: self.size.width,
                height: 168)))
        
        self.nextEvents = NextEvents()
        self.addChild(self.nextEvents)
        
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
        
        RateMyApp.sharedInstance.showRatingAlert()
    }
    
    override func setAlertState() {
        self.nextState = .alert
    }
    
    override func setDefaultState() {
        self.nextState = .mothership
    }
    
    override func updatePremiumPoints() {
        self.playerDataCard.updatePremiumPoints()
    }
    
    override func updatePoints() {
        self.playerDataCard.updatePoints()
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .mothership:
                self.batteryControl.update()
                self.playerDataCard.update()
                self.gameStore?.update()
                self.nextEvents.update()
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
                self.blackSpriteNode.hidden = true
                self.gameStore?.removeFromParent()
                break
                
            case .factory:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                
                self.view?.presentScene(FactoryScene())
                break
                
            case .hangar:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                
                self.view?.presentScene(HangarScene())
                break
                
            case .battle:
                
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                
                GameScene.lastChildren = self.children
                for node in GameScene.lastChildren {
                    node.removeFromParent()
                }
                GameScene.lastChildren = [SKNode]()
                
                self.view?.presentScene(BattleScene())
                break
                
            case .social:
                #if os(iOS)
                    self.view?.presentScene(InviteFriendsScene())
                #endif
                break
                
            case .alert:
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
                case .mothership:
                    if self.playerDataCard.containsPoint(point) {
                        if self.playerDataCard.buttonStore.containsPoint(touch.locationInNode(self.playerDataCard)) {
                            self.gameStore = GameStore()
                            self.addChild(self.gameStore!)
                            return
                        }
                        self.playerDataCard.statistics.updateOnTouchesBegan()
                        return
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
                case .mothership:
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
                let point = touch.locationInNode(self)
                
                switch (self.state) {
                case .mothership:
                    
                    if self.playerDataCard.statistics.isOpen {
                        return
                    }
                    
//                    if self.headerControl.containsPoint(touch.locationInNode(self)) {
//                        return
//                    }
                    
                    if self.playerDataCard.containsPoint(touch.locationInNode(self)) {
                        return
                    }
                    
                    if self.gameTabBar.containsPoint(touch.locationInNode(self)) {
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
                        return
                    }
                    
                    for spaceshipSlot in self.spaceshipSlots {
                        if spaceshipSlot.containsPoint(touch.locationInNode(self)) {
                            self.nextState = states.hangar
                        }
                    }
                    
                    
                    if self.nextEvents.containsPoint(point) {
                        let point = touch.locationInNode(self.nextEvents)
                        for event in self.nextEvents.upcomingEvents {
                            if event.containsPoint(point) {
                                switch event.type {
                                case .missionSpaceshipEvent:
                                    self.nextState = .mission
                                    return
                                case .researchEvent:
                                    self.nextState = .research
                                    return
                                default:
                                    return
                                }
                            }
                        }
                    }
                    
                    if self.buttonBattle.containsPoint(point) {
                        
                        
                        if !self.batteryControl.useCharge() {
                            let alertBox = AlertBoxLowBattery()
                            self.addChild(alertBox)
                            alertBox.buttonOK.addHandler { [weak self, weak alertBox] in
                                guard let scene = self else { return }
                                guard let alertBox = alertBox else { return }
                                
                                alertBox.removeFromParent()
                                scene.gameStore = GameStore()
                                scene.addChild(scene.gameStore!)
                            }
                            
                            alertBox.buttonCancel.addHandler { [weak self, weak alertBox] in
                                guard let scene = self else { return }
                                guard let alertBox = alertBox else { return }
                                
                                alertBox.removeFromParent()
                                scene.setDefaultState()
                            }
                            
                            return
                        }
                        
                        self.nextState = .battle
                        return
                    }
                    
                    break
                    
                case .alert:
                    if let gameStore = self.gameStore {
                        if gameStore.containsPoint(point) {
                            gameStore.touchEnded(touch)
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
