//
//  MissionScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class MissionScene: GameScene {
    
    
    
    var playerData = MemoryCard.sharedInstance.playerData
    let missionShips = MemoryCard.sharedInstance.playerData.missionSpaceships 
    
    
    var selectedSpaceship: MissionSpaceship?
    var cropBox: CropBox!
    
    var buttonBack:Button!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<MissionSpaceshipCard>!
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case mothership
        
        case chooseMission
        
        
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
        
        self.controlArray = Array<MissionSpaceshipCard>()
        
        for item in missionShips {
            
            self.controlArray.append(MissionSpaceshipCard(missionSpaceship: MissionSpaceship(missionSpaceshipData: item as! MissionSpaceshipData)))
            
        }
        
        self.cropBox = CropBox(name: "crop", textureName: "missionSpaceshipsCropBox", x: 20, y: 86)
        self.addChild(self.cropBox)
        
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
        self.cropBox.addChild(self.scrollNode)
        
        
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .normal:
                
                for item in self.scrollNode.cells {
                    if let card = item as? MissionSpaceshipCard {
                        card.update(currentTime)
                    }
                }
                
                break
                
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case .normal:
                break
                
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: GameScene.transition)
                break
                
            case .chooseMission:
                if let spaceship = self.selectedSpaceship {
                    self.view?.presentScene(ChooseMissionScene(missionSpaceship: spaceship), transition: GameScene.transition)
                } else {
                    #if DEBUG
                        fatalError()
                    #endif
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
    
   
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.normal:
                    
                    
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .mothership
                        return
                    }
                    
                    if (self.scrollNode.containsPoint(touch.locationInNode(self.cropBox.cropNode))) {
                        for item in self.scrollNode.cells {
                            if (item.containsPoint(touch.locationInNode(self.scrollNode))) {
                                if let card = item as? MissionSpaceshipCard {
                                    if ((card.position.y < 250) && (card.position.y > -250)){
                                        if let buttonBegin = card.buttonBegin{
                                            if (buttonBegin.containsPoint(touch.locationInNode(card))) {
                                                self.nextState = .chooseMission
                                                self.selectedSpaceship = card.missionSpaceship
                                            }
                                        }
                                        
                                        if let buttonColect = card.buttonColect {
                                            if(buttonColect.containsPoint(touch.locationInNode(card))) {
                                                card.colect()
                                            }
                                        }
                                        
                                        if let buttonSpeedUp = card.buttonSpeedUp {
                                            if(buttonSpeedUp.containsPoint(touch.locationInNode(card))) {
                                                print("SpeedUP")
                                            }
                                        }
                                        
   
                                        if let buttonUpgrade = card.buttonUpgrade {
                                            if(buttonUpgrade.containsPoint(touch.locationInNode(card))) {
                                                print("Upgrade")
                                            }
                                        }
                                    
                                    }
                                    
                                    
                                    return
                                }
                            }
                        }
                        
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
}