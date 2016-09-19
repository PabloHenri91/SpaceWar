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


class ServerManager {
    
    static var sharedInstance = ServerManager()
    
    //Multiplayer Online
    var socket:SocketIOClient?
    
    var userDisplayInfo: UserDisplayInfo
    
    var room: Room?
    
    init() {
        
        let displayName = MemoryCard.sharedInstance.playerData!.name
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
                if let mySocketId = socketAnyEvent.items?.first as? String {
                    serverManager.userDisplayInfo.socketId = mySocketId
                }
                break
                
            default:
                print(socketAnyEvent.description)
                break
            }
        })
    }
    
    func connect(completion block: @escaping () -> Void = {}) {
        
        let startTime = GameScene.currentTime
        
        let config =  SocketIOClientConfiguration(
            arrayLiteral:
            SocketIOClientOption.reconnectAttempts(30),
            SocketIOClientOption.reconnectWait(2)
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
                "http://ec2-52-53-213-35.us-west-1.compute.amazonaws.com:8940", //
                "http://181.41.197.181:8940", //Host1Plus
            ]
        #endif
        
        
        for url in urls {
            if let url = URL(string:url) {
                
                DispatchQueue.global(qos: .default).async(execute: { [weak self] in
                    
                    guard let serverManager = self else { return }
                    
                    let socket = SocketIOClient(socketURL: url, config: config)
                    
                    socket.on("connect", callback: { (data:[Any], socketAckEmitter:SocketAckEmitter) in
                        
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
                    
                    socket.connect(timeoutAfter: 10, withHandler: {
                        print("connection timed out for: " + url.description)
                        print(Int((GameScene.currentTime - startTime) * 1000).description + "ms")
                        socket.disconnect()
                    })
                })
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
        self.socket?.emit("getAllRooms")
    }
    
    func createRoom() {
        self.room = Room(roomId: self.userDisplayInfo.socketId, userDisplayInfo: self.userDisplayInfo)
        //self.socket?.emit("createRoom") // Servidor já criou a sala
    }
    
    func joinRoom(_ room: Room) {
        self.room = room
        self.room?.addPlayer(self.userDisplayInfo)
        self.socket?.emit("joinRoom", room.roomId)
    }
    
    func addPlayer(_ socketAnyEvent: SocketAnyEvent) {
        self.room?.addPlayer(socketAnyEvent)
    }
}

extension SocketIOClient {
    
    func emit(_ userDisplayInfo: UserDisplayInfo) {
        self.emit("userDisplayInfo", userDisplayInfo.displayName)
    }
    
    func emit(_ mothership: Mothership) {
        
        var items = [Any]()
        
        items.append("mothership" as AnyObject)
        items.append(mothership.level as AnyObject)
        
        for spaceship in mothership.spaceships {
            items.append(
                [
                    spaceship.level as AnyObject,
                    spaceship.type.index as AnyObject,
                    spaceship.weapon!.type.index as AnyObject
                ])
        }
        
        self.emit("someData", items)
    }
}
