//
//  BattleScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/24/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleScene: GameScene {
    
    enum states : String {
        //Estado principal
        case battle
        
        case loading
        case countdown
        
        //Estados de saida da scene
        case battleEnd
    }
    
    //Estados iniciais
    var state = states.loading
    var nextState = states.loading
    
    let playerData = MemoryCard.sharedInstance.playerData
    
    var gameWorld:GameWorld!
    var gameCamera:GameCamera!
    var mothership:Mothership!
    
    var otherMothership:Mothership!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Label(color: GameColors.white, text: "BattleScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        //self.addChild(Control(textureName: "background", xAlign: .center, yAlign: .center))
        
        self.gameWorld = GameWorld(physicsWorld: self.physicsWorld)
        self.addChild(self.gameWorld)
        self.physicsWorld.contactDelegate = self.gameWorld
        
        self.gameCamera = GameCamera()
        self.gameWorld.addChild(self.gameCamera)
        self.gameWorld.addChild(self.gameCamera.node)
        
        self.otherMothership = Mothership(level: 2)
        self.gameWorld.addChild(self.otherMothership)
        self.otherMothership.zRotation = CGFloat(M_PI)
        self.otherMothership.position = CGPoint(x: 0, y: 330 * 2)
        self.otherMothership.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -330), duration: 3))
        
        self.mothership = Mothership(mothershipData: self.playerData.motherShip)
        self.gameWorld.addChild(self.mothership)
        
        self.gameCamera.node.position = self.mothership.position
        self.gameCamera.update()
        
        self.mothership.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -330), duration: 2))
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        
        self.gameCamera.update()
    }
}
