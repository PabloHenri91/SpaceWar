//
//  ServerManager.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/16/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#endif

#if os(OSX)
    import Foundation
#endif

import SpriteKit
import AudioToolbox

class ServerManager {
    
    static var sharedInstance = ServerManager()
    
    let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    
    //Multiplayer Online
    var socket:SocketIOClient?
    
    var userDisplayInfo: UserDisplayInfo
    
    var room: Room?
    
    init() {
        let displayName = MemoryCard.sharedInstance.playerData.name
        self.userDisplayInfo = UserDisplayInfo(displayName: displayName)
    }
    
    func setHandlers() {
        
        let serverManager = ServerManager.sharedInstance
        
        serverManager.socket?.removeAllHandlers()
        
        serverManager.socket?.onAny({ (socketAnyEvent: SocketAnyEvent) in
            
            switch(socketAnyEvent.event) {
                
            case "connect":
                serverManager.socket?.emit(serverManager.userDisplayInfo)
                serverManager.leaveAllRooms()
                break
                
            case "mySocketId":
                if let mySocketId = socketAnyEvent.items?.firstObject as? String {
                    serverManager.userDisplayInfo.socketId = mySocketId
                }
                break
                
            case "roomId":
                serverManager.roomId(socketAnyEvent)
                break
                
            default:
                print(socketAnyEvent.description)
                break
            }
        })
    }
    
    func connect(completion block: () -> Void = {}) {
        
        let startTime = GameScene.currentTime
        
        let config =  SocketIOClientConfiguration(
            arrayLiteral:
            SocketIOClientOption.ReconnectAttempts(30),
            SocketIOClientOption.ReconnectWait(2)
        )
        
        #if DEBUG
            let urls = [
                "http://localhost:8940",
                "http://Pablos-MacBook-Pro.local:8900",
                "http://172.16.3.149:8940", //Pablos-MacBook-Pro ip fixo no bepid
                "http://192.168.1.102:8940",
                "http://192.168.0.4:8940"
            ]
        #else
            let urls = [
                "http://ec2-52-53-213-35.us-west-1.compute.amazonaws.com:8941", //
                "http://181.41.197.181:8941", //Host1Plus
            ]
        #endif
        
        
        for url in urls {
            if let url = NSURL(string:url) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) { [weak self] in
                    
                    guard let serverManager = self else { return }
                    
                    let socket = SocketIOClient(socketURL: url, config: config)
                    
                    socket.on("connect", callback: { (data:[AnyObject], socketAckEmitter:SocketAckEmitter) in
                        
                        if let _ = serverManager.socket {
                            print("disconnecting from: " + url.description)
                            socket.disconnect()
                        } else {
                            
                            serverManager.socket = socket
                            print("connected to " + url.description)
                            socket.emit(serverManager.userDisplayInfo)
                            serverManager.leaveAllRooms()
                            serverManager.setHandlers()
                            
                            block()
                        }
                        print(Int((GameScene.currentTime - startTime) * 1000).description + "ms")
                    })
                    
                    socket.connect(timeoutAfter: 10, withTimeoutHandler: {
//                        print("connection timed out for: " + url.description)
//                        print(Int((GameScene.currentTime - startTime) * 1000).description + "ms")
                        socket.disconnect()
                    })
                }
            }
        }
    }
    
    func disconnect() {
        if self.socket != nil {
            self.room = nil
            self.socket?.disconnect()
            self.socket = nil
        }
    }
    
    func leaveAllRooms() {
        if self.room != nil {
            self.room = nil
            self.socket?.emit("leaveAllRooms")
        }
    }
    
    func getAllRooms() {
        self.socket?.emit("getAllRooms", self.version)
    }
    
    func createRoom() {
        self.room = Room(roomId: self.userDisplayInfo.socketId, userDisplayInfo: self.userDisplayInfo)
        //self.socket?.emit("createRoom") // Servidor já criou a sala
    }
    
    func joinRoom(room: Room) {
        self.room = room
        self.room?.addPlayer(self.userDisplayInfo)
        self.socket?.emit("joinRoom", room.roomId)
    }
    
    func addPlayer(socketAnyEvent: SocketAnyEvent) {
        self.room?.addPlayer(socketAnyEvent)
    }
    
    func roomId(socketAnyEvent: SocketAnyEvent) {
        
        if let scene = Control.gameScene as? MothershipScene {
            
            if GameScene.currentTime - scene.lastShake > 3 {
                
                scene.lastShake = GameScene.currentTime
                
                if let items = socketAnyEvent.items?.firstObject as? [AnyObject] {
                    var i = items.generate()
                    let _ = i.next()
                    let name = i.next() as! String
                    
                    if let version = i.next() as? String {
                        
                        if self.version == version {
                            
                            let labelText = "Tap BATTLE now to play with " + name
                            
                            let label = Label(color: SKColor.blackColor(), text: labelText, fontSize: 10, x: 160, y: 352, xAlign: .center, yAlign: .center)
                            
                            scene.addChild(label)
                            
                            label.runAction({ let a = SKAction(); a.duration = 3; return a }(), completion: { [weak label] in
                                label?.runAction(SKAction.fadeAlphaTo(0, duration: 1), completion: {
                                    label?.removeFromParent()
                                })
                                })
                            
                            scene.buttonBattle.shake()
                            
                            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                        }
                    }
                }
            }
        }
    }
}

extension SocketIOClient {
    
    func emit(userDisplayInfo: UserDisplayInfo) {
        self.emit("userDisplayInfo", userDisplayInfo.displayName)
    }
    
    func emit(mothership: Mothership) {
        
        var items = [AnyObject]()
        
        items.append("mothership" as AnyObject)
        items.append(mothership.level as AnyObject)
        
        for spaceship in mothership.spaceships {
            items.append(
                [
                    spaceship.battleMaxLevel as AnyObject,
                    spaceship.type.index as AnyObject
                ])
        }
        
        self.emit("someData", items)
    }
}
