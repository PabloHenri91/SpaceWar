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
    }
    
    //Estados iniciais
    var state = states.mothership
    var nextState = states.mothership
    
    var buttonBattle:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        self.addChild(Label(color: GameColors.white, text: "MothershipScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonBattle = Button(textureName: "button", text: "battle", x: 100, y: 100, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBattle)
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
                self.view?.presentScene(BattleScene(), transition: self.transition)
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
                    break
                    
                default:
                    break
                }
            }
        }
        
    }

}
