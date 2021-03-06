//
//  HangarScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
   
    let playerData = MemoryCard.sharedInstance.playerData
    
    var spaceships = [Spaceship]()
    var selectedSpaceship: Spaceship?
    var selectedCard: HangarSpaceshipCard?
    var detailsAlert: HangarSpaceshipDetails?
    var changeAlert: HangarSpaceshipChange?
    
    var hangarSpaceshipCards:[HangarSpaceshipCard]!
    
    enum states : String {
        
        //Estado de alertBox
        case alert
        
        case research
        case mission
        case mothership
        case factory
        case hangar
        
        case details
        case change
    }
    
    //Estados iniciais
    var state = states.hangar
    var nextState = states.hangar
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    var headerControl:Control!
    
    var gameStore: GameStore?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 1.0
        
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
        
         Music.sharedInstance.playMusicWithType(Music.musicTypes.menu)
        
        self.headerControl = Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 246/255, green: 251/255, blue: 255/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
                                      y: 67, size: CGSize(width: self.size.width,
                                        height: 56))
        self.addChild(self.headerControl)
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 123, size: CGSize(width: self.size.width,
                height: 3)))
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "SELECT SPACESHIPS", fontSize: 14, x: 160, y: 101, xAlign: .center, yAlign: .up, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
       
        self.hangarSpaceshipCards = [HangarSpaceshipCard]()
        
        var index = 0
        for item in self.playerData.motherShip.spaceships  {
                    
            if let spaceshipData = item as? SpaceshipData {
                
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
                
                let hangarSpaceshipCard = HangarSpaceshipCard(spaceshipData: spaceshipData, x: x, y: y)
                self.addChild(hangarSpaceshipCard)
                
                self.hangarSpaceshipCards.append(hangarSpaceshipCard)
                index += 1
            }
        }
        
        switch GameTabBar.lastState {
        case .research, .mission, .mothership, .factory:
            for node in self.children {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.runAction(SKAction.actionWithEffect(SKTMoveEffect(node: node, duration: actionDuration, startPosition: node.position, endPosition: nodePosition)))
            }
            break
        case .hangar:
            break
        }
        
        self.runAction({ let a = SKAction(); a.duration = actionDuration/4; return a }(), completion: {
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
                
            case .hangar:
                self.playerDataCard.update()
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
                self.gameStore?.removeFromParent()
                self.changeAlert?.removeFromParent()
                self.detailsAlert?.removeFromParent()
                break
                
            case .details:
                if let spaceship = self.selectedSpaceship {
                    self.blackSpriteNode.hidden = false
                    self.blackSpriteNode.zPosition = 10000
                    self.detailsAlert = HangarSpaceshipDetails(spaceship: spaceship)
                    self.detailsAlert!.zPosition = self.blackSpriteNode.zPosition + 1
                  
                    self.detailsAlert!.buttonCancel.addHandler({ self.nextState = .hangar
                    })
                    self.addChild(self.detailsAlert!)
                } else {
                    #if DEBUG
                        fatalError()
                    #endif
                }
                
            case .change:
                if let spaceship = self.selectedSpaceship {
                    self.blackSpriteNode.hidden = false
                    self.blackSpriteNode.zPosition = 10000
                    self.changeAlert = HangarSpaceshipChange(spaceship: spaceship)
                    self.changeAlert!.zPosition = self.blackSpriteNode.zPosition + 1
                    
                    self.changeAlert!.buttonCancel.addHandler({ self.nextState = .hangar
                    })
                    self.addChild(self.changeAlert!)
                } else {
                    #if DEBUG
                        fatalError()
                    #endif
                }
                
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
                case .hangar:
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
                let point = touch.locationInNode(self)
                switch (self.state) {
                case .hangar:
                    
                    if self.playerDataCard.statistics.isOpen {
                        return
                    }
                    
                    if self.headerControl.containsPoint(point) {
                        return
                    }
                    
                    if self.playerDataCard.containsPoint(point) {
                        return
                    }
                    
                    if self.gameTabBar.containsPoint(point) {
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
                        return
                    }
                    
                    for hangarSpaceshipCard in self.hangarSpaceshipCards {
                        if hangarSpaceshipCard.buttonUpgrade.containsPoint(touch.locationInNode(hangarSpaceshipCard)){
                            self.selectedSpaceship = hangarSpaceshipCard.spaceship
                            self.selectedCard = hangarSpaceshipCard
                            self.nextState = .details
                            return
                        }
                        
                        if hangarSpaceshipCard.buttonChange.containsPoint(touch.locationInNode(hangarSpaceshipCard)){
                            self.selectedSpaceship = hangarSpaceshipCard.spaceship
                            self.selectedCard = hangarSpaceshipCard
                            self.nextState = .change
                        }
                    }
                    
                    break
                    
                case .details:
                    
                    if let alert = self.detailsAlert {
                        
                        if let buttonUpgrade = alert.buttonUpgrade {
                            
                            if buttonUpgrade.containsPoint(touch.locationInNode(alert)) {
                                let upgradeCost = GameMath.spaceshipUpgradeCost(level: self.selectedSpaceship!.level, type: self.selectedSpaceship!.type)
                                
                                if self.playerData.points.integerValue > upgradeCost {
                                    self.playerData.points = self.playerData.points.integerValue - upgradeCost
                                    self.selectedSpaceship!.upgrade()
                                    self.selectedCard?.reloadCard()
                                    self.playerDataCard.updatePoints()
                                    alert.reload()
                                    
                                } else {
                                    
                                    let alertBox = AlertBox(title: "Price", text: "No enough bucks bro.".translation() + " 😢😢", buttonText: "BUY MORE", needCancelButton: true)
                                    
                                    Control.gameScene.setAlertState()
                                    
                                    alertBox.buttonCancel!.addHandler({ self.nextState = .hangar
                                    })
                                    
                                    alertBox.buttonOK.addHandler({ self.nextState = .hangar
                                        self.gameStore = GameStore()
                                        self.addChild(self.gameStore!)
                                    })
                                    
                                    self.addChild(alertBox)
                                    
                                }
                            }
                        }
                    }
                    
                    break
                    
                    
                case .change:
                    
                    if let alert = self.changeAlert {
                        if let scrollNode = alert.scrollNode{
                            
                            if let buttonChoose = alert.buttonChoose {
                                if buttonChoose.containsPoint(touch.locationInNode(alert)){
                                    alert.choose()
                                    self.selectedCard?.spaceship.removeFromParent()
                                    self.selectedCard?.spaceship = alert.selectedCell?.spaceship
                                    self.selectedCard?.reloadCard()
                                    self.nextState = .hangar
                                    return
                                }
                            }
                            
                            if scrollNode.containsPoint(touch.locationInNode(alert.cropBox.cropNode)){
                                for item in scrollNode.cells {
                                    if (item.containsPoint(touch.locationInNode(scrollNode))) {
                                        if let cell = item as? HangarSpaceshipsCell {
                                            if ((cell.position.y < 40.0) && (cell.position.y > -220.0)) {
                                                for subItem in cell.spaceshipsSubCells {
                                                    if subItem.containsPoint(touch.locationInNode(item)){
                                                        alert.selectSpaceship(subItem)
                                                        return
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            
                        } else {
                            if let buttonFactory = alert.buttonFactory {
                                if buttonFactory.containsPoint(touch.locationInNode(alert)){
                                    self.nextState = .factory
                                }
                            }
                        }
                    }
                    
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