//
//  SKSpriteNode.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/1/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.

import SpriteKit

class BlackSpriteNode: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: GameColors.black, size: Display.currentSceneSize)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.hidden = true
    }
    
    func update() {
        self.size = Display.currentSceneSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToParent(parent: SKNode) {
        super.removeFromParent()
        parent.addChild(self)
    }
    
    override func removeFromParent() {
        self.removeAllActions()
        
        for node in self.children {
            node.removeFromParent()
        }
        super.removeFromParent()
    }
}
