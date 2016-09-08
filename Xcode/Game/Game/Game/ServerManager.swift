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
    
    var roomId:String?
    var otherUsersDisplayInfo: UserDisplayInfo?
    
    var availableRooms = [String]()
    
     init() {
        
        let config =  SocketIOClientConfiguration(
            arrayLiteral:
            SocketIOClientOption.ReconnectAttempts(30),
            SocketIOClientOption.ReconnectWait(2)
        )
        
        //let url = "http://localhost:8940"
        //let url = "http://Pablos-MacBook-Pro.local:8900"
        let url = "http://172.16.3.149:8940" //Meu ip fixo no bepid
        //let url = "http://192.168.1.102:8940"
        //let url = "http://181.41.197.181:8900"
        
        if let url = NSURL(string:url) {
            self.socket = SocketIOClient(socketURL: url, config: config)
        }
        
        let displayName = MemoryCard.sharedInstance.playerData.name
        self.userDisplayInfo = UserDisplayInfo(displayName: displayName)
    }
    
    func disconnect() {
        self.roomId = nil
        self.socket?.disconnect()
    }
    
    func leaveAllRooms() {
        self.roomId = nil
        self.socket?.emit("leaveAllRooms")
    }
    
    func getAllRooms() {
        self.availableRooms = [String]()
        self.socket?.emit("getAllRooms")
    }
    
    func createRoom() {
        self.socket?.emit("createRoom")
    }
    
    func joinRoom(room: Room) {
        self.socket?.emit("joinRoom", room.roomId)
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
