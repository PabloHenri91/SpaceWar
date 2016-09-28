//
//  Box.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/1/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Box: Control {
    
    init(name:String = "", textureName:String, x:Int = -1, y:Int = -1, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center) {
        
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = Display.filteringMode
        
        let position = CGPoint(
            x: x == -1 ? Display.sceneSize.width/2 - texture.size().width/2 : CGFloat(x),
            y: y == -1 ? Display.sceneSize.height/2  - texture.size().height/2 : CGFloat(y))
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.texture?.filteringMode = Display.filteringMode
        
        super.init(spriteNode: spriteNode, x: Int(position.x), y: Int(position.y), xAlign: xAlign, yAlign: yAlign)
    }
    
    init (spriteNode: SKSpriteNode, x:Int = -1, y:Int = -1, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center) {
        
        let position = CGPoint(
            x: x == -1 ? Display.sceneSize.width/2  : CGFloat(1),
            y: y == -1 ? Display.sceneSize.height/2 : CGFloat(1))
        

        super.init(spriteNode: spriteNode, x: Int(position.x), y: Int(position.y), xAlign: xAlign, yAlign: yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jump() {
        let x = self.position.x - (self.size.width/2) * 0.1
        let y = self.position.y + (self.size.height/2) * 0.1
        
        self.setScale(0)
        self.position = CGPoint(x: Display.currentSceneSize.width/2, y: -Display.currentSceneSize.height/2)
        
        let duration:Double = 0.10
        
        let action1 = SKAction.group([
            SKAction.scaleTo(1.1, duration: duration),
            SKAction.moveTo(CGPoint(x: x, y: y), duration: duration)
            ])
        
        let action2 = SKAction.group([
            SKAction.scaleTo(1, duration: duration),
            SKAction.moveTo(self.getPositionWithScreenPosition(self.screenPosition), duration: duration)
            ])
        
        self.runAction(SKAction.sequence([action1, action2]))
    }
}
