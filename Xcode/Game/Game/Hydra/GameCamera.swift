//
//  GameCamera.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/22/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameCamera: SKNode {
    
    var node = SKNode()
    
    func update() {
        let newPosition = self.node.position
        self.position = CGPoint(x: newPosition.x - Display.currentSceneSize.width/2, y: newPosition.y + Display.currentSceneSize.height/2)
        self.scene?.centerOnNode(self)
    }
}

public extension SKScene {
    
    func centerOnNode(node:SKNode) {
        if let parent = node.parent {
            let cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: parent)
            parent.position = CGPoint(
                x: CGFloat(parent.position.x - cameraPositionInScene.x),
                y: CGFloat(parent.position.y - cameraPositionInScene.y))
        }
    }
}
