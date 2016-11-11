//
//  Credits.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 10/11/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Credits: Control {
    
    override init(){
        
        super.init()
        
        var planetNames = [
            "planet0",
            "planet1",
            "planet2"
        ]
        
        
        let spriteNode = SKSpriteNode(imageNamed: "battleBackground")
        self.addChild(spriteNode)
        
        spriteNode.position = CGPoint(x: 282/2, y: -(294/2))
        
        let size = spriteNode.size
        
        let spriteNode2 = SKSpriteNode(imageNamed: planetNames[Int.random(planetNames.count)])
        spriteNode2.setScale(0.5)
        spriteNode2.position = CGPoint(x: Int.random(min: -Int(size.width)/2, max: Int(size.width)/2), y: Int.random(min: -Int(size.height)/2, max: Int(size.height)/2))
        spriteNode2.zPosition = GameWorld.zPositions.battleArea.rawValue + 1
        spriteNode.addChild(spriteNode2)
        
        let label1 = Label(color:SKColor.whiteColor() ,text: "GAME DESIGN" , fontSize: 18, x: 0, y: 284, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        spriteNode.addChild(label1)
        
        label1.runAction(SKAction.moveToY(550, duration: 6))
        
        let label2 = Label(color:SKColor.whiteColor() ,text: "Paulo Henrique dos Santos" , fontSize: 14, x: 0, y: 310, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        spriteNode.addChild(label2)
        
        label2.runAction(SKAction.moveToY(527, duration: 6))
        
        
        
        let label3 = Label(color:SKColor.whiteColor() ,text: "CODE" , fontSize: 18, x: 0, y: 354, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        spriteNode.addChild(label3)
        
        label3.runAction(SKAction.moveToY(483, duration: 6))
        
        let label4 = Label(color:SKColor.whiteColor() ,text: "Pablo Henrique Bertaco" , fontSize: 14, x: 0, y: 377, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        spriteNode.addChild(label4)
        
        label4.runAction(SKAction.moveToY(460, duration: 6))
        
        let label5 = Label(color:SKColor.whiteColor() ,text: "Paulo Henrique dos Santos" , fontSize: 14, x: 0, y: 393, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        spriteNode.addChild(label5)
        
        label5.runAction(SKAction.moveToY(444, duration: 6))
        
        
        
        let label6 = Label(color:SKColor.whiteColor() ,text: "UI/UX" , fontSize: 18, x: 0, y: 437, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        spriteNode.addChild(label6)
        
        label6.runAction(SKAction.moveToY(400, duration: 6))
        
        let label7 = Label(color:SKColor.whiteColor() ,text: "Gabriel Sotelo" , fontSize: 14, x: 0, y: 460, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        spriteNode.addChild(label7)
        
        label7.runAction(SKAction.moveToY(377, duration: 6))
        
        
        let label8 = Label(color:SKColor.whiteColor() ,text: "ART" , fontSize: 18, x: 0, y: 504, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        spriteNode.addChild(label8)
        
        label8.runAction(SKAction.moveToY(333, duration: 6))
        
        let label9 = Label(color:SKColor.whiteColor() ,text: "Gabriel Sotelo" , fontSize: 14, x: 0, y: 527, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        spriteNode.addChild(label9)
        
        label9.runAction(SKAction.moveToY(310, duration: 6)) { [weak self] in
            self?.removeFromParent()
        }
        
        self.userInteractionEnabled = true
        
        
    }
    
    
//     func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
//     func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromParent()
    }
//     func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
