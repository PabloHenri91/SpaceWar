//
//  MissionSpaceshipCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 04/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MissionSpaceshipCard: Control {
    
    var missionSpaceship: MissionSpaceship!
    var spaceshipImage: Control!
    var buttonBegin: Button?
    var buttonSpeedUp: Button?
    var buttonCollect: Button?
    var buttonUpgrade: Button?
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    var needUpdate: Bool = true
    var timeBar: TimeBar?
    
    
    var lastUpdate:TimeInterval = 0
    
    init(missionSpaceship:MissionSpaceship) {
        
        super.init()
        
        self.addChild(Control(textureName: "MissionSpaceshipCard"))
        
        self.missionSpaceship = missionSpaceship
        self.spaceshipImage = Control(textureName: "missionSpaceship", x: 7, y: 39)
        self.addChild(self.spaceshipImage)

        
        self.labelLevel = Label(text: String(self.missionSpaceship.level) , fontSize: 11, x: 259, y: 16, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 229/255, green: 228/255, blue: 229/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1))
        self.addChild(self.labelLevel)
        
        self.labelName = Label(color:SKColor.white ,text: "MINING SPACESHIP" , fontSize: 13, x: 12, y: 17, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 30/255, green: 39/255, blue: 47/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1))
        self.addChild(self.labelName)
        
        
        if self.missionSpaceship.missionspaceshipData!.missionType.intValue >= 0 {
            
            
            
            let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.int32Value)]
            let time = GameMath.timeLeft(startDate: self.missionSpaceship.missionspaceshipData!.startMissionDate!, duration: mission.duration)
            
            if time > 0 {
                
                self.buttonSpeedUp = Button(textureName: "buttonGreen", text: "SPEED UP", fontSize: 11, x: 97, y: 88, fontColor: SKColor.white, fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonSpeedUp!)
                
                self.timeBar = TimeBar(x: 97, y: 50, type: TimeBar.types.missionSpaceshipTimer)
                self.addChild(self.timeBar!.cropNode)
                
                
            } else {
                
                self.buttonCollect = Button(textureName: "buttonGreen", text: "COLLECT", fontSize: 11, x: 97, y: 88 , fontColor: SKColor.white, fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonCollect!)
                
                self.timeBar = TimeBar(x: 97, y: 50, type: TimeBar.types.missionSpaceshipTimer)
                self.addChild(self.timeBar!.cropNode)
            }
            
            
        } else {
            
            self.labelDescription = Label(text: "No mining now.", fontSize: 11 , x: 97, y: 60, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDescription)
            
            self.buttonBegin = Button(textureName: "buttonGreen", text: "BEGIN",  fontSize: 11,  x: 97, y: 79, fontColor: SKColor.white, fontShadowColor: SKColor(red: 42/255, green: 121/255, blue: 146/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.buttonBegin!)
            
            
            if self.missionSpaceship.level < 4 {
                self.buttonUpgrade = Button(textureName: "buttonBlue", text: "UPGRADE", fontSize: 11 ,  x: 175, y: 79 , fontColor: SKColor.white, fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonUpgrade!)
            }
            
            
        }
    
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collect() {
        
        if let missionspaceshipData = self.missionSpaceship.missionspaceshipData {
            
            let playerData = MemoryCard.sharedInstance.playerData!
            
            self.needUpdate = false
            
            let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.int32Value)]
            
            missionspaceshipData.missionType =  -1 as NSNumber
            self.missionSpaceship.missionType = -1
            
            playerData.points = (playerData.points.intValue + mission.pointsBonus) as NSNumber
            playerData.pointsSum = (playerData.pointsSum.intValue + mission.pointsBonus) as NSNumber
            
            
            let xpBonus = GameMath.applyXPBoosts(mission.xpBonus)
            playerData.motherShip.xp = (playerData.motherShip.xp.intValue + xpBonus) as NSNumber
            
            self.buttonCollect!.removeFromParent()
            self.buttonCollect = nil
            
            self.timeBar?.cropNode.removeFromParent()
            
            
            self.labelDescription?.removeFromParent()
            self.labelDescription = Label(text: "No mining now.", fontSize: 11 , x: 97, y: 60, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDescription)
            
            self.buttonBegin = Button(textureName: "buttonGreen", text: "BEGIN",  fontSize: 11,  x: 97, y: 79, fontColor: SKColor.white, fontShadowColor: SKColor(red: 42/255, green: 121/255, blue: 146/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.buttonBegin!)
            
            
            if self.missionSpaceship.level < 4 {
                self.buttonUpgrade = Button(textureName: "buttonBlue", text: "UPGRADE", fontSize: 11 ,  x: 175, y: 79 , fontColor: SKColor.white, fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonUpgrade!)
            }
            
            
            let labelFrags = Label(color: SKColor(red: 255/255, green: 162/255, blue: 87/255, alpha: 1), text: "+" + mission.pointsBonus.description, fontSize: 30, x: 220, y: Int(self.calculateAccumulatedFrame().height/2), fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 40/100), shadowOffset: CGPoint(x: 0, y: -1))

            self.addChild(labelFrags)
            
            let iconFragments = Control(textureName: "fragIcon", x: Int(labelFrags.calculateAccumulatedFrame().width/2 + labelFrags.screenPosition.x), y: Int(labelFrags.screenPosition.y - labelFrags.calculateAccumulatedFrame().height/2))
            iconFragments.setScale(2)
  
            self.addChild(iconFragments)
            
            let duration:Double = 1
            
            let action = SKAction.group([
                SKAction.move(by: CGVector(dx: 0, dy: 20), duration: duration),
                SKAction.fadeAlpha(to: 0, duration: duration),
                ])
            
            iconFragments.run(action, completion: {
                iconFragments.removeFromParent()
            }) 
            
            
            let particles = SKEmitterNode(fileNamed: "explosion.sks")!
            particles.particleTexture = SKTexture(imageNamed: "fragIcon")
            particles.alpha = 0.5
            particles.zPosition = 10000000
            particles.particleBlendMode = .alpha
            particles.numParticlesToEmit = 50
            particles.particleSpeedRange = 400
            particles.particlePositionRange = CGVector(dx: 20, dy: 20)
            particles.position = labelFrags.position
            self.addChild(particles)
            
            labelFrags.zPosition = particles.zPosition + 1
            iconFragments.zPosition = particles.zPosition + 1
            
            let partAction = SKAction()
            partAction.duration = 1
            
            particles.run(partAction, completion: { [weak particles] in
                particles?.removeFromParent()
                })
            
            
            labelFrags.run(action, completion: {
                labelFrags.removeFromParent()
                
                let labelXp = Label(color: SKColor(red: 45/255, green: 195/255, blue: 245/255, alpha: 1), text: "+" + mission.xpBonus.description, fontSize: 30, x: 220, y: Int(self.calculateAccumulatedFrame().height/2), fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 40/100), shadowOffset: CGPoint(x: 0, y: -1))
                
                self.addChild(labelXp)
                
                let iconXp = Control(textureName: "xpIcon", x: Int(labelXp.calculateAccumulatedFrame().width/2 + labelXp.screenPosition.x), y: Int(labelXp.screenPosition.y - labelXp.calculateAccumulatedFrame().height/2))
                iconXp.setScale(2)
                self.addChild(iconXp)
                
                let particles = SKEmitterNode(fileNamed: "explosion.sks")!
                particles.particleTexture = SKTexture(imageNamed: "xpIcon")
                particles.alpha = 0.5
                particles.zPosition = 10000000
                particles.particleBlendMode = .alpha
                particles.numParticlesToEmit = 50
                particles.particleSpeedRange = 400
                particles.particlePositionRange = CGVector(dx: 20, dy: 20)
                particles.position = labelXp.position
                self.addChild(particles)
                
                labelFrags.zPosition = particles.zPosition + 1
                iconFragments.zPosition = particles.zPosition + 1
                
                let partAction = SKAction()
                partAction.duration = 1
                
                particles.run(partAction, completion: { [weak particles] in
                    particles?.removeFromParent()
                    })
                
                iconXp.run(action, completion: {
                    iconXp.removeFromParent()
                }) 
                
                labelXp.run(action, completion: {
                    labelXp.removeFromParent()
                }) 
            }) 
            
        }
        
    }
    
    func update(_ currentTime: TimeInterval) {
        
        if currentTime - self.lastUpdate > 1 {
            self.lastUpdate = currentTime
            
            
            if self.needUpdate {
                if self.missionSpaceship.missionspaceshipData?.missionType.int32Value >= 0 {
                    
                    let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.int32Value)]
                    let time = GameMath.timeLeft(startDate: self.missionSpaceship.missionspaceshipData!.startMissionDate!, duration: mission.duration)
                    
                    
                    if time > 0 {
                        if let timer = self.timeBar {
                            timer.update(self.missionSpaceship)
                        }
                       
                    } else  {
                        self.needUpdate = false
                        if let _ = self.missionSpaceship.missionspaceshipData {
                            self.buttonSpeedUp?.removeFromParent()
                            self.buttonSpeedUp = nil
                            self.buttonCollect?.removeFromParent()
                          
                            self.buttonCollect = Button(textureName: "buttonGreen", text: "COLLECT", fontSize: 11, x: 97, y: 88 , fontColor: SKColor.white, fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                            self.addChild(self.buttonCollect!)
                            if let timer = self.timeBar {
                                timer.update(self.missionSpaceship)
                            }
                        }
                    }
                    
                } else {
                    self.needUpdate = false
                }
   
            } else {
                if self.missionSpaceship.missionspaceshipData!.missionType.intValue >= 0 {
                    
                    let mission = MissionSpaceship.types[Int(self.missionSpaceship.missionspaceshipData!.missionType.int32Value)]
                    let time = GameMath.timeLeft(startDate: self.missionSpaceship.missionspaceshipData!.startMissionDate!, duration: mission.duration)
                    
                    if time > 0 {
                        
                        self.needUpdate = true
                        
                        self.buttonBegin?.removeFromParent()
                        self.buttonUpgrade?.removeFromParent()
                        
                        self.buttonBegin = nil
                        self.buttonUpgrade = nil
    
                        self.buttonSpeedUp = Button(textureName: "buttonGreen", text: "SPEED UP", fontSize: 10, x: 97, y: 88, fontColor: SKColor.white, fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                        self.addChild(self.buttonSpeedUp!)
                        
                        self.timeBar = TimeBar(x: 97, y: 50, type: TimeBar.types.missionSpaceshipTimer)
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
        
        let price = Int(2000 * pow(2, Double(self.missionSpaceship.level + 1)))
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        if playerData.points.intValue >= price {
            self.missionSpaceship.level = self.missionSpaceship.level + 1
            self.missionSpaceship.missionspaceshipData?.level = ((self.missionSpaceship.missionspaceshipData?.level.intValue)! + 1) as NSNumber
            playerData.points = (playerData.points.intValue - price) as NSNumber
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
