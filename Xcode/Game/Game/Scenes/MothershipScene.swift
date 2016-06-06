//
//  MothershipScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipScene: GameScene {
    
    enum states : String {
        //Estado principal
        case mothership
        
        //Estados de saida da scene
        case battle
        
        //Estados de saida da scene
        case social
    }
    
    //Estados iniciais
    var state = states.mothership
    var nextState = states.mothership
    
    let playerData = MemoryCard.sharedInstance.playerData
    
    var buttonBattle:Button!
    var buttonSocial:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        self.addChild(Label(color: GameColors.white, text: "MothershipScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        let background = Control(textureName: "background", x:-53, xAlign: .center, yAlign: .center)
        background.zPosition = -2
        self.addChild(background)
        
        self.buttonBattle = Button(textureName: "button", text: "battle", x: 93, y: 247, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBattle)
        
        self.buttonSocial = Button(textureName: "button", text: "Social", x: 93, y: 299, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonSocial)
        
        let control = Control(spriteNode: SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 1,height: 1)), x:160, y:284, xAlign: .center, yAlign: .center)
        control.zPosition = -1
        self.addChild(control)
        control.addChild(Mothership(mothershipData: self.playerData.motherShip))
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            default:
                break
            }
        } else {
            //Próximo estado
            switch (self.nextState) {
            case .battle:
                self.view?.presentScene(BattleScene())
                break
            case .social:
                self.view?.presentScene(SocialScene())
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.mothership:
                    if(self.buttonBattle.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.battle
                        return
                    }
                    
                    if(self.buttonSocial.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.social
                        return
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }

}
