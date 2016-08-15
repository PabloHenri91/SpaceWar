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
    var selectedCard: MissionSpaceshipCard?
    
    var buttonBuy:Button?
    
    var playerDataCard:PlayerDataCard!
    
    var missionHeaderControl: Control!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<MissionSpaceshipCard>!
    
    var chooseAsteroidAlert: ChooseAsteroidAlert?
    var buyMinnerSpaceshipAlert: BuyMinnerSpaceshipAlert?
    var speedUpAlert: SpeedUpMinningAlert?
    
    enum states : String {
        
        case research
        case mission
        case mothership
        case factory
        case hangar
        
        case chooseMission
        case buySpaceship
        case speedUp
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
        
        if self.playerData.missionSpaceships.count < 4 {
            
            self.buttonBuy = Button(textureName: "buttonBuyMinnerSpaceship", x: 278, y: 85, xAlign: .center, top: 10, bottom: 10, left: 10, right: 10)
            self.addChild(self.buttonBuy!)
            
        }
        
        
        let labelTitle = Label(text: "MINING SPACESHIPS" , fontSize: 14, x: 160, y: 99, xAlign: .center , shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
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
    
    override func setAlertState() {
        //TODO: self.nextState = .alert
    }
    
    override func setDefaultState() {
        self.nextState = .mission
    }
    
    func updateScrollNode() {
        
        self.controlArray = Array<MissionSpaceshipCard>()
        
        for item in MemoryCard.sharedInstance.playerData.missionSpaceships {
            self.controlArray.append(MissionSpaceshipCard(missionSpaceship: MissionSpaceship(missionSpaceshipData: item as! MissionSpaceshipData)))
        }
        
        for item in self.scrollNode.cells {
            if let card = item as? MissionSpaceshipCard {
                card.removeFromParent()
            }
        }
        
        self.scrollNode.removeFromParent()
        
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 20, y: 130, xAlign: .center, spacing: 16 , scrollDirection: .vertical)
        
        self.scrollNode.zPosition = -1000
        
        self.addChild(self.scrollNode)
        
        if MemoryCard.sharedInstance.playerData.missionSpaceships.count == 4 {
            self.buttonBuy?.removeFromParent()
            self.buttonBuy = nil
        }
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .mission:
                self.playerDataCard.update()
                
                for item in self.scrollNode.cells {
                    if let card = item as? MissionSpaceshipCard {
                        card.update(currentTime)
                    }
                }
                break
                
            case .speedUp:
                if let speedUpAlertSafe = self.speedUpAlert {
                    let time = GameMath.missionTimeLeft(startDate: speedUpAlertSafe.missionSpaceship.missionspaceshipData!.startMissionDate!, missionDuration: speedUpAlertSafe.missionType.duration)
                    
                    if time > 0 {
                        speedUpAlertSafe.update(currentTime)
                    } else {
                        speedUpAlertSafe.removeFromParent()
                        self.nextState = .mission
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
                self.blackSpriteNode.hidden = true
                self.scrollNode.canScroll = true
                self.chooseAsteroidAlert?.scrollNode?.removeFromParent()
                self.chooseAsteroidAlert?.removeFromParent()
                self.buyMinnerSpaceshipAlert?.removeFromParent()
                self.speedUpAlert?.removeFromParent()
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
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                self.view?.presentScene(HangarScene())
                break
                
            case .chooseMission:
                if let spaceship = self.selectedSpaceship {
                    self.blackSpriteNode.hidden = false
                    self.blackSpriteNode.zPosition = 10000
                    self.chooseAsteroidAlert = ChooseAsteroidAlert(minerSpaceship: spaceship)
                    self.chooseAsteroidAlert!.zPosition = self.blackSpriteNode.zPosition + 1
                    self.scrollNode.canScroll = false
                    self.chooseAsteroidAlert!.buttonCancel.addHandler({ self.nextState = .mission
                    })
                    self.addChild(self.chooseAsteroidAlert!)
                } else {
                    #if DEBUG
                        fatalError()
                    #endif
                }
                break
                
            case .buySpaceship:
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = 10000
                self.buyMinnerSpaceshipAlert = BuyMinnerSpaceshipAlert()
                self.buyMinnerSpaceshipAlert!.zPosition = self.blackSpriteNode.zPosition + 1
                self.scrollNode.canScroll = false
                self.buyMinnerSpaceshipAlert!.buttonCancel.addHandler({ self.nextState = .mission
                })
                self.addChild(self.buyMinnerSpaceshipAlert!)
                break
                
            case .speedUp:
                if let spaceship = self.selectedSpaceship {
                    //self.view?.presentScene(ChooseMissionScene(missionSpaceship: spaceship))
                    self.blackSpriteNode.hidden = false
                    self.blackSpriteNode.zPosition = 10000
                    self.speedUpAlert = SpeedUpMinningAlert(missionSpaceship: spaceship)
                    self.speedUpAlert!.zPosition = self.blackSpriteNode.zPosition + 1
                    self.scrollNode.canScroll = false
                    self.speedUpAlert!.buttonCancel.addHandler({ self.nextState = .mission
                    })
                    self.addChild(self.speedUpAlert!)
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
    
    override func touchesBegan(touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let point = touch.locationInNode(self)
                switch (self.state) {
                case .mission:
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
                case .mission:
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
                case .mission:
                    
                    if self.playerDataCard.statistics.isOpen {
                        return
                    }
                    
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
                    
                    if let safeButtonBuy = self.buttonBuy {
                        if (safeButtonBuy.containsPoint(touch.locationInNode(self))){
                            self.nextState = .buySpaceship
                        }
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
                                                self.selectedCard = card
                                                return
                                            }
                                        }
                                        
                                        if let buttonColect = card.buttonColect {
                                            if(buttonColect.containsPoint(touch.locationInNode(card))) {
                                                card.colect()
                                                self.playerDataCard.updatePoints()
                                                self.playerDataCard.updateXP()
                                                
                                                return
                                            }
                                        }
                                        
                                        if let buttonSpeedUp = card.buttonSpeedUp {
                                            if(buttonSpeedUp.containsPoint(touch.locationInNode(card))) {
                                                self.selectedSpaceship = card.missionSpaceship
                                                self.nextState = .speedUp
                                                return
                                            }
                                        }
                                        
   
                                        if let buttonUpgrade = card.buttonUpgrade {
                                            if(buttonUpgrade.containsPoint(touch.locationInNode(card))) {
                                                let alertBox = AlertBox(title: "Price", text: "It will cost 2000 frags.", type: AlertBox.messageType.OKCancel)
                                                
                                                alertBox.buttonOK.addHandler(
                                                    {
                                                        if card.upgrade() == false {
                                                            let alertBox2 = AlertBox(title: "Price", text: "No enough bucks bro. 😢😢", type: AlertBox.messageType.OK)
                                                            self.addChild(alertBox2)
                                                        } else {
                                                            self.playerDataCard.updatePoints()
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
                    
                case .chooseMission:
                    
                    if let scroll = self.chooseAsteroidAlert!.scrollNode {
                        
                        if scroll.containsPoint(touch.locationInNode(self.chooseAsteroidAlert!.cropBox.cropNode)) {
                            for item in scroll.cells {
                                if (item.containsPoint(touch.locationInNode(scroll))) {
                                    if let missionTypeCard = item as? MissionTypeCard {
                                        if missionTypeCard.buttonSelect.containsPoint(touch.locationInNode(missionTypeCard)){
                                            missionTypeCard.selectMission()
                                            self.nextState = .mission
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
 
                    break
                    
                case .buySpaceship:
                    if let buyAlert = self.buyMinnerSpaceshipAlert {
                        if buyAlert.buttonBuy.containsPoint(touch.locationInNode(buyAlert)){
                            if buyAlert.buyMinningSpaceship() == false {
                                
                                let alertBox = AlertBox(title: "Price", text: "No enough bucks bro. 😢😢", type: AlertBox.messageType.OK)
                                alertBox.buttonOK.addHandler({ self.nextState = .mission
                                })
                                self.addChild(alertBox)
                                
                            } else {
                                self.updateScrollNode()
                                self.playerDataCard.updatePoints()
                                self.nextState = .mission
                            }
                        }
                    }
                    
                    break
                
                case .speedUp:
                    if let speedUpAlert = self.speedUpAlert {
                        
                        let point = touch.locationInNode(speedUpAlert)
                        
                        if speedUpAlert.buttonFinish.containsPoint(point) {
                            if speedUpAlert.finishWithPremiumPoints() == false {
                                let alertBox = AlertBox(title: "Price", text: "No enough diamonds bro. 😢😢", type: AlertBox.messageType.OK)
                                alertBox.buttonOK.addHandler({self.nextState = .mission
                                })
                                self.addChild(alertBox)
                            } else {
                                self.playerDataCard.updatePremiumPoints()
                                self.nextState = .mission
                                return
                            }
                        }
                        
                        #if os(iOS)
                            if GameAdManager.sharedInstance.zoneIsReady {
                                if speedUpAlert.buttonWatch.containsPoint(point) {
                                    self.playVideoAd()
                                    self.nextState = .mission
                                    return
                                }
                            }
                        #endif
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    #if os(iOS)
    override func videoAdAttemptFinished(shown: Bool) {
        if shown {
            if let speedUpAlert = self.speedUpAlert {
                speedUpAlert.speedUpWithVideoAd()
            }
        }
    }
    
    override func zoneLoading() {
        if let speedUpAlert = self.speedUpAlert {
            speedUpAlert.buttonWatch.runAction(SKAction.fadeAlphaTo(0, duration: 1))
            speedUpAlert.labelWatch.runAction(SKAction.fadeAlphaTo(0, duration: 1))
        }
    }
    
    override func zoneReady() {
        if let speedUpAlert = self.speedUpAlert {
            speedUpAlert.buttonWatch.runAction(SKAction.fadeAlphaTo(1, duration: 1))
            speedUpAlert.labelWatch.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        }
    }
    #endif
}