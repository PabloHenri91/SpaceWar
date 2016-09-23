//
//  Room.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/19/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

class Room {
    
    var roomId = ""
    
    var usersDisplayInfo = [UserDisplayInfo]()
    
    init(roomId: String, userDisplayInfo: UserDisplayInfo) {
        self.roomId = roomId
        self.usersDisplayInfo.append(userDisplayInfo)
    }
    
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
    
    func addPlayer(newUserDisplayInfo: UserDisplayInfo) {
        
        var containsNewUserDisplayInfo = false
        
        for userDisplayInfo in self.usersDisplayInfo {
            if userDisplayInfo.socketId == newUserDisplayInfo.socketId {
                containsNewUserDisplayInfo = true
                break
            }
        }
        
        if !containsNewUserDisplayInfo {
            self.usersDisplayInfo.append(newUserDisplayInfo)
        }
    }
    
    func addPlayer(socketAnyEvent: SocketAnyEvent) {
        
        if let message = socketAnyEvent.items?.firstObject as? [String] {
            self.addPlayer(UserDisplayInfo(socketId: message[0], displayName: message[1]))
        }
    }
}
