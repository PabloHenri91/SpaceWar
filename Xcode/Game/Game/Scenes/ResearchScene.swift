//
//  SocialScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class ResearchScene: GameScene {
    
    var playerData = MemoryCard.sharedInstance.playerData
    let researches = MemoryCard.sharedInstance.playerData.researches
    var research:Research?
    
    var cropBox: CropBox!
    
    var buttonBack:Button!
    var labelNoResearchs:Label?
    
    var scrollNode:ScrollNode?
    var controlArray:Array<ResearchCard>!
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case mothership
        
        case researchDetails
        

    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        self.cropBox = CropBox(name: "crop", textureName: "missionSpaceshipsCropBox", x: 20, y: 86)
        self.addChild(self.cropBox)
        
        self.updateResearchs()

        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)

    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .normal:
                
                if let scrollNode = self.scrollNode {
                    
                    for item in scrollNode.cells {
                        if let card = item as? ResearchCard {
                            card.update(currentTime)
                        }
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
                
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: GameScene.transition)
                break
                
            case .researchDetails:
                self.view?.presentScene(ResearchDetailsScene(research: self.research!), transition: GameScene.transition)
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func updateResearchs() {
        

        self.controlArray = Array<ResearchCard>()
        
        for item in researches {
            let research = Research(researchData: item as! ResearchData)
            if research.isUnlocked() {
                if research.researchData?.done != 1 {
                    self.controlArray.append(ResearchCard(research: research))
                }
            }
        }
        
        if self.controlArray.count > 0 {
            
            if let scroll = self.scrollNode {
                scroll.removeFromParent()
            }
            
            if let label = self.labelNoResearchs {
                label.removeFromParent()
            }

            self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
            self.cropBox.addChild(self.scrollNode!)
            
        } else {
            self.scrollNode?.removeFromParent()
            self.labelNoResearchs = Label(text: "No researchs", fontSize: 24 , x: 160, y: 268)
            self.addChild(self.labelNoResearchs!)
        }
        
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.normal:

                    
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .mothership
                        return
                    }
                    
                    if let scrollNode = self.scrollNode {
                        
                        if (scrollNode.containsPoint(touch.locationInNode(self.cropBox.cropNode))) {
                            for item in scrollNode.cells {
                                if (item.containsPoint(touch.locationInNode(scrollNode))) {
                                    if let card = item as? ResearchCard {
                                        if ((card.position.y < 250) && (card.position.y > -250)){
                                            
                                            if let buttonBegin = card.buttonBegin {
                                                if(buttonBegin.containsPoint(touch.locationInNode(card))) {
                                                    self.research = card.research
                                                    self.nextState = .researchDetails
                                                }
                                            }
                                            
                                            
                                            if let buttonSpeedup = card.buttonSpeedUp {
                                                if(buttonSpeedup.containsPoint(touch.locationInNode(card))) {
                                                    self.research = card.research
                                                    self.nextState = .researchDetails
                                                }
                                            }
                                            
                                            if let buttonColect = card.buttonColect {
                                                if(buttonColect.containsPoint(touch.locationInNode(card))) {
                                                    card.research.colect()
                                                    self.updateResearchs()
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        return
                                    }
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