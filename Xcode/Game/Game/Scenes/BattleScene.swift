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
    var lastBotUpdate:Double = 0
    var botUpdateInterval:Double = 10//TODO: deve ser calculado para equilibrar o flow
    
    var battleEndTime: Double = 0 //TODO: Essa variavel ta com nome ruinzinho em Pablo
    var battleBeginInterval: NSTimeInterval = 0
    var battleEndInterval: NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        Metrics.battlesPlayed += 1
        
        self.botUpdateInterval = self.playerData.botUpdateInterval.doubleValue
        
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
        self.botMothership = Mothership(level: self.mothership.level)
        self.botMothership.zRotation = CGFloat(M_PI)
        self.botMothership.position = CGPoint(x: 0, y: 330)
        self.gameWorld.addChild(self.botMothership)
        
        // BotSpaceships
        for _ in 0 ..< 4 {
            self.botMothership.spaceships.append(Spaceship(type: Int.random(Spaceship.types.count), level: GameMath.spaceshipBotSpaceshipLevel(), loadPhysics: true))
        }
        
        //TODO: remover gamb
        for botSpaceship in self.botMothership.spaceships {
            
            let weaponTypeIndex = Int.random(Weapon.types.count)
            var weaponLevel = botSpaceship.level
            if weaponLevel <= 0 { weaponLevel = 1 }
            botSpaceship.weapon = Weapon(type: weaponTypeIndex, level: weaponLevel)
            botSpaceship.addChild(botSpaceship.weapon!)
        }
        //
        
        //Spaceships
        
        self.mothership.health = GameMath.mothershipMaxHealth(self.mothership, enemyMothership: self.botMothership)
        self.mothership.maxHealth = self.mothership.health
        
        self.mothership.loadHealthBar(self.gameWorld, borderColor: SKColor.blueColor())
        self.mothership.healthBar.update(position: self.mothership.position)
        
        self.botMothership.health = self.mothership.health
        self.botMothership.maxHealth = self.mothership.health
        
        self.botMothership.loadHealthBar(self.gameWorld, borderColor: SKColor.redColor())
        self.botMothership.healthBar.barPosition = .down
        self.botMothership.healthBar.update(position: self.botMothership.position)
        
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
                
                var enemyHealth = 0
                for botSpaceship in self.botMothership.spaceships {
                    enemyHealth += botSpaceship.health
                }
                if enemyHealth <= 0 {
                    self.botMothership.health = self.botMothership.health - Int(1 + Int(self.botMothership.level / 10))
                    self.botMothership.healthBar.update(self.botMothership.health, maxHealth: self.botMothership.maxHealth)
                    if self.botMothership.health <= 0 {
                        self.botMothership.die()
                        self.nextState = .battleEnd
                    }
                }
                
                var myHealth = 0
                for spaceship in self.mothership.spaceships {
                    myHealth += spaceship.health
                }
                if myHealth <= 0 {
                    self.mothership.health = self.mothership.health - Int(1 + Int(self.mothership.level / 10))
                    self.mothership.healthBar.update(self.mothership.health, maxHealth: self.mothership.maxHealth)
                    if self.mothership.health <= 0 {
                        self.mothership.die()
                        self.nextState = .battleEnd
                    }
                }
                
                self.mothership.update(enemyMothership: self.botMothership, enemySpaceships: self.botMothership.spaceships)
                self.botMothership.update(enemyMothership: self.mothership, enemySpaceships: self.mothership.spaceships)
                
                if self.mothership.health <= 0 ||
                    self.botMothership.health <= 0
                {
                    self.nextState = states.battleEnd
                }
                
                
                
                if currentTime - self.lastBotUpdate > self.botUpdateInterval {
                    self.lastBotUpdate = currentTime
                    
                    var aliveBotSpaceships = [Spaceship]()
                    
                    for botSpaceship in self.botMothership.spaceships {
                        if botSpaceship.health > 0 {
                            aliveBotSpaceships.append(botSpaceship)
                        }
                    }
                    
                    if aliveBotSpaceships.count > 0 {
                        
                        let botSpaceship = aliveBotSpaceships[Int.random(aliveBotSpaceships.count)]
                        
                        if botSpaceship.isInsideAMothership {
                            if botSpaceship.health == botSpaceship.maxHealth {
                                botSpaceship.destination = CGPoint(x: botSpaceship.startingPosition.x,
                                                                   y: botSpaceship.startingPosition.y - 150)
                                botSpaceship.needToMove = true
                                botSpaceship.physicsBody?.dynamic = true
                            }
                        } else {
                            
                            if botSpaceship.health <= botSpaceship.maxHealth/10 {
                                botSpaceship.retreat()
                            } else {
                                botSpaceship.targetNode = botSpaceship.nearestTarget(enemyMothership: self.mothership, enemySpaceships: self.mothership.spaceships)
                                
                                if let _ = botSpaceship.targetNode {
                                    botSpaceship.needToMove = false
                                } else {
                                    botSpaceship.destination = CGPoint(x: botSpaceship.position.x,
                                                                       y: botSpaceship.position.y - 100)
                                    botSpaceship.needToMove = true
                                }
                            }
                        }
                    }
                }
                
                break
                
            case .battleEndInterval:
                self.mothership.update()
                self.botMothership.update()
                
                if currentTime - battleEndTime >= 2 {
                    self.nextState = states.showBattleResult
                }
                break
                
            case .showBattleResult:
                self.mothership.update()
                self.botMothership.update()
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
                self.battleBeginInterval = currentTime
                break
            case .battleEnd:
                self.battleEndInterval = currentTime - self.battleBeginInterval
                Metrics.battleTime(self.battleEndInterval)
                
                self.mothership.endBattle()
                self.botMothership.endBattle()
                
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
                        
                        #if os(iOS)
                            Metrics.win()
                        #endif
                        
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Win! 😃 xp += " + battleXP.description, type: AlertBox.messageType.OK)
                        alertBox.buttonOK.addHandler({
                            if self.botUpdateInterval > 0 {
                                self.playerData.botUpdateInterval = NSNumber(double: self.botUpdateInterval - 1)
                            }
                            self.nextState = states.mothership
                        })
                        self.addChild(alertBox)
                    } else {
                        
                        #if os(iOS)
                            Metrics.loose()
                        #endif
                        
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Lose. 😱 xp += " + battleXP.description, type: AlertBox.messageType.OK)
                        alertBox.buttonOK.addHandler({
                            self.playerData.botUpdateInterval = NSNumber(double: self.botUpdateInterval + 1)
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
                        if spaceship.health > 0 {
                            if let parent = spaceship.parent {
                                if spaceship.containsPoint(touch.locationInNode(parent)) {
                                    spaceship.touchEnded()
                                    return
                                }
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
                            Spaceship.retreatSelectedSpaceship()
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
                        if spaceship.health > 0 {
                            if let parent = spaceship.parent {
                                if spaceship.containsPoint(touch.locationInNode(parent)) {
                                    spaceship.touchEnded()
                                    return
                                }
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
                            Spaceship.retreatSelectedSpaceship()
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
