//
//  BattleScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/24/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleScene: GameScene {
    
    enum states : String {
        //Estado principal
        case battle
        
        case loading
        case countdown
        case battleEnd
        case battleEndInterval
        case showBattleResult
        
        //Estados de saida da scene
        case mothership
    }
    
    //Estados iniciais
    var state = states.loading
    var nextState = states.loading
    
    let playerData = MemoryCard.sharedInstance.playerData
    
    var gameWorld:GameWorld!
    var gameCamera:GameCamera!
    var mothership:Mothership!
    
    var botMothership:Mothership!
    
    var battleEndTime: Double = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // GameWorld
        self.gameWorld = GameWorld(physicsWorld: self.physicsWorld)
        self.gameWorld.setScreenBox(Display.defaultSceneSize)
        self.addChild(self.gameWorld)
        self.physicsWorld.contactDelegate = self.gameWorld
        
        
        // GameCamera
        self.gameCamera = GameCamera()
        self.gameWorld.addChild(self.gameCamera)
        self.gameWorld.addChild(self.gameCamera.node)
        self.gameCamera.node.position = CGPoint.zero
        self.gameCamera.update()
        
        // Mothership
        self.mothership = Mothership(mothershipData: self.playerData.motherShip)
        self.gameWorld.addChild(self.mothership)
        self.mothership.position = CGPoint(x: 0, y: -330)
        
        // BotMothership
        self.botMothership = Mothership(level: 1)
        self.botMothership.zRotation = CGFloat(M_PI)
        self.botMothership.position = CGPoint(x: 0, y: 330)
        self.gameWorld.addChild(self.botMothership)
        
        // BotSpaceships
        for _ in 0 ..< 4 {
            self.botMothership.spaceships.append(Spaceship(type: Int.random(Spaceship.types.count), level: 1))
        }
        
        //TODO: remover gamb
        for botSpaceship in self.botMothership.spaceships {
            
            let weaponTypeIndex = Int.random(Weapon.types.count)
            var weaponLevel = Int.random(Weapon.types[weaponTypeIndex].maxLevel)
            if weaponLevel <= 0 { weaponLevel = 1 }
            botSpaceship.weapon = Weapon(type: weaponTypeIndex, level: weaponLevel)
            botSpaceship.addChild(botSpaceship.weapon!)
            
            botSpaceship.runAction( { let a = SKAction(); a.duration = Double(1 + Int.random(30)); return a }(), completion:
                { [weak botSpaceship] in
                    
                    guard let someBotSpaceship = botSpaceship else { return }
                    
                    someBotSpaceship.destination = CGPoint.zero
                    someBotSpaceship.needToMove = true
                    someBotSpaceship.physicsBody?.dynamic = true
                })
        }
        //
        
        //Spaceships
        
        self.mothership.loadHealthBar(self.gameWorld, borderColor: SKColor.blueColor())
        self.mothership.healthBar.updateUp(position: self.mothership.position)
        
        self.botMothership.loadHealthBar(self.gameWorld, borderColor: SKColor.redColor())
        self.botMothership.healthBar.updateDown(position: self.botMothership.position)
        
        self.mothership.loadSpaceships(self.gameWorld)
        self.botMothership.loadSpaceships(self.gameWorld, isAlly: false)
        
        self.nextState = states.battle
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
                
            case states.battle:
                
                self.mothership.update(enemyMothership: self.botMothership, enemySpaceships: self.botMothership.spaceships)
                self.botMothership.update(enemyMothership: self.mothership, enemySpaceships: self.mothership.spaceships)
                
                if self.mothership.health <= 0 ||
                    self.botMothership.health <= 0
                {
                    self.nextState = states.battleEnd
                }
                
                break
                
            case .battleEndInterval:
                if currentTime - battleEndTime >= 3 {
                    self.nextState = states.showBattleResult
                }
                break
                
            case .showBattleResult:
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case .battle:
                break
            case .battleEnd:
                self.battleEndTime = currentTime
                self.nextState = .battleEndInterval
                break
            case .battleEndInterval:
                break
            case .showBattleResult:
                
                let battleXP:Int = GameMath.battleXP(mothership: self.mothership, enemyMothership: self.botMothership)
                let battlePoints:Int = GameMath.battlePoints(mothership: self.mothership, enemyMothership: self.botMothership)
                
                self.playerData.points = NSNumber(integer: self.playerData.points.integerValue + battlePoints)
                self.playerData.motherShip.xp = NSNumber(integer: self.playerData.motherShip.xp.integerValue + battleXP)
                
                if self.botMothership.health <= 0 && self.mothership.health <= 0 {
                    let alertBox = AlertBox(title: "The Battle Ended", text: "Draw 😏 xp += " + battleXP.description, type: AlertBox.messageType.OK)
                    alertBox.buttonOK.addHandler({
                        self.nextState = states.mothership
                    })
                    self.addChild(alertBox)
                } else {
                    if self.botMothership.health <= 0 {
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Win! 😃 xp += " + battleXP.description, type: AlertBox.messageType.OK)
                        alertBox.buttonOK.addHandler({
                            self.nextState = states.mothership
                        })
                        self.addChild(alertBox)
                    } else {
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Lose. 😱 xp += " + battleXP.description, type: AlertBox.messageType.OK)
                        alertBox.buttonOK.addHandler({
                            self.nextState = states.mothership
                        })
                        self.addChild(alertBox)
                    }
                }
                
                
                
                break
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: GameScene.transition)
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
        
        Shot.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                    
                case states.battle:
                    
                    for spaceship in self.mothership.spaceships {
                        if let parent = spaceship.parent {
                            if spaceship.containsPoint(touch.locationInNode(parent)) {
                                spaceship.touchEnded()
                                return
                            }
                        }
                    }
                    
                    if let parent = self.botMothership.spriteNode.parent {
                        if self.botMothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            return
                        }
                    }
                    
                    if let parent = self.mothership.spriteNode.parent {
                        if self.mothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            Spaceship.retreat()
                            return
                        }
                    }
                    
                    Spaceship.touchEnded(touch)
                    
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>) {
        super.touchesMoved(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                    
                case states.battle:
                    
                    if let parent = self.botMothership.spriteNode.parent {
                        if self.botMothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            return
                        }
                    }
                    
                    if let parent = self.mothership.spriteNode.parent {
                        if self.mothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            return
                        }
                    }
                    
                    Spaceship.touchEnded(touch)
                    
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
            for touch in touches {
                switch (self.state) {
                    
                case states.battle:
                    
                    for spaceship in self.mothership.spaceships {
                        if let parent = spaceship.parent {
                            if spaceship.containsPoint(touch.locationInNode(parent)) {
                                spaceship.touchEnded()
                                return
                            }
                        }
                    }
                    
                    if let parent = self.botMothership.spriteNode.parent {
                        if self.botMothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            return
                        }
                    }
                    
                    if let parent = self.mothership.spriteNode.parent {
                        if self.mothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            Spaceship.retreat()
                            return
                        }
                    }
                    
                    Spaceship.touchEnded(touch)
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        
        self.gameCamera.update()
    }
}
