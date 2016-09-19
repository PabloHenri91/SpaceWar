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
        case battleOnline
        
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
        
        case syncGameData
    }
    
    //Estados iniciais
    static var state = states.loading
    var nextState = states.loading
    
    let playerData = MemoryCard.sharedInstance.playerData!
    
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
    var lastOnlineUpdate:Double = 0
    var emitInterval:TimeInterval = 1/30
    
    var joinRoomTime:Double = 0
    var waitForPlayersTime:Double = 0
    var waitForRoomTimeOut:Double = 3
    var waitForPlayersTimeOut:Double = 10
    var waitSyncGameDataTime:Double = 0
    var waitSyncGameDataTimeOut:Double = 10
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let connected = serverManager.socket?.status == SocketIOClientStatus.connected
        
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
        self.mothership.displayName = self.playerData.name
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
            botSpaceship.addWeapon(Weapon(type: Int.random(Weapon.types.count), level: botSpaceship.level, loadSoundEffects: true))
            self.botMothership.spaceships.append(botSpaceship)
        }
        
        self.botMothership.loadHealthBar(blueTeam: false)
        
        self.botMothership.loadSpaceships(self.gameWorld, isAlly: false)
        
        self.updateSpaceshipLevels()
    }
    
    func updateMothershipsHealth() {
        self.mothership.health = GameMath.mothershipMaxHealth(self.mothership, enemyMothership: self.botMothership)
        self.mothership.maxHealth = self.mothership.health
        self.mothership.updateHealthBarValue()
        
        self.botMothership.health = self.mothership.health
        self.botMothership.maxHealth = self.mothership.health
        self.botMothership.updateHealthBarValue()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if BattleScene.state == self.nextState {
            switch BattleScene.state {
                
            case .battle, .battleOnline:
                
                var enemyHealth = 0
                
                for botSpaceship in self.botMothership.spaceships {
                    enemyHealth += botSpaceship.health
                }
                
                if enemyHealth <= 0 {
                    
                    let damage = Int(1 + Int(self.botMothership.level / 10))
                    
                    if BattleScene.state == .battleOnline {
                        self.botMothership.onlineDamage = self.botMothership.onlineDamage + damage
                    }
                    
                    if self.botMothership.health > 0 && self.botMothership.health - damage <= 0 {
                        self.botMothership.die()
                    } else {
                        self.botMothership.health = self.botMothership.health - damage
                    }
                    
                    self.botMothership.updateHealthBarValue()
                }
                
                var myHealth = 0
                
                for spaceship in self.mothership.spaceships {
                    myHealth += spaceship.health
                }
                
                if myHealth <= 0 {
                    
                    let damage = Int(1 + Int(self.mothership.level / 10))
                    
                    if BattleScene.state == .battleOnline {
                       // o outro jogador me avisa caso eu receba dano
                    } else {
                        
                        if self.mothership.health > 0 && self.mothership.health - damage <= 0 {
                            self.mothership.die()
                        } else {
                            self.mothership.health = self.mothership.health - damage
                        }
                    }
                    
                    self.mothership.updateHealthBarValue()
                }
                
                self.mothership.update(enemyMothership: self.botMothership, enemySpaceships: self.botMothership.spaceships)
                self.botMothership.update(enemyMothership: self.mothership, enemySpaceships: self.mothership.spaceships)
                
                if BattleScene.state == .battle {
                    
                    if self.mothership.health <= 0 || self.botMothership.health <= 0 {
                        self.nextState = .battleEnd
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
                                    botSpaceship.physicsBody?.isDynamic = true
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
                }
                
                break
                
            case .battleEndInterval:
                self.mothership.update()
                self.botMothership.update()
                
                if currentTime - self.battleEndTime >= 2 {
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
                if currentTime - self.joinRoomTime > self.waitForRoomTimeOut {
                    self.nextState = .createRoom
                }
                break
                
            case .waitForPlayers:
                if currentTime - self.waitForPlayersTime > self.waitForPlayersTimeOut {
                    if self.botMothership == nil {
                        self.loadBots()
                    }
                    
                    self.nextState = .battle
                    self.serverManager.leaveAllRooms()
                }
                break
                
            case .syncGameData:
                if currentTime - self.waitSyncGameDataTime > self.waitSyncGameDataTimeOut {
                    if self.botMothership == nil {
                        self.loadBots()
                    }
                    
                    self.nextState = .battle
                    self.serverManager.leaveAllRooms()
                }
                break
                
            default:
                print(BattleScene.state)
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        } else {
            BattleScene.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case .battleOnline:
                if battleBeginTime == 0 {
                    self.battleBeginTime = currentTime
                }
                if self.botMothership.displayName != "" {
                    self.showPlayerNames(playAlertSound: (currentTime - self.joinRoomTime > 3))
                }
                
                break
            case .battle:
                if battleBeginTime == 0 {
                    self.battleBeginTime = currentTime
                }
                break
            case .battleEnd:
                //TODO: musica do fim da partida
                //Music.sharedInstance.stop()
                
                self.serverManager.leaveAllRooms()
                
                Metrics.battleTime(currentTime - self.battleBeginTime)
                
                self.mothership.endBattle()
                self.botMothership.endBattle()
                
                self.battleEndTime = currentTime
                self.nextState = .battleEndInterval
                break
            case .battleEndInterval:
                self.mothership.endBattle()
                self.botMothership.endBattle()
                break
            case .showBattleResult:
                
                let battleXP:Int = GameMath.battleXP(mothership: self.mothership, enemyMothership: self.botMothership)
                let battlePoints:Int = GameMath.battlePoints(mothership: self.mothership, enemyMothership: self.botMothership)
                
                self.playerData.points = (self.playerData.points.intValue + battlePoints) as NSNumber
                self.playerData.pointsSum = (self.playerData.pointsSum.intValue + battlePoints) as NSNumber
                
                self.playerData.motherShip.xp = (self.playerData.motherShip.xp.intValue + battleXP) as NSNumber
                
                if self.botMothership.health <= 0 && self.mothership.health <= 0 {
                    let alertBox = AlertBox(title: "The Battle Ended", text: "Draw.".translation() + " 😏 xp += " + battleXP.description, type: AlertBox.messageType.ok)
                    alertBox.buttonOK.addHandler({
                        self.nextState = states.mothership
                    })
                    self.addChild(alertBox)
                } else {
                    if self.botMothership.health <= 0 {
                        
                        Metrics.win()
                        
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Win! ".translation() + String.winEmoji() + " xp += " + battleXP.description, type: AlertBox.messageType.ok)
                        
                        self.playerData.botUpdateInterval = (self.botUpdateInterval - 1) as NSNumber
                        self.playerData.botLevel = (self.playerData.botLevel.intValue + 1) as NSNumber
                        self.playerData.winCount = (self.playerData.winCount.intValue + 1) as NSNumber
                        self.playerData.winningStreakCurrent = (self.playerData.winningStreakCurrent.intValue + 1) as NSNumber
                        if self.playerData.winningStreakCurrent.intValue > self.playerData.winningStreakBest.intValue {
                            self.playerData.winningStreakBest = self.playerData.winningStreakCurrent.intValue as NSNumber
                        }
                        
                        alertBox.buttonOK.addHandler({
                            self.nextState = states.unlockResearch
                        })
                        self.addChild(alertBox)
                    } else {
                        
                        Metrics.loose()
                        
                        let alertBox = AlertBox(title: "The Battle Ended", text: "You Lose. ".translation() + String.loseEmoji() + " xp += " + battleXP.description, type: AlertBox.messageType.ok)
                        alertBox.buttonOK.addHandler({
                            self.playerData.botUpdateInterval = (self.playerData.botUpdateInterval.intValue + 1) as NSNumber
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
                self.view?.presentScene(MothershipScene(), transition: SKTransition.crossFade(withDuration: 1))
                break
                
            case .research:
                GameTabBar.lastState = .research
                self.view?.presentScene(ResearchScene(), transition: SKTransition.crossFade(withDuration: 1))
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
                
            case .syncGameData:
                self.waitSyncGameDataTime = currentTime
                self.serverManager.socket?.emit(self.mothership)
                break
                
            default:
                print(BattleScene.state)
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
        
        Shot.update()
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        self.updateOnline()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(BattleScene.state == self.nextState) {
            for touch in touches {
                switch (BattleScene.state) {
                    
                case .battle, .battleOnline:
                    
                    if let nearestSpaceship = self.nearestSpaceship(self.mothership.spaceships, touch: touch) {
                        nearestSpaceship.touchEnded()
                        return
                    }
                    
                    
                    if let parent = self.botMothership.parent {
                        if self.botMothership.contains(touch.location(in: parent)) {
                            return
                        }
                    }
                    
                    if let parent = self.mothership.parent {
                        if self.mothership.contains(touch.location(in: parent)) {
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
    
    override func touchesMoved(_ touches: Set<UITouch>) {
        super.touchesMoved(touches)
        
        //Estado atual
        if(BattleScene.state == self.nextState) {
            for touch in touches {
                switch (BattleScene.state) {
                    
                case .battle, .battleOnline:
                    
                    if let parent = self.botMothership.parent {
                        if self.botMothership.contains(touch.location(in: parent)) {
                            return
                        }
                    }
                    
                    if let parent = self.mothership.parent {
                        if self.mothership.contains(touch.location(in: parent)) {
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
    
    override func touchesEnded(_ touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(BattleScene.state == self.nextState) {
            for touch in touches {
                switch (BattleScene.state) {
                    
                case .battle, .battleOnline:
                    
                    if let nearestSpaceship = self.nearestSpaceship(self.mothership.spaceships, touch: touch) {
                        if CGPoint.distanceSquared(nearestSpaceship.position, nearestSpaceship.startingPosition) >= 4 {
                            nearestSpaceship.targetNode = nil
                            nearestSpaceship.needToMove = false
                            nearestSpaceship.setBitMasksToSpaceship()
                        }
                    }
                    
                    if let parent = self.mothership.parent {
                        if self.mothership.contains(touch.location(in: parent)) {
                            if let spaceship = Spaceship.selectedSpaceship {
                                if CGPoint.distanceSquared(spaceship.position, spaceship.startingPosition) >= 4 {
                                    Spaceship.retreatSelectedSpaceship()
                                    return
                                }
                            }
                        }
                    }
                    
                    if let parent = self.botMothership.parent {
                        if self.botMothership.contains(touch.location(in: parent)) {
                            return
                        }
                    }
                    
                    if let spaceship = Spaceship.selectedSpaceship {
                        if CGPoint.distanceSquared(spaceship.position, spaceship.startingPosition) >= 4 {
                            Spaceship.touchEnded(touch)
                        }
                    }
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
    
    func nearestSpaceship(_ spaceships: [Spaceship], touch: UITouch) -> Spaceship? {
        
        var spaceshipsAtPoint = [Spaceship]()
        
        for spaceship in spaceships {
            if spaceship.health > 0 {
                if let parent = spaceship.parent {
                    if spaceship.contains(touch.location(in: parent)) {
                        spaceshipsAtPoint.append(spaceship)
                    }
                }
            }
        }
        
        var nearestSpaceship:Spaceship? = nil
        
        for spaceship in spaceshipsAtPoint {
            
            if let parent = spaceship.parent {
                
                let touchPosition = touch.location(in: parent)
                
                if nearestSpaceship != nil {
                    
                    if CGPoint.distanceSquared(touchPosition, spaceship.position) < CGPoint.distanceSquared(touchPosition, nearestSpaceship!.position) {
                        nearestSpaceship = spaceship
                    }
                } else {
                    nearestSpaceship = spaceship
                }
            }
        }
        
        return nearestSpaceship
    }
}
