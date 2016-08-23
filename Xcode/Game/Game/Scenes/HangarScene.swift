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
    var selectedSpaceship: Spaceship?
    var selectedCard: HangarSpaceshipCard?
    var detailsAlert: HangarSpaceshipDetails?
    var changeAlert: HangarSpaceshipChange?
    
    var hangarCardsArray:Array<HangarSpaceshipCard>!
    
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
                    
                    for hangarCard in hangarCardsArray {
                        if hangarCard.buttonUpgrade.containsPoint(touch.locationInNode(hangarCard)){
                            self.selectedSpaceship = hangarCard.spaceship
                            self.selectedCard = hangarCard
                            self.nextState = .details
                        }
                        
                        if hangarCard.buttonChange.containsPoint(touch.locationInNode(hangarCard)){
                            self.selectedSpaceship = hangarCard.spaceship
                            self.selectedCard = hangarCard
                            self.nextState = .change
                        }
                    }

                    
                    break
                    
                case .details:
                    
                    if let alert = self.detailsAlert {
                        if alert.buttonUpgrade.containsPoint(touch.locationInNode(alert)) {
                            let upgradeCost = GameMath.spaceshipUpgradeCost(level: self.selectedSpaceship!.level, type: self.selectedSpaceship!.type)
                            
                            if self.playerData.points.integerValue > upgradeCost {
                                self.playerData.points = self.playerData.points.integerValue - upgradeCost
                                self.selectedSpaceship!.upgrade()
                                self.selectedCard?.reloadCard()
                                self.playerDataCard.updatePoints()
                                alert.reload()
                                
                            } else {
                                
                                let alertBox = AlertBox(title: "Price", text: "No enough bucks bro. 😢😢", type: AlertBox.messageType.OK)
                                alertBox.buttonOK.addHandler({ self.nextState = .hangar
                                })
                                self.addChild(alertBox)
                                
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
                    
                default:
                    break
                }
            }
        }
        
    }
    
}