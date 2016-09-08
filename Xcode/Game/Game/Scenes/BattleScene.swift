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
        case unlockResearch
        
        //Estados de saida da scene
        case mothership
        case research
        
        case joinRoom
        case createRoom
        case waitForPlayers
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
    var botLevel:Double = 1
    
    var battleEndTime: Double = 0
    var battleBeginTime: Double = 0
    
    //MultiplayerOnline
    let serverManager = ServerManager.sharedInstance
    
    var joinRoomTime:Double = 0
    var waitForPlayersTime:Double = 0
    var joinRoomTimeOut:Double = 3
    var waitForPlayersTimeOut:Double = 60
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let connected = serverManager.socket?.status == .Connected
        
        Metrics.battlesPlayed += 1
        
        self.backgroundColor = SKColor(red: 50/255, green: 61/255, blue: 74/255, alpha: 1)
        
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
        self.mothership.position = CGPoint(x: 0, y: -243)
        
        self.mothership.health = 100
        self.mothership.maxHealth = self.mothership.health
        self.mothership.loadHealthBar()
        self.mothership.loadSpaceships(self.gameWorld)
        
        if connected {
            self.nextState = .joinRoom
            
        } else {
            self.loadBots()
            self.nextState = .battle
        }
        
    }
    
    func loadBots() {
        Music.sharedInstance.playMusicWithType(Music.musicTypes.battle)
        
        self.botUpdateInterval = self.playerData.botUpdateInterval.doubleValue
        self.botLevel = self.playerData.botLevel.doubleValue
        
        if self.botUpdateInterval < 1 {
            self.botUpdateInterval = 1
        }
        
        // BotMothership
        self.botMothership = Mothership(level: self.mothership.level)
        self.botMothership.zRotation = CGFloat(M_PI)
        self.botMothership.position = CGPoint(x: 0, y: 243)
        self.gameWorld.addChild(self.botMothership)
        
        // BotSpaceships
        let botSpaceshipLevel = GameMath.spaceshipBotSpaceshipLevel()
        for _ in 0 ..< 4 {
            var level = botSpaceshipLevel + Int.random(min: -2, max: 0)
            if level < 1 {
                level = 1
            }
            let botSpaceship = Spaceship(type: Int.random(Spaceship.types.count), level: level, loadPhysics: true)
            botSpaceship.addWeapon(Weapon(type: Int.random(Weapon.types.count), level: botSpaceship.level))
            self.botMothership.spaceships.append(botSpaceship)
        }
        
        self.mothership.health = GameMath.mothershipMaxHealth(self.mothership, enemyMothership: self.botMothership)
        self.mothership.maxHealth = self.mothership.health
        self.mothership.updateHealthBarValue()
        
        self.botMothership.health = self.mothership.health
        self.botMothership.maxHealth = self.mothership.health
        self.botMothership.loadHealthBar(blueTeam: false)
        
        self.botMothership.loadSpaceships(self.gameWorld, isAlly: false)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
                
            case .battle:
                
                var enemyHealth = 0
                for botSpaceship in self.botMothership.spaceships {
                    enemyHealth += botSpaceship.health
                }
                if enemyHealth <= 0 {
                    self.botMothership.health = self.botMothership.health - Int(1 + Int(self.botMothership.level / 10))
                    self.botMothership.updateHealthBarValue()
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
                    self.mothership.updateHealthBarValue()
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
                
            case .unlockResearch:
                break
                
            case .joinRoom:
                if currentTime - self.joinRoomTime > self.joinRoomTimeOut {
                    self.nextState = .createRoom
                }
                break
                
            case .waitForPlayers:
                if currentTime - self.waitForPlayersTime > self.waitForPlayersTimeOut {
                    self.loadBots()
                    self.nextState = .battle
                }
                break
                
            default:
                print(self.state)
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
                self.battleBeginTime = currentTime
                break
            case .battleEnd:
                //TODO: musica do fim da partida
                //Music.sharedInstance.stop()
                
                Metrics.battleTime(currentTime - self.battleBeginTime)
                
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
                
                self.playerData.points = self.playerData.points.integerValue + battlePoints
                self.playerData.pointsSum = self.playerData.pointsSum.integerValue + battlePoints
                
                self.playerData.motherShip.xp = NSNumber(integer: self.playerData.motherShip.xp.integerValue + battleXP)
                
                if self.botMothership.health <= 0 && self.mothership.health <= 0 {
                    let alertBox = AlertBox(title: "The Battle Ended", text: "Draw.".translation() + " 😏 xp += " + battleXP.description, type: AlertBox.messageType.OK)
                    alertBox.buttonOK.addHandler({
                        self.nextState = states.mothership
                    })
                    self.addChild(alertBox)
                } else {
                    if self.botMothership.health <= 0 {
                        
                        Metrics.win()
                        
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Win! ".translation() + String.winEmoji() + " xp += " + battleXP.description, type: AlertBox.messageType.OK)
                        
                        self.playerData.botUpdateInterval = self.botUpdateInterval - 1
                        self.playerData.botLevel = self.playerData.botLevel.integerValue + 1
                        self.playerData.winCount = self.playerData.winCount.integerValue + 1
                        self.playerData.winningStreakCurrent = self.playerData.winningStreakCurrent.integerValue + 1
                        if self.playerData.winningStreakCurrent.integerValue > self.playerData.winningStreakBest.integerValue {
                            self.playerData.winningStreakBest = self.playerData.winningStreakCurrent.integerValue
                        }
                        
                        alertBox.buttonOK.addHandler({
                            self.nextState = states.unlockResearch
                        })
                        self.addChild(alertBox)
                    } else {
                        
                        Metrics.loose()
                        
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Lose. ".translation() + String.loseEmoji() + " xp += " + battleXP.description, type: AlertBox.messageType.OK)
                        alertBox.buttonOK.addHandler({
                            self.playerData.botUpdateInterval = self.playerData.botUpdateInterval.integerValue + 1
                            self.playerData.winningStreakCurrent = 0
                            self.nextState = states.mothership
                        })
                        self.addChild(alertBox)
                    }
                }
                
                break
                
            case .unlockResearch:
                
                let research = Research.unlockRandomResearch()
                if research != nil {
                    let researchUnlockedAlert = ResearchUnlockedAlert(researchData: research!)
                    
                    self.addChild(researchUnlockedAlert)
                    
                    researchUnlockedAlert.buttonCancel.addHandler({
                        self.nextState = states.mothership
                    })
                    
                    researchUnlockedAlert.buttonGoToResearch.addHandler({
                        self.nextState = states.research
                    })
                    
                } else {
                    self.nextState = states.mothership  
                }
                
                
                break
            
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: SKTransition.crossFadeWithDuration(1))
                break
                
            case .research:
                GameTabBar.lastState = .research
                self.view?.presentScene(ResearchScene(), transition: SKTransition.crossFadeWithDuration(1))
                break
                
            case .joinRoom:
                self.joinRoomTime = currentTime
                self.setHandlers()
                self.serverManager.getAllRooms()
                break
                
            case .createRoom:
                self.serverManager.createRoom()
                self.nextState = .waitForPlayers
                break
                
            case .waitForPlayers:
                self.waitForPlayersTime = currentTime
                break
                
            default:
                print(self.state)
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
                    
                case .battle:
                    
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
                    
                case .battle:
                    
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
                    
                case .battle:
                    
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
