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
    
    var scrollNode:ScrollNode!
    
    enum states : String {
        
        //Estado de alertBox
        case alert
        
        case research
        case mission
        case mothership
        case factory
        case hangar
        
        case buySpaceship
    }
    
    //Estados iniciais
    var state = states.factory
    var nextState = states.factory
    
    var playerDataCard:PlayerDataCard!
    var gameTabBar:GameTabBar!
    
    var headerControl:Control!
    
    var buySpaceshipAlert:BuySpaceshipAlert?
    
    var gameStore: GameStore?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let actionDuration = 0.25
        
        switch GameTabBar.lastState {
        case .research, .mission, .mothership:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x - Display.currentSceneSize.width, y: nodePosition.y)
                node.moveToParent(self)
            }
            break
        case .factory:
            break
        case .hangar:
            for node in GameScene.lastChildren {
                let nodePosition = node.position
                node.position = CGPoint(x: nodePosition.x + Display.currentSceneSize.width, y: nodePosition.y)
                node.moveToParent(self)
            }
            break
        }
        
        Music.sharedInstance.playMusicWithType(Music.musicTypes.menu)
        
        var cells = [FactorySpaceshipCard]()
        
        for item in self.playerData.unlockedSpaceships {
            if let spaceshipData = item as? SpaceshipData {
                let spaceship = Spaceship(type: spaceshipData.type.integerValue, level: 1)
                if let weaponData = spaceshipData.weapons.anyObject() as? WeaponData {
                    let weapon = Weapon(type: weaponData.type.integerValue, level: 1)
                    spaceship.addWeapon(weapon)
                }
                if let factorySpaceshipCard = FactorySpaceshipCard(spaceship: spaceship) {
                    cells.append(factorySpaceshipCard)
                }
            }
        }
    
        self.scrollNode = ScrollNode(cells: cells, x: 17, y: 143, xAlign: .center, yAlign: .up, spacing: 10 , scrollDirection: .vertical)
        self.scrollNode.zPosition = -50
        self.addChild(self.scrollNode)
        self.scrollNode.canScroll = self.scrollNode.cells.count > 2
        
        
        self.headerControl = Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 246/255, green: 251/255, blue: 255/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
                                      y: 67, size: CGSize(width: self.size.width,
                                        height: 56))
        self.addChild(self.headerControl)
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 12/100), size: CGSize(width: 1, height: 1)),
            y: 123, size: CGSize(width: self.size.width,
                height: 3)))
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "FACTORY", fontSize: 14, x: 160, y: 101, xAlign: .center, yAlign: .up, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        
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
    
    override func setAlertState() {
        self.nextState = .alert
    }
    
    override func setDefaultState() {
        self.nextState = .factory
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
                
            case .factory:
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
                self.blackSpriteNode.hidden = true
                self.gameStore?.removeFromParent()
                self.scrollNode.canScroll = self.scrollNode.cells.count > 2
                self.buySpaceshipAlert?.removeFromParent()
                break
                
            case .hangar:
                self.playerDataCard.removeFromParent()
                self.gameTabBar.removeFromParent()
                GameScene.lastChildren = self.children
                
                self.view?.presentScene(HangarScene())
                break
                
            case .buySpaceship:
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = 10000
                
                self.buySpaceshipAlert?.zPosition = self.blackSpriteNode.zPosition + 1
                self.scrollNode.canScroll = false
                self.buySpaceshipAlert?.buttonCancel.addHandler({
                    self.nextState = .factory
                })
                self.addChild(self.buySpaceshipAlert!)
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
                case .factory:
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
                case .factory:
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
                    
                case .buySpaceship:
                    if let buySpaceshipAlert = self.buySpaceshipAlert {
                        if buySpaceshipAlert.buttonBuy.containsPoint(touch.locationInNode(buySpaceshipAlert)){
                            buySpaceshipAlert.buySpaceship()
                            self.playerDataCard.updatePoints()
                            self.nextState = .factory
                        }
                    }
                    
                    break
                    
                case .factory:
                    
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
                        
                        if(self.gameTabBar.buttonHangar.containsPoint(touch.locationInNode(self.gameTabBar))) {
                            self.nextState = states.hangar
                            return
                        }
                        return
                    }
                    
                    if self.scrollNode.containsPoint(point) {
                        
                        for cell in self.scrollNode.cells {
                            
                            if cell.containsPoint(touch.locationInNode(self.scrollNode)) {
                                
                                if let factorySpaceshipCard = cell as? FactorySpaceshipCard {
                                    
                                    if factorySpaceshipCard.buttonBuy.containsPoint(touch.locationInNode(factorySpaceshipCard)) {
                                        
                                        if self.playerData.points.integerValue > GameMath.spaceshipPrice(factorySpaceshipCard.spaceship.type) {
                                            
                                            self.buySpaceshipAlert = BuySpaceshipAlert(spaceship: factorySpaceshipCard.spaceship, count: factorySpaceshipCard.typeCount)
                                            self.buySpaceshipAlert?.buttonBuy.addHandler({
                                                factorySpaceshipCard.updateLabelTypeCount()
                                            })
                                            self.nextState = .buySpaceship
                                            
                                        } else {
                                            
                                            let alertBox = AlertBox(title: "Alert!", text: "Insuficient funds.", type: .OK)
                                            self.addChild(alertBox)
                                            alertBox.buttonOK.addHandler {
                                                self.nextState = .factory
                                            }
                                            self.nextState = .alert
                                        }
                                    }
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