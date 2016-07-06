//
//  HealthBar.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 6/10/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HealthBar: Control {
    
    var greenBar:SKSpriteNode!
    var greenBarMaxWidth:CGFloat = 1
    
    var biggerSide:CGFloat = 0
    
    var barPosition:yAlignments = .up

    init(size:CGSize, borderColor:SKColor) {
        super.init()
        
        self.biggerSide = size.width > size.height ? size.width : size.height
        
        let spriteNodeBorder = SKSpriteNode(texture: nil, color: borderColor, size: CGSize(width: biggerSide, height: 4))
        spriteNodeBorder.texture?.filteringMode = Display.filteringMode
        
        
        self.greenBarMaxWidth = spriteNodeBorder.size.width - 2
        
        let back = SKSpriteNode(texture: nil, color: SKColor.blackColor(), size: CGSize(width: self.greenBarMaxWidth, height: 4 - 2))
        back.texture?.filteringMode = Display.filteringMode
        
        self.greenBar = SKSpriteNode(texture: nil, color: SKColor.greenColor(), size: CGSize(width: self.greenBarMaxWidth, height: 4 - 2))
        self.greenBar.texture?.filteringMode = Display.filteringMode
        
        
        self.addChild(spriteNodeBorder)
        self.addChild(back)
        self.addChild(self.greenBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(position position:CGPoint) {
        
        switch self.barPosition {
        case .up:
            let x = position.x
            let y = position.y + (self.biggerSide/2 + 4)
            self.position = CGPoint(x: x, y: y)
            break
        case .down:
            let x = position.x
            let y = position.y - (self.biggerSide/2 + 4)
            self.position = CGPoint(x: x, y: y)
            break
        default:
            fatalError()
            break
        }
    }
    
    func update(health:Int, maxHealth:Int) {
        
        var width = Int((CGFloat(health) / CGFloat(maxHealth)) * self.greenBarMaxWidth)
        let height = Int(self.greenBar.size.height)
        
        if width < 0 {
            width = 0
        }
        
        self.greenBar.size = CGSize(width: width, height: height)
        
        let x = -Int(self.greenBarMaxWidth)/2 + width/2
        let y = 0
        self.greenBar.position = CGPoint(x: x, y: y)
    }
}
