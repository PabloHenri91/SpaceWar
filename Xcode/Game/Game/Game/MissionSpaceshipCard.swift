//
//  MissionSpaceShipCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 04/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MissionSpaceshipCard: Control {
    
    var missionSpaceship: MissionSpaceship!
    var spaceShipImage: Control!
    var buttonBegin: Button?
    var buttonSpeedUp: Button?
    var buttonColect: Button?
    var buttonUpgrade: Button?
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    var needUpdate: Bool = true
    
    
    var lastUpdate:NSTimeInterval = 0
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    init(missionSpaceship:MissionSpaceship) {
        
        super.init()
        
        self.addChild(Control(textureName: "hangarShipCardSelected"))
        
        self.missionSpaceship = missionSpaceship
        self.spaceShipImage = Control(textureName: "MissionSpaceship" + missionSpaceship.level.description)
        self.addChild(self.spaceShipImage)
        self.spaceShipImage.screenPosition = CGPoint(x: 21, y: 41)
        self.spaceShipImage.resetPosition()
        
 
        
        
        self.labelLevel = Label(text: String(self.missionSpaceship.level) , fontSize: 15, x: 262, y: 14)
        self.addChild(self.labelLevel)
        
        self.labelName = Label(color:SKColor.whiteColor() ,text: "Mission Spaceship " + self.missionSpaceship.level.description , x: 137, y: 23)
        self.addChild(self.labelName)
        
        
        if (self.missionSpaceship.missionType >= 0) {
            
            
            
            let mission = MissionSpaceship.types[self.missionSpaceship.missionType]
            let time = GameMath.MissionFinishTime(self.missionSpaceship.missionStartDate! , missionTime: mission.duration)
            
            if (time > 0) {
                
                //TODO: descomentar
//                self.buttonSpeedUp = Button(textureName: "buttonSmall", text: "SpeedUp",  x: 86, y: 85)
//                self.addChild(self.buttonSpeedUp!)
                
                self.labelDescription = Label(text: "Remaining Time: " + GameMath.timeFormated(time), fontSize: 12 , x: 62, y: 58, horizontalAlignmentMode: .Left)
            } else {
                
                self.buttonColect = Button(textureName: "buttonSmall", text: "Colect",  x: 86, y: 85)
                self.addChild(self.buttonColect!)
                
                self.labelDescription = Label(text: "Mission finished", fontSize: 12 , x: 62, y: 58, horizontalAlignmentMode: .Left)
            }
            
            
        } else {
            
            self.labelDescription = Label(text: "No mission", fontSize: 12 , x: 62, y: 58, horizontalAlignmentMode: .Left)
            
            self.buttonBegin = Button(textureName: "buttonSmall", text: "Begin",  x: 29, y: 85)
            self.addChild(self.buttonBegin!)
            
            
            if self.missionSpaceship.level < 4 {
                self.buttonUpgrade = Button(textureName: "buttonSmall", text: "Upgrade",  x: 144, y: 85)
                self.addChild(self.buttonUpgrade!)
            }
            
            
        }
    
        
        self.addChild(self.labelDescription)
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func colect() {
        
        if let missionspaceshipData = self.missionSpaceship.missionspaceshipData {
            
            self.needUpdate = false
            
            let mission = MissionSpaceship.types[self.missionSpaceship.missionType]
            
            missionspaceshipData.missionType = NSNumber(integer: -1)
            self.missionSpaceship.missionType = -1
            
            self.playerData.points = NSNumber(integer: self.playerData.points.integerValue + mission.pointsBonus)
            self.playerData.motherShip.xp = NSNumber(integer: self.playerData.motherShip.xp.integerValue + mission.xpBonus)

            
            self.buttonColect!.removeFromParent()
            self.buttonColect = nil
            
            
            self.labelDescription.setText("No mission")
            
            self.buttonBegin = Button(textureName: "buttonSmall", text: "Begin",  x: 29, y: 85)
            self.addChild(self.buttonBegin!)
            
            self.buttonUpgrade = Button(textureName: "buttonSmall", text: "Upgrade",  x: 144, y: 85)
            self.addChild(self.buttonUpgrade!)
        }
        
    }
    
    func update(currentTime: NSTimeInterval) {
        
        if ((currentTime - self.lastUpdate) > 1) {
            self.lastUpdate = currentTime
            
            
            if (self.needUpdate) {
                if (self.missionSpaceship.missionType >= 0) {
                    
                    let mission = MissionSpaceship.types[self.missionSpaceship.missionType]
                    let time = GameMath.MissionFinishTime(self.missionSpaceship.missionStartDate! , missionTime: mission.duration)
                    
                    
                    if (time > 0) {
                        self.labelDescription.setText("Remaining Time: " + GameMath.timeFormated(time))
                    } else  {
                        self.needUpdate = false
                        if let missionspaceshipData = self.missionSpaceship.missionspaceshipData {
                            
                            
                            self.buttonSpeedUp?.removeFromParent()
                            
                            if let buttonColect = self.buttonColect {
                                buttonColect.removeFromParent()
                            }
                            
                            self.buttonColect = Button(textureName: "buttonSmall", text: "Colect",  x: 86, y: 85)
                            self.addChild(self.buttonColect!)
                            self.labelDescription.setText("Mission finished")
                            
                        }
                    }
                    
                } else {
                    self.needUpdate = false
                }
   
            }
        }
    }
    
    func upgrade() -> Bool {
        
        if self.playerData.points.integerValue >= 2000 {
            self.missionSpaceship.level = self.missionSpaceship.level + 1
            self.missionSpaceship.missionspaceshipData?.level = NSNumber(integer: (self.missionSpaceship.missionspaceshipData?.level.integerValue)! + 1)
            self.playerData.points = NSNumber(integer: self.playerData.points.integerValue - 2000)
            self.labelLevel.setText(self.missionSpaceship.level.description)
            
            self.spaceShipImage.removeFromParent()
            self.spaceShipImage = Control(textureName: "MissionSpaceship" + self.missionSpaceship.level.description)
            self.addChild(self.spaceShipImage)
            self.spaceShipImage.screenPosition = CGPoint(x: 21, y: 41)
            self.spaceShipImage.resetPosition()
            
            if self.missionSpaceship.level == 4 {
                self.buttonUpgrade?.removeFromParent()
            }
            
            return true
            
        }
        
        return false
    }
}
