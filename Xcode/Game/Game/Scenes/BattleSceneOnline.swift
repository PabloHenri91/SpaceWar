//
//  BattleSceneOnline.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/7/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit
import AudioToolbox

extension BattleScene {
    
    func setHandlers() {
        
        let serverManager = ServerManager.sharedInstance
        
        serverManager.socket?.onAny({ [weak self] (socketAnyEvent: SocketAnyEvent) in
            
            guard let scene = self else { return }
            
            switch(socketAnyEvent.event) {
                
            case "addPlayer":
                serverManager.addPlayer(socketAnyEvent)
                
                break
                
            case "noPlayersOnline":
                scene.loadBots()
                scene.nextState = .battle
                break
                
            case "roomInfo":
                let room = Room(socketAnyEvent: socketAnyEvent)
                if room.roomId == serverManager.userDisplayInfo.socketId {
                    
                } else {
                    serverManager.joinRoom(room)
                    scene.nextState = .syncGameData
                }
                break
                
            case "mySocketId":
                if let mySocketId = socketAnyEvent.items?.first as? String {
                    serverManager.userDisplayInfo.socketId = mySocketId
                } else {
                    
                }
                
            case "connect":
                serverManager.socket?.emit(serverManager.userDisplayInfo)
                //TODO: voltar para a sala caso estivesse em alguma
                break
                
            case "noRoomsAvailable":
                scene.nextState = .createRoom
                break
                
            case "update":
                scene.updateOnline(socketAnyEvent)
                break
                
            case "someData":
                if let message = socketAnyEvent.items?.first as? [Any] {
                    var i = message.makeIterator()
                    
                    switch (i.next() as! String) {
                        
                    case "mothership":
                        
                        if BattleScene.state != .battleOnline {
                            
                            if scene.botMothership == nil {
                                
                                scene.botMothership = Mothership(socketAnyEvent: socketAnyEvent)
                                
                                if let room = serverManager.room {
                                    for userDisplayInfo in room.usersDisplayInfo {
                                        if userDisplayInfo.displayName != serverManager.userDisplayInfo.displayName {
                                            scene.botMothership.displayName = userDisplayInfo.displayName
                                            break
                                        }
                                    }
                                }
                                
                                scene.botMothership.zRotation = CGFloat(M_PI)
                                scene.botMothership.position = CGPoint(x: 0, y: 243)
                                scene.gameWorld.addChild(scene.botMothership)
                                
                                scene.mothership.health = GameMath.mothershipMaxHealth(scene.mothership, enemyMothership: scene.botMothership)
                                scene.mothership.maxHealth = scene.mothership.health
                                
                                scene.botMothership.health = scene.mothership.health
                                scene.botMothership.maxHealth = scene.mothership.health
                                scene.botMothership.loadHealthBar(blueTeam: false)
                                
                                scene.botMothership.loadSpaceships(scene.gameWorld, isAlly: false)
                                
                                scene.updateSpaceshipLevels()
                            }
                            
                            scene.nextState = .battleOnline
                            
                            serverManager.socket?.emit(scene.mothership)
                        }
                        
                        break
                        
                    default:
                        print(BattleScene.state)
                        print(socketAnyEvent.description)
                        break
                    }
                    
                }
                break
                
            case "removePlayer":
                if scene.botMothership == nil {
                    scene.loadBots()
                    scene.nextState = .battle
                }
                
                if BattleScene.state == .battleOnline {
                    scene.nextState = .battle
                    BattleScene.state = .battle
                }
                
                serverManager.leaveAllRooms()
                
                break
                
            default:
                print(BattleScene.state)
                print(socketAnyEvent.description)
                break
            }
        })
        
    }
    
