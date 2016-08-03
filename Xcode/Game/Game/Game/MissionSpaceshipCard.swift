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
    var spaceshipImage: Control!
    var buttonBegin: Button?
    var buttonSpeedUp: Button?
    var buttonColect: Button?
    var buttonUpgrade: Button?
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    var needUpdate: Bool = true
    var timeBar: TimeBar?
    
    
    var lastUpdate:NSTimeInterval = 0
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    init(missionSpaceship:MissionSpaceship) {
        
        super.init()
        
        self.addChild(Control(textureName: "MissionSpaceshipCard"))
        
        self.missionSpaceship = missionSpaceship
        self.spaceshipImage = Control(textureName: "missionSpaceship", x: 7, y: 39)
        self.addChild(self.spaceshipImage)

        
        self.labelLevel = Label(text: String(self.missionSpaceship.level) , fontSize: 11, x: 259, y: 16, shadowColor: SKColor(red: 229/255, green: 228/255, blue: 229/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelLevel)
        
        self.labelName = Label(color:SKColor.whiteColor() ,text: "MINING SPACESHIP" , fontSize: 13, x: 12, y: 17, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelName)
        
        
        if (Int(self.missionSpaceship.missionspaceshipData!.missionType.intValue) >= 0) {
            
            
            
            let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.intValue)]
            let time = GameMath.missionFinishTime(self.missionSpaceship.missionspaceshipData!.startMissionDate! , missionTime: mission.duration)
            
            if (time > 0) {
                
                self.buttonSpeedUp = Button(textureName: "buttonGreen", text: "SPEEDUP", fontSize: 10, x: 97, y: 88, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonSpeedUp!)
                
                self.timeBar = TimeBar(x: 97, y: 50)
                self.addChild(self.timeBar!.cropNode)
                
                
            } else {
                
                self.buttonColect = Button(textureName: "buttonGreen", text: "COLLECT", fontSize: 10, x: 97, y: 88 , fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonColect!)
                
                self.timeBar = TimeBar(x: 97, y: 50)
                self.addChild(self.timeBar!.cropNode)
            }
            
            
        } else {
            
            self.labelDescription = Label(text: "No mining now.", fontSize: 11 , x: 97, y: 60, horizontalAlignmentMode: .Left, fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDescription)
            
            self.buttonBegin = Button(textureName: "buttonBlue", text: "BEGIN",  fontSize: 10,  x: 97, y: 79, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 42/255, green: 121/255, blue: 146/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.buttonBegin!)
            
            
            if self.missionSpaceship.level < 4 {
                self.buttonUpgrade = Button(textureName: "buttonGray", text: "UPGRADE", fontSize: 10 ,  x: 175, y: 79 , fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonUpgrade!)
            }
            
            
        }
    
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func colect() {
        
        if let missionspaceshipData = self.missionSpaceship.missionspaceshipData {
            
            self.needUpdate = false
            
            let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.intValue)]
            
            missionspaceshipData.missionType = NSNumber(integer: -1)
            self.missionSpaceship.missionType = -1
            
            self.playerData.points = NSNumber(integer: self.playerData.points.integerValue + mission.pointsBonus)
            self.playerData.motherShip.xp = NSNumber(integer: self.playerData.motherShip.xp.integerValue + mission.xpBonus)

            
            self.buttonColect!.removeFromParent()
            self.buttonColect = nil
            
            self.timeBar?.cropNode.removeFromParent()
            
            
            self.labelDescription?.removeFromParent()
            self.labelDescription = Label(text: "No mining now.", fontSize: 11 , x: 97, y: 60, horizontalAlignmentMode: .Left, fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDescription)
            
            self.buttonBegin = Button(textureName: "buttonBlue", text: "BEGIN",  fontSize: 10,  x: 97, y: 79, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 42/255, green: 121/255, blue: 146/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.buttonBegin!)
            
            
            if self.missionSpaceship.level < 4 {
                self.buttonUpgrade = Button(textureName: "buttonGray", text: "UPGRADE", fontSize: 10 ,  x: 175, y: 79 , fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonUpgrade!)
            }
        }
        
    }
    
    func update(currentTime: NSTimeInterval) {
        
        if ((currentTime - self.lastUpdate) > 1) {
            self.lastUpdate = currentTime
            
            
            if (self.needUpdate) {
                if (self.missionSpaceship.missionspaceshipData?.missionType.intValue >= 0) {
                    
                    let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.intValue)]
                    let time = GameMath.missionFinishTime(self.missionSpaceship.missionspaceshipData!.startMissionDate! , missionTime: mission.duration)
                    
                    
                    if (time > 0) {
                        if let timer = self.timeBar {
                            timer.update(self.missionSpaceship)
                        }
                       
                    } else  {
                        self.needUpdate = false
                        if let missionspaceshipData = self.missionSpaceship.missionspaceshipData {
                            
                            
                            self.buttonSpeedUp?.removeFromParent()
                            self.buttonColect?.removeFromParent()
                          
                            self.buttonColect = Button(textureName: "buttonGreen", text: "COLLECT", fontSize: 10, x: 97, y: 88 , fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                            self.addChild(self.buttonColect!)
                            if let timer = self.timeBar {
                                timer.update(self.missionSpaceship)
                            }
                            
                        }
                    }
                    
                } else {
                    self.needUpdate = false
                }
   
            } else {
                if (self.missionSpaceship.missionspaceshipData!.missionType.intValue >= 0) {
                    
                    let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.intValue)]
                    let time = GameMath.missionFinishTime(self.missionSpaceship.missionspaceshipData!.startMissionDate! , missionTime: mission.duration)
                    
                    if (time > 0) {
                        
                        self.needUpdate = true
                        
                        self.buttonBegin?.removeFromParent()
                        self.buttonUpgrade?.removeFromParent()
                        
                        self.buttonBegin = nil
                        self.buttonUpgrade = nil
    
                        self.buttonSpeedUp = Button(textureName: "buttonGreen", text: "SPEEDUP", fontSize: 10, x: 97, y: 88, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                        self.addChild(self.buttonSpeedUp!)
                        
                        self.timeBar = TimeBar(x: 97, y: 50)
                        self.addChild(self.timeBar!.cropNode)
                        
                        if let timer = self.timeBar {
                            timer.update(self.missionSpaceship)
                        }
                        
                    }

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
            
            self.spaceshipImage.removeFromParent()
            self.spaceshipImage = Control(textureName: "missionSpaceship", x: 7, y: 39)
            self.addChild(self.spaceshipImage)

            if self.missionSpaceship.level == 4 {
                self.buttonUpgrade?.removeFromParent()
                self.buttonUpgrade = nil
            }
            
            return true
            
        }
        
        return false
    }
}
