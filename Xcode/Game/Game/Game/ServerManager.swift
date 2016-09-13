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
                "http://192.168.1.102:8940"
                ]
        #else
            let urls = [
                "http://181.41.197.181:8940", //Host1Plus
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
                        print("connection timed out for: " + url.description)
                        print(Int((GameScene.currentTime - startTime) * 1000).description + "ms")
                        socket.disconnect()
                    })
                }
            }
        }
    }
    
    func disconnect() {
        self.room = nil
        self.socket?.disconnect()
    }
    
    func leaveAllRooms() {
        self.room = nil
        self.socket?.emit("leaveAllRooms")
    }
    
    func getAllRooms() {
        self.socket?.emit("getAllRooms")
    }
    
    func createRoom() {
        self.room = Room(roomId: self.userDisplayInfo.socketId, userDisplayInfo: self.userDisplayInfo)
        self.socket?.emit("createRoom")
    }
    
    func joinRoom(room: Room) {
        self.room = room
        self.room?.addPlayer(self.userDisplayInfo)
        self.socket?.emit("joinRoom", room.roomId)
    }
    
    func addPlayer(socketAnyEvent: SocketAnyEvent) {
        self.room?.addPlayer(socketAnyEvent)
    }
}

extension SocketIOClient {
    
    func emit(userDisplayInfo: UserDisplayInfo) {
        self.emit("userDisplayInfo", userDisplayInfo.displayName)
    }
    
    func emit(mothership: Mothership) {
        
        var items = [AnyObject]()
        
        items.append("mothership")
        items.append(mothership.level)
        
        for spaceship in mothership.spaceships {
            items.append([spaceship.level, spaceship.type.index, spaceship.weapon!.type.index])
        }
        
        self.emit("someData", items)
    }
}
