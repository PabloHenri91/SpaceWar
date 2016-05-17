//
//  GameCamera.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/22/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameCamera: SKNode {
    
    static let arenaSizeWidth:CGFloat = ((1920/2) + 1334)/2
    static let arenaSizeHeight:CGFloat = ((1080/2) + 750)/2
    
    func update(newPosition:CGPoint) {
        self.position = CGPoint(x: Display.translate.x, y: Display.translate.y)
        self.scene!.centerOnNode(self)
    }
}

public extension SKScene {
    
    func centerOnNode(node:SKNode)
    {
        if let parent = node.parent {
            let cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: parent)
            parent.position = CGPoint(
                x: CGFloat(parent.position.x - cameraPositionInScene.x),
                y: CGFloat(parent.position.y - cameraPositionInScene.y))
        }
    }
}
