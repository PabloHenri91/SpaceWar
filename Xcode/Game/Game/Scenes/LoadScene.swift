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
    
    enum states: String {
        //Estado principal
        case load
        
        case connect
        case connecting
        
        //Estados de saida da scene
        case mothership
    }
    
    //Estados iniciais
    var state = states.load
    var nextState = states.load
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        #if DEBUG
//            MemoryCard.sharedInstance.reset()
//            MemoryCard.sharedInstance.playerData!.points = 1000000
//            MemoryCard.sharedInstance.playerData!.premiumPoints = 1000000
//            Research.cheatDuration()
//            Research.cheatUnlockAll()
//            Spaceship.cheatUnlockAll()
//            MemoryCard.sharedInstance.playerData!.needBattleTraining = true
        #endif
        
        self.nextState = .connect
        
        let rateMyApp = RateMyApp.sharedInstance
        rateMyApp.appID = "1111665762"
        
        rateMyApp.trackAppUsage()
        
        self.backgroundColor = SKColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1)
        self.addChild(Control(textureName: "splash", xAlign: .center, yAlign: .center))
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .load:
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
                    self.view?.presentScene(BattleTrainingScene(), transition: SKTransition.crossFadeWithDuration(1))
                } else {
                    if let nextScene = LoadScene.nextScene {
                        switch nextScene {
                        case EventCard.types.researchEvent.rawValue:
                            GameTabBar.lastState = .research
                            self.view?.presentScene(ResearchScene(), transition: SKTransition.crossFadeWithDuration(1))
                            break
                        case EventCard.types.missionSpaceshipEvent.rawValue:
                            GameTabBar.lastState = .mission
                            self.view?.presentScene(MissionScene(), transition: SKTransition.crossFadeWithDuration(1))
                            break
                        default:
                            self.view?.presentScene(MothershipScene(), transition: SKTransition.crossFadeWithDuration(1))
                            break
                        }
                    } else {
                        self.view?.presentScene(MothershipScene(), transition: SKTransition.crossFadeWithDuration(1))
                    }
                }
                
                break
                
            case .connect:
                
                let serverManager = ServerManager.sharedInstance
                
                serverManager.connect()
                
                self.runAction(SKAction.afterDelay(1, runBlock: { [weak self] in
                    self?.nextState = .mothership
                    }))
                
                break
                
            case .connecting:
                #if DEBUG
                    fatalError() // nao pode ter preparacao para troca deste estado
                #endif
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
