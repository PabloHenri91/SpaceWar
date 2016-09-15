//
//  HealthBar.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 6/10/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HealthBar: Control {
    
    var spriteNodeFill:SKSpriteNode!
    var fillMaxWidth:CGFloat = 1
    
    var positionOffset = CGPoint(x: 0, y: 0)

    init(background:SKSpriteNode? = nil, size:CGSize = CGSize(width: 37, height: 6), backColor: SKColor = SKColor.clearColor(), fillColor: SKColor = SKColor.greenColor()) {
        super.init()
        
        let spriteNodeBack = SKSpriteNode(texture: nil, color: backColor, size: size)
        spriteNodeBack.texture?.filteringMode = Display.filteringMode
        
        self.fillMaxWidth = spriteNodeBack.size.width
        
        self.spriteNodeFill = SKSpriteNode(texture: nil, color: fillColor, size: size)
        self.spriteNodeFill.texture?.filteringMode = Display.filteringMode
        
        if let background = background {
            background.color = backColor
            background.colorBlendFactor = 1
            self.addChild(background)
        }
        self.addChild(spriteNodeBack)
        self.addChild(self.spriteNodeFill)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(position position:CGPoint) {
        let x = position.x + self.positionOffset.x
        let y = position.y + self.positionOffset.y
        self.position = CGPoint(x: x, y: y)
    }
    
    func update(health:Int, maxHealth:Int) {
        
        var width = Int((CGFloat(health) / CGFloat(maxHealth)) * self.fillMaxWidth)
        let height = Int(self.spriteNodeFill.size.height)
        
        if width < 0 {
            width = 0
        }
        
        self.spriteNodeFill.size = CGSize(width: width, height: height)
        
        let x = -Int(self.fillMaxWidth)/2 + width/2
        let y = 0
        self.spriteNodeFill.position = CGPoint(x: x, y: y)
    }
    
    override func removeFromParent() {
        self.spriteNodeFill = nil
        super.removeFromParent()
    }
}
