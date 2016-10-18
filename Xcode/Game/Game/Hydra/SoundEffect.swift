//
//  SoudEffect.swift
//  TowerUp
//
//  Created by Pablo Henrique on 05/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import SpriteKit

class SoundEffect {
    
    enum effectTypes {
        case noEffect
        case explosion
        case laser
    }
    
    struct fileNames {
        static var explosion = [
            "explosion1.wav",
            "explosion2.wav",
            "explosion3.wav",
            "explosion4.wav",
            "explosion6.wav"
        ]
        static var laser = [
            "laser1",
            "laser2",
            "laser3",
            "laser4",
            "laser5",
            "laser6",
            "laser7"
        ]
    }
    
    var actions = [SKAction]()
    var node:SKNode!
    
    init(soundFile:String, node:SKNode) {
        self.node = node
        self.actions.append(SKAction.playSoundFileNamed(soundFile, waitForCompletion: true))
    }
    
    init(soundType:effectTypes, node:SKNode) {
        self.node = node
        
        var soundFiles = [String]()
        
        switch soundType {
        case .noEffect:
            break
        case .explosion:
            soundFiles.appendContentsOf(fileNames.explosion)
            break
        case .laser:
            soundFiles.appendContentsOf(fileNames.laser)
            break
        }
        
        for soundFile in soundFiles {
            self.actions.append(SKAction.playSoundFileNamed(soundFile, waitForCompletion: true))
        }
    }
    
    func play() {
        if self.actions.count > 1 {
            self.node.runAction(self.actions[Int.random(self.actions.count)])
        } else {
            for action in self.actions {
                self.node.runAction(action)
            }
        }
    }
}
