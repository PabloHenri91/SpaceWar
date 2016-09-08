//
//  BattleSceneOnline.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/7/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

extension BattleScene {
    
    func setHandlers() {
        
        let serverManager = ServerManager.sharedInstance
        
        serverManager.socket?.onAny({ [weak self] (socketAnyEvent: SocketAnyEvent) in
            
            guard let scene = self else { return }
            
            switch(socketAnyEvent.event) {
                
            case "roomInfo":
                if let roomId = socketAnyEvent.items?.firstObject as? String {
                    
                }
                print(socketAnyEvent.description)
                break
                
            case "mySocketId":
                if let mySocketId = socketAnyEvent.items?.firstObject as? String {
                    serverManager.userDisplayInfo.socketId = mySocketId
                } else {
                    fatalError()
                }
                
            case "connect":
                serverManager.socket?.emit(serverManager.userDisplayInfo)
                //TODO: voltar para a sala caso estivesse em alguma
                break
                
            case "noRoomsAvailable":
                scene.nextState = .createRoom
                break
                
            case "someData":
                if let message = socketAnyEvent.items?.firstObject as? [AnyObject] {
                    var i = message.generate()
                    
                    switch (i.next() as! String) {
                        
                    case "mothership":
                        
                        if scene.state != .battleOnline {
                            
                            scene.botMothership = Mothership(socketAnyEvent: socketAnyEvent)
                            
                            scene.botMothership.zRotation = CGFloat(M_PI)
                            scene.botMothership.position = CGPoint(x: 0, y: 243)
                            scene.gameWorld.addChild(scene.botMothership)
                            
                            scene.mothership.health = GameMath.mothershipMaxHealth(scene.mothership, enemyMothership: scene.botMothership)
                            scene.mothership.maxHealth = scene.mothership.health
                            
                            scene.botMothership.health = scene.mothership.health
                            scene.botMothership.maxHealth = scene.mothership.health
                            scene.botMothership.loadHealthBar(blueTeam: false)
                            
                            scene.botMothership.loadSpaceships(scene.gameWorld, isAlly: false)
                            
                            scene.nextState = .battleOnline
                            
                            serverManager.socket?.emit(scene.mothership)
                        }
                        
                        break
                        
                    default:
                        break
                    }
                    
                }
                break
                
            default:
                print(socketAnyEvent.description)
                break
            }
        })
        
    }
}


class Room {
    
    var roomId = ""
    
    var usersDisplayInfo = [UserDisplayInfo]()
    
    init(socketAnyEvent: SocketAnyEvent) {
        if let message = socketAnyEvent.items?.firstObject as? [String : AnyObject] {
            if let roomId = message["roomId"] as? String {
                
                self.roomId = roomId
                
                if let rawUsersDisplayInfo = message["usersDisplayInfo"] as? [[String]] {
                    
                    for var rawUserDisplayInfo in rawUsersDisplayInfo {
                        self.usersDisplayInfo.append(UserDisplayInfo(socketId: rawUserDisplayInfo[0], displayName: rawUserDisplayInfo[1]))
                    }
                }
            }
        }
    }
}
