//
//  ResearchCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 05/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class ResearchCard: Control {
    
    var research: Research!
    var buttonBegin: Button?
    var buttonSpeedUp: Button?
    var buttonColect: Button?
    var labelName: Label!
    var labelDescription: Label!
    var needUpdate = true
    var lastUpdate: NSTimeInterval = 0
    
    init(research:Research) {
        
        super.init()
        
        self.addChild(Control(textureName: "hangarShipCardSelected"))
        
        self.research = research
   
        let researchType = self.research.researchType
        
        self.labelName = Label(color:SKColor.whiteColor() ,text: researchType.name , x: 137, y: 23)
        self.addChild(self.labelName)
        
        
        
        if (self.research.researchStartDate != nil) {
            
    
            let time = GameMath.researchFinishTime(self.research.researchStartDate! , researchTime: researchType.duration)
            
            if (time > 0) {
                
                //TODO: descomentar
//                self.buttonSpeedUp = Button(textureName: "buttonSmall", text: "SpeedUp",  x: 86, y: 85)
//                self.addChild(self.buttonSpeedUp!)
                
                self.labelDescription = Label(text: "Remaining Time: " + GameMath.timeFormated(time), fontSize: 12 , x: 137, y: 58)
                self.addChild(self.labelDescription)
            } else {
                
                self.buttonColect = Button(textureName: "buttonSmall", text: "Colect",  x: 86, y: 85)
                self.addChild(self.buttonColect!)
                
                self.labelDescription = Label(text: "Mission finished", fontSize: 12 , x: 137, y: 58)
                self.addChild(self.labelDescription)
            }
            
            
        } else {
            
            
            self.buttonBegin = Button(textureName: "buttonSmall", text: "Begin",  x: 86, y: 85)
            self.addChild(self.buttonBegin!)
            

            self.labelDescription = Label(text: "Time: " + GameMath.timeFormated(self.research.researchType.duration)  , fontSize: 12 , x: 137, y: 58)
            self.addChild(self.labelDescription)

        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(currentTime: NSTimeInterval) {
        
        if ((currentTime - self.lastUpdate) > 1) {
            self.lastUpdate = currentTime

            if (self.needUpdate) {
                if (self.research.researchStartDate != nil) {
                    
                    let time = GameMath.researchFinishTime(self.research.researchStartDate! , researchTime: self.research.researchType.duration)
                    
                    if (time > 0) {
                        self.labelDescription.setText("Remaining Time: " + GameMath.timeFormated(time))
                    } else  {
                        self.needUpdate = false
                        
                        if let buttonSpeedUp = self.buttonSpeedUp {
                            buttonSpeedUp.removeFromParent()
                            self.buttonSpeedUp = nil
                        }
                        
                        if let buttonBegin = self.buttonBegin {
                            buttonBegin.removeFromParent()
                            self.buttonBegin = nil
                        }
        
                        if let buttonColect = self.buttonColect {
                            buttonColect.removeFromParent()
                        }
                        
                        self.buttonColect = Button(textureName: "buttonSmall", text: "Colect",  x: 86, y: 85)
                        self.addChild(self.buttonColect!)
                        self.labelDescription.setText("Mission finished")
                    }
                    
                } else {
                    self.needUpdate = false
                }
                
            }
        }
        
    }

    
}
                
        