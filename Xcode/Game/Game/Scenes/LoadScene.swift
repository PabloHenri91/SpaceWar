//
//  GameScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    static var nextScene:String?
    
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
                if MemoryCard.sharedInstance.playerData.needBattleTraining.boolValue {
                    self.view?.presentScene(BattleTrainingScene())
                } else {
                    if let nextScene = LoadScene.nextScene {
                        switch nextScene {
                        case EventCard.types.researchEvent.rawValue:
                            GameTabBar.lastState = .research
                            self.view?.presentScene(ResearchScene())
                            break
                        case EventCard.types.missionSpaceshipEvent.rawValue:
                            GameTabBar.lastState = .mission
                            self.view?.presentScene(MissionScene())
                            break
                        default:
                            self.view?.presentScene(MothershipScene())
                            break
                        }
                    } else {
                        self.view?.presentScene(MothershipScene())
                    }
                }
                
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
