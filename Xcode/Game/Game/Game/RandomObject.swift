//
//  RandomObject.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/11/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class RandomObject: Control {
    
    override init(){
        
        super.init()
        
        var objectNames = [
            "object1",
            "object2",
            "object3",
            "object4",
            "object5",
            "nyancat"
        ]
        
        let size = Display.currentSceneSize
        let x =  Int.random(min: 0, max: Int(size.width))
        let y = Int.random(min: 0, max: Int(size.height))
        
        let screenPoint = CGPoint(x: x, y: -y)
        
        let angle = Int.random(min: 0, max: 360)
        let radianAngle = CGFloat(angle).degreesToRadians()
        
        let destiny = CGPoint(angle: radianAngle) * 1000
        
        let delta = CGVector(point: screenPoint - destiny)
        
        let object = SKSpriteNode(imageNamed: objectNames[Int.random(objectNames.count)])
        object.position = destiny
        object.zPosition = GameWorld.zPositions.battleArea.rawValue + 1
        object.zRotation = delta.angle
        object.alpha = 0.5
        self.addChild(object)
       
        
        
        object.runAction(SKAction.sequence([SKAction.moveBy(delta, duration: 3),SKAction.moveBy(delta, duration: 3)])) {
            self.removeFromParent()
        }
        
        
        
        
        
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}