    func updateOnline(_ socketAnyEvent: SocketAnyEvent) {
        
        if let items = socketAnyEvent.items?.first as? [Any] {
            var i = items.makeIterator()
            
            if let i = i.next() as? Int {
                if self.mothership.health > 0 && self.mothership.health - i <= 0 {
                    self.mothership.die()
                } else {
                    self.mothership.health = self.mothership.health - i
                }
                
                if self.mothership.health > 0 {
                    self.mothership.updateHealthBarValue()
                }
            } else { return }
            
            for spaceship in self.mothership.spaceships {
                if let i = i.next() as? Int {
                    if spaceship.health > 0 && spaceship.health - i <= 0 {
                        spaceship.die()
                    } else {
                        spaceship.health = spaceship.health - i
                    }
                    
                    if spaceship.health > 0 {
                        spaceship.updateHealthBarValue()
                    }
                } else { return }
            }
            
            if self.botMothership != nil {
                for spaceship in self.botMothership.spaceships {
                    
                    spaceship.health = spaceship.health + (i.next() as! Int)
                    
                    spaceship.needToMove = i.next() as! Bool
                    
                    spaceship.isInsideAMothership = i.next() as! Bool
                        
                    spaceship.destination = CGPoint(x: CGFloat(i.next() as! Int) / 1000000, y: CGFloat(i.next() as! Int) / 1000000)
                    
                    let position = CGPoint(x: CGFloat(i.next() as! Int) / 1000000, y: CGFloat(i.next() as! Int) / 1000000)
                    
                    if CGPoint.distanceSquared(spaceship.position, position) > 256 {
                        spaceship.position = position
                    } else {
                        spaceship.position.x = (spaceship.position.x + position.x)/2
                        spaceship.position.y = (spaceship.position.y + position.y)/2
                    }
                    
                    let level = i.next() as! Int
                    
                    if spaceship.level < level {
                        spaceship.upgradeOnBattle()
                    }
                    
                    if i.next() as! Bool {
                        if let physicsBody = spaceship.physicsBody {
                            physicsBody.velocity.dx = CGFloat(i.next() as! Int) / 1000000 //0
                            physicsBody.velocity.dy = CGFloat(i.next() as! Int) / 1000000 //1
                            physicsBody.angularVelocity = CGFloat(i.next() as! Int) / 1000000 //2
                            
                            physicsBody.categoryBitMask = UInt32(i.next() as! Int) //3
                            physicsBody.collisionBitMask = UInt32(i.next() as! Int)  //4
                            physicsBody.contactTestBitMask = UInt32(i.next() as! Int) //5
                            physicsBody.isDynamic = (i.next() as! Bool) //6
                        } else {
                            for _ in 0..<7 {
                                i.next()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateOnline() {
        
        if self.botMothership == nil {
            return
        }
        
        if self.serverManager.room == nil {
            return
        }
        
        if GameScene.currentTime - self.lastOnlineUpdate > self.emitInterval {
            self.lastOnlineUpdate = GameScene.currentTime
            
            var items = [Any]()
            
            if self.botMothership.onlineDamage == 0 {
                items.append(false as AnyObject)
            } else {
                items.append(self.botMothership.onlineDamage as AnyObject)
            }
            self.botMothership.onlineDamage = 0
            
            for spaceship in self.botMothership.spaceships {
                if spaceship.onlineDamage == 0 {
                    items.append(false as AnyObject)
                } else {
                    items.append(spaceship.onlineDamage as AnyObject)
                }
                spaceship.onlineDamage = 0
            }
            
            for spaceship in self.mothership.spaceships {
                
                if spaceship.onlineHeal == 0 {
                    items.append(false as AnyObject)
                } else {
                    items.append(spaceship.onlineHeal as AnyObject)
                }
                spaceship.onlineHeal = 0
                
                items.append(spaceship.needToMove as AnyObject)
                items.append(spaceship.isInsideAMothership as AnyObject)
                
                items.append(Int(-spaceship.destination.x * 1000000) as AnyObject)
                items.append(Int(-spaceship.destination.y * 1000000) as AnyObject)
                    
                items.append(Int(-spaceship.position.x * 1000000) as AnyObject)
                items.append(Int(-spaceship.position.y * 1000000) as AnyObject)
                
                items.append(spaceship.level as AnyObject)
                
                if let physicsBody = spaceship.physicsBody {
                    items.append(true as AnyObject)
                    
                    items.append(Int(-physicsBody.velocity.dx * 1000000) as AnyObject)
                    items.append(Int(-physicsBody.velocity.dy * 1000000) as AnyObject)
                    items.append(Int(physicsBody.angularVelocity * 1000000) as AnyObject)
                    
                    items.append(Int(physicsBody.categoryBitMask) as AnyObject)
                    items.append(Int(physicsBody.collisionBitMask) as AnyObject)
                    items.append(Int(physicsBody.contactTestBitMask) as AnyObject)
                    items.append(physicsBody.isDynamic)
                } else {
                    items.append(false as AnyObject)
                }
            }
            
            self.serverManager.socket?.emit("update", items)
        }
        
        if BattleScene.state == .battleOnline {
            if self.mothership.health <= 0 || self.botMothership.health <= 0 {
                self.nextState = .battle
                self.serverManager.leaveAllRooms()
            }
        }
    }
    
    func updateSpaceshipLevels() {
        var maxLevel = Int.max
        for spaceship in self.botMothership.spaceships + self.mothership.spaceships {
            if spaceship.level < maxLevel {
                maxLevel = spaceship.level
            }
        }
        
        //No maximo 2 leveis a mais
        maxLevel = maxLevel + 2
        
        for spaceship in self.botMothership.spaceships + self.mothership.spaceships {
            spaceship.setBattleLevel(level: min(maxLevel, spaceship.battleMaxLevel))
        }
    }
    
    func showPlayerNames(playAlertSound: Bool) {
        
        if playAlertSound {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        
        var labelText = ""
                
        labelText += self.botMothership.displayName
        labelText += " x "
        labelText += self.mothership.displayName
        
        let label = MultiLineLabel(text: labelText, maxWidth: 10, color: SKColor.white, fontSize: 32)
        
        self.gameWorld.addChild(label)
        
        label.run({ let a = SKAction(); a.duration = 3; return a }(), completion: { [weak label] in
            label?.run(SKAction.fadeAlpha(to: 0, duration: 1), completion: {
                label?.removeFromParent()
            })
            })
    }
}
