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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Label(color: GameColors.white, text: "BattleScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.addChild(Mothership(mothershipData: self.playerData.motherShip))
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
    }
}
