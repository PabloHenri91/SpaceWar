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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Label(color: GameColors.white, text: "BattleScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        //self.addChild(Control(textureName: "background", xAlign: .center, yAlign: .center))
        
        self.gameWorld = GameWorld(physicsWorld: self.physicsWorld)
        if let scene = self.scene {
            self.gameWorld.setScreenBox(scene.size)
        }
        self.addChild(self.gameWorld)
        self.physicsWorld.contactDelegate = self.gameWorld
        
        self.gameCamera = GameCamera()
        self.gameWorld.addChild(self.gameCamera)
        self.gameWorld.addChild(self.gameCamera.node)
        
        self.mothership = Mothership(mothershipData: self.playerData.motherShip)
        self.gameWorld.addChild(self.mothership)
        
        self.gameCamera.node.position = self.mothership.position
        self.gameCamera.update()
        
        self.mothership.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -330), duration: 2/10)) { [weak self] in
            guard let scene = self else { return }
            scene.nextState = states.battle
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        for spaceship in self.mothership.spaceships {
            spaceship.update()
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                    
                case states.battle:
                    
                    for spaceship in self.mothership.spaceships {
                        if let parent = spaceship.parent {
                            if spaceship.containsPoint(touch.locationInNode(parent)) {
                                spaceship.touchEnded()
                                return
                            }
                        }
                    }
                    
                    if let parent = self.mothership.spriteNode.parent {
                        if self.mothership.spriteNode.containsPoint(touch.locationInNode(parent)) {
                            Spaceship.retreat()
                            return
                        }
                    }
                    
                    Spaceship.touchEnded(touch)
                    
                    break
                    
                default:
                    break
                }
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case .battle:
                break
            default:
                #if DEBUG
                    fatalError(self.nextState.rawValue)
                #endif
                break
            }
        }
        
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        
        self.gameCamera.update()
    }
}
