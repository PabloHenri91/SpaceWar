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
        
        serverManager.socket?.onAny({ (socketAnyEvent: SocketAnyEvent) in
            
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
                
            case "connectedSockets.length":
                if let connectedSocketsLength = socketAnyEvent.items?.firstObject as? Int {
                    print("Players Online: " + connectedSocketsLength.description)
                    if connectedSocketsLength > 1 {
                        
                    } else {
                        self.loadBots()
                        self.nextState = .battle
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
