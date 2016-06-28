//
//  GameScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    enum states : String {
        //Estado principal
        case load
        
        //Estados de saida da scene
        case mothership
    }
    
    //Estados iniciais
    var state = states.load
    var nextState = states.load
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .load:
                self.nextState = .mothership
                break
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: GameScene.transition)
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
}
