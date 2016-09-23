//
//  ResearchScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class ResearchScene: GameScene {
    
    var scrollNode:ScrollNode?
    
    var currentResearchCard:ResearchCard?
    
    var header0 = [Control]()
    var label0:Label!
    var header1 = [Control]()
    var label1:Label!
    
    var auxHeader:Control!
    
    var gameStore: GameStore?
    
    enum states : String {
        
        //Estado de alertBox
        case alert
        
        //Estados de saida da scene
        
        case research
        case mission
        case mothership
        case factory
        case hangar
    }
    
    //Estados iniciais
    var state = states.research
    var nextState = states.research
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
            
        case .research:
            break
            
        case .mission, .mothership, .factory, .hangar:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.moveToParent(self)
            }
            break
        }
        
        Music.sharedInstance.playMusicWithType(Music.musicTypes.menu)
        
        self.header0.append(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 246/255, green: 251/255, blue: 255/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 67, size: CGSize(width: self.size.width,
                height: 56)))
        self.header0.append(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 123, size: CGSize(width: self.size.width,
                height: 3)))
        self.label0 = Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "label0", fontSize: 14, x: 160, y: 101, xAlign: .center, yAlign: .up, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2))
        
        self.header1.append(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 226, size: CGSize(width: self.size.width,
                height: 3)))
        self.header1.append(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 246/255, green: 251/255, blue: 255/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 229, size: CGSize(width: self.size.width,
                height: 56)))
        self.header1.append(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 285, size: CGSize(width: self.size.width,
                height: 3)))
        self.label1 = Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "label1", fontSize: 14, x: 160, y: 257, xAlign: .center, yAlign: .up, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2))
        
        self.auxHeader = Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 201/255, green: 207/255, blue: 213/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
                                  y: 123, size: CGSize(width: self.size.width,
                                    height: 162))
        self.addChild(self.auxHeader)
        self.auxHeader.zPosition = -1
        self.auxHeader.hidden = true
        
        
        for control in self.header0 {
            self.addChild(control)
        }
        self.addChild(self.label0)
        
        for control in self.header1 {
            self.addChild(control)
        }
        self.addChild(self.label1)
        
        self.updateResearches()
        
        switch GameTabBar.lastState {
        case .research:
            break
        case .mission, .mothership, .factory, .hangar:
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
        
        self.gameTabBar = GameTabBar(state: GameTabBar.states.research)
        self.addChild(self.gameTabBar)
    }
    
    override func setAlertState() {
        self.nextState = .alert
    }
    
    override func setDefaultState() {
        self.nextState = .research
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
            case .research:
                
                self.playerDataCard.update()
                
                if let researchCard = self.currentResearchCard {
                    researchCard.update(currentTime)
                }
                
                break
                
            case .alert:
                self.gameStore?.update()
                break
                
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case .research:
                self.blackSpriteNode.hidden = true
                self.scrollNode?.canScroll = true
                self.gameStore?.removeFromParent()
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
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                
                self.view?.presentScene(HangarScene())
                break
                
            case .alert:
                break
            }
        }
    }
    
    func updateResearches() {
        
        self.currentResearchCard?.removeFromParent()
        self.currentResearchCard = nil

        var researchCards = Array<ResearchCard>()
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        for item in playerData.researches {
            if let researchData = item as? ResearchData {
                let research = Research(researchData: researchData)
                
                    if researchData.spaceshipLevel != researchData.spaceshipMaxLevel {
                        if let researchCard = ResearchCard(research: research) {
                            if researchData.startDate == nil {
                                researchCards.append(researchCard)
                            } else {
                                researchCard.screenPosition = CGPoint(x: 20, y: 143)
                                researchCard.xAlign = .center
                                researchCard.resetPosition()
                                self.addChild(researchCard)
                                self.currentResearchCard = researchCard
                            }
                        }
                    }
                
            }
        }
        
        if self.currentResearchCard != nil {
            
            for control in self.header1 {
                control.hidden = false
            }
            self.label1.hidden = false
            
            self.label0.setText("RESEARCH IN PROGRESS")
            
            if researchCards.count > 0 {
                self.label1.setText("AVAILABLE RESEARCHES")
            } else {
                for control in self.header1 {
                    control.hidden = true
                }
                self.label1.hidden = true
            }
            
            self.auxHeader.hidden = false
            
        } else {
            
            for control in self.header1 {
                control.hidden = true
            }
            self.label1.hidden = true
            
            if researchCards.count > 0 {
                self.label0.setText("AVAILABLE RESEARCHES")
            } else {
                self.label0.setText("NO AVAILABLE RESEARCHES")
            }
            
            self.auxHeader.hidden = true
        }
        
        if researchCards.count > 0 {
            
            if let scrollNode = self.scrollNode {
                scrollNode.removeFromParent()
            }
            
            var x = 0
            var y = 0
            if self.currentResearchCard != nil {
                x = 20
                y = 301
            } else {
                x = 20
                y = 143
            }

            self.scrollNode = ScrollNode(cells: researchCards, x: x, y: y, xAlign: .center, yAlign: .center, spacing: -25, scrollDirection: .vertical)
            self.addChild(self.scrollNode!)
            self.scrollNode?.zPosition = -20
            
            if let scrollNode = self.scrollNode {
                if self.currentResearchCard != nil {
                    scrollNode.canScroll = scrollNode.cells.count > 2
                } else {
                    scrollNode.canScroll = scrollNode.cells.count > 4
                }
            }
            
        } else {
            self.scrollNode?.removeFromParent()
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let point = touch.locationInNode(self)
                switch (self.state) {
                case .research:
                    if self.playerDataCard.containsPoint(point) {
                        if self.playerDataCard.buttonStore.containsPoint(touch.locationInNode(self.playerDataCard)) {
                            self.gameStore = GameStore()
                            self.addChild(self.gameStore!)
                            return
                        }
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
                case .research:
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
                case .research:
                    
                    if self.playerDataCard.statistics.isOpen {
                        return
                    }
                    
                    if self.playerDataCard.containsPoint(point) {
                        return
                    }
                    
                    if self.gameTabBar.containsPoint(point) {
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
                        
                        if(self.gameTabBar.buttonFactory.containsPoint(touch.locationInNode(self.gameTabBar))) {
                            self.nextState = states.factory
                            return
                        }
                        return
                    }
                    
                    if let researchCard = self.currentResearchCard {
                        if let buttonSpeedup = researchCard.buttonSpeedUp {
                            if(buttonSpeedup.containsPoint(touch.locationInNode(researchCard))) {
                                // TODO:buttonSpeedup.containsPoint
                                return
                            }
                        }
                        
                        if let buttonCollect = researchCard.buttonCollect {
                            if(buttonCollect.containsPoint(touch.locationInNode(researchCard))) {
                                
                                
                                researchCard.research.collect()
                                self.playerDataCard.updateXP()
                                self.updateResearches()
                                
                                if let spaceship = researchCard.spaceship {
                                    self.blackSpriteNode.hidden = false
                                    self.blackSpriteNode.zPosition = 10000
                                    
                                    self.scrollNode?.canScroll = false
                                    
                                    if researchCard.research.researchData!.spaceshipLevel.integerValue > 10 {
                                        
                                        let detailsAlert = ResearchUpgradeSpaceshipAlert(research: researchCard.research)
                                        detailsAlert.zPosition = self.blackSpriteNode.zPosition + 1
                                        
                                        detailsAlert.buttonCancel.addHandler({ [weak self] in
                                            self?.nextState = .research
                                            })
                                        
                                        detailsAlert.buttonGoToHangar.addHandler({ [weak self] in
                                            self?.nextState = .hangar
                                            })

                                        
                                        self.addChild(detailsAlert)
                                        self.nextState = .alert
                                        
                                    } else {
                                        
                                        let detailsAlert = HangarSpaceshipDetails(spaceship: spaceship, showUpgrade: false)
                                        detailsAlert.zPosition = self.blackSpriteNode.zPosition + 1
                                        
                                        detailsAlert.loadButtonGoToFactory()
                                        detailsAlert.buttonGoToFactory.event = nil
                                        detailsAlert.buttonGoToFactory.addHandler({ [weak self] in
                                            self?.nextState = .factory
                                            detailsAlert.removeFromParent()
                                            })
                                        
                                        detailsAlert.buttonCancel.addHandler({ [weak self] in
                                            self?.nextState = .research
                                            })
                                        
                                        self.addChild(detailsAlert)
                                        self.nextState = .alert
                                        
                                    }
                                
                                }
                                
                                return
                            }
                        }
                    }
                    
                    if let scrollNode = self.scrollNode {
                        
                        if scrollNode.containsPoint(point) {
                            
                            for item in scrollNode.cells {
                                
                                if item.containsPoint(touch.locationInNode(scrollNode)) {
                                    
                                    if let researchCard = item as? ResearchCard {
                                        
                                        if let buttonBegin = researchCard.buttonBegin {
                                            if(buttonBegin.containsPoint(touch.locationInNode(researchCard))) {
                                                if researchCard.research.start() {
                                                    self.updateResearches()
                                                } else {
                                                    let alertBox = AlertBox(title: "Alert!", text: "You have a research doing, wait it finish", type: AlertBox.messageType.OK)
                                                    self.addChild(alertBox)
                                                }
                                                return
                                            }
                                        }
                                    }
                                    return
                                }
                            }
                        }
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