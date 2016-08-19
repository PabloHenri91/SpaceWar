//
//  ResearchScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class ResearchScene: GameScene {
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var scrollNode:ScrollNode?
    
    var labelAvailableResearches:Label?
    
    var research:Research?
    
    enum states : String {
        
        case researchDetails
        
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
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 246/255, green: 251/255, blue: 255/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 67, size: CGSize(width: self.size.width,
                height: 56)))
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 123, size: CGSize(width: self.size.width,
                height: 3)))
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "RESEARCH LAB", fontSize: 14, x: 160, y: 101, xAlign: .center, yAlign: .up, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        self.updateResearchs()
        
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
        //TODO: self.nextState = .alert
    }
    
    override func setDefaultState() {
        self.nextState = .research
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .research:
                
                self.playerDataCard.update()
                
                if let scrollNode = self.scrollNode {
                    for item in scrollNode.cells {
                        if let researchCard = item as? ResearchCard {
                            researchCard.update(currentTime)
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
                
            case .researchDetails:
                self.view?.presentScene(ResearchDetailsScene(research: self.research!))
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func updateResearchs() {

        var researchCards = Array<ResearchCard>()
        
        for item in self.playerData.researches {
            if let researchData = item as? ResearchData {
                let research = Research(researchData: researchData)
                
                if research.isUnlocked() {
                    if researchData.done == false {
                        if let researchCard = ResearchCard(research: research) {
                            researchCards.append(researchCard)
                        }
                    }
                }
            }
        }
        
        if researchCards.count > 0 {
            
            if let scrollNode = self.scrollNode {
                scrollNode.removeFromParent()
            }
            
            if let labelAvailableResearches = self.labelAvailableResearches {
                labelAvailableResearches.removeFromParent()
            }

            self.scrollNode = ScrollNode(cells: researchCards, x: 20, y: 143, xAlign: .center, yAlign: .center, spacing: 10, scrollDirection: .vertical)
            self.addChild(self.scrollNode!)
            
        } else {
            self.scrollNode?.removeFromParent()
            //TODO:
            //self.labelNoResearchs = Label(text: "No researchs", fontSize: 24 , x: 160, y: 268)
            //self.addChild(self.labelNoResearchs!)
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
                switch (self.state) {
                case .research:
                    
                    if self.playerDataCard.statistics.isOpen {
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
                    
                    if(self.gameTabBar.buttonFactory.containsPoint(touch.locationInNode(self.gameTabBar))) {
                        self.nextState = states.factory
                        return
                    }
                    
                    if let scrollNode = self.scrollNode {
                        
                        if scrollNode.containsPoint(touch.locationInNode(self)) {
                            
                            for item in scrollNode.cells {
                                
                                if item.containsPoint(touch.locationInNode(scrollNode)) {
                                    
                                    if let researchCard = item as? ResearchCard {
                                        
                                        if let buttonBegin = researchCard.buttonBegin {
                                            if(buttonBegin.containsPoint(touch.locationInNode(researchCard))) {
                                                self.research = researchCard.research
                                                self.nextState = .researchDetails
                                                return
                                            }
                                        }
                                        
                                        if let buttonSpeedup = researchCard.buttonSpeedUp {
                                            if(buttonSpeedup.containsPoint(touch.locationInNode(researchCard))) {
                                                //self.nextState = .researchDetails
                                                return
                                            }
                                        }
                                        
                                        if let buttonCollect = researchCard.buttonCollect {
                                            if(buttonCollect.containsPoint(touch.locationInNode(researchCard))) {
                                                researchCard.research.collect()
                                                self.playerDataCard.updateXP()
                                                self.updateResearchs()
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
                    
                default:
                    break
                }
            }
        }
        
    }
    
}