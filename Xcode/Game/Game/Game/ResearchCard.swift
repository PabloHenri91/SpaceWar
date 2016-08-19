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
    
    var labelTimeLeft: Label!
    var needUpdate = true
    var lastUpdate: NSTimeInterval = 0
    
    var buttonBegin: Button?
    var buttonSpeedUp: Button?
    var buttonCollect: Button?
    
    init?(research:Research) {
        
        var textureName = ""
        var spaceship:Spaceship?
        
        if let spaceshipUnlocked = research.researchType.spaceshipUnlocked {
            
            let spaceshipType = Spaceship.types[spaceshipUnlocked]
            
            switch spaceshipType.rarity {
            case .common:
                textureName = "researchCardCommon"
                break
            case .rare:
                textureName = "researchCardRare"
                break
            case .epic:
                textureName = "researchCardEpic"
                break
            case .legendary:
                textureName = "researchCardLegendary"
                break
            }
            
            if let weaponUnlocked = research.researchType.weaponUnlocked {
                spaceship = Spaceship(type: spaceshipUnlocked, level: 1)
                let weapon = Weapon(type: weaponUnlocked, level: 1)
                spaceship?.addWeapon(weapon)
                spaceship?.position = CGPoint(x:33, y: -33)
            }
        }
        
        super.init(textureName: textureName)
        
        if let spaceship = spaceship {
            self.addChild(spaceship)
        }
    
        let fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        
        self.research = research
   
        let researchType = self.research.researchType
        
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: researchType.name, fontSize: 12, x: 76, y: 22, fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        
        if self.research.researchData?.startDate != nil {
            
            let timeLeft = GameMath.timeLeft(startDate: self.research.researchData!.startDate!, duration: researchType.duration)
            
            if timeLeft > 0 {
                
                self.self.buttonSpeedUp = Button(textureName: "buttonGreen89x22", text: "SPEED UP", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
                self.addChild(self.self.buttonSpeedUp!)
                
                self.labelTimeLeft = Label(text: GameMath.timeFormated(timeLeft), fontSize: 12 , x: 125, y: 46)
                self.addChild(self.labelTimeLeft)
                
            } else {
                
                self.labelTimeLeft = Label(text: "FINISHED", fontSize: 12 , x: 125, y: 46)
                self.addChild(self.labelTimeLeft)
                
                self.buttonCollect = Button(textureName: "buttonGreen89x22", text: "COLLECT", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
                self.addChild(self.buttonCollect!)
            }
            
        } else {
            self.buttonBegin = Button(textureName: "buttonGray89x22", text: "BEGIN", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
            self.addChild(self.buttonBegin!)

            self.labelTimeLeft = Label(text: GameMath.timeFormated(self.research.researchType.duration), fontSize: 12 , x: 125, y: 46)
            self.addChild(self.labelTimeLeft)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentTime: NSTimeInterval) {
        
        if currentTime - self.lastUpdate > 1 {
            self.lastUpdate = currentTime

            if self.needUpdate {
                if self.research.researchData?.startDate != nil {
                    
                    let time = GameMath.timeLeft(startDate: self.research.researchData!.startDate! , duration: self.research.researchType.duration)
                    
                    if time > 0 {
                        self.labelTimeLeft.setText(GameMath.timeFormated(time))
                    } else {
                        self.needUpdate = false
                        
                        if let buttonSpeedUp = self.buttonSpeedUp {
                            buttonSpeedUp.removeFromParent()
                            self.buttonSpeedUp = nil
                        }
                        
                        if let buttonBegin = self.buttonBegin {
                            buttonBegin.removeFromParent()
                            self.buttonBegin = nil
                        }
        
                        if let buttonCollect = self.buttonCollect {
                            buttonCollect.removeFromParent()
                            self.buttonCollect = nil
                        }
                        
                        let fontColor = SKColor.whiteColor()
                        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
                        let fontShadowOffset = CGPoint(x: 0, y: -1)
                        let fontName = GameFonts.fontName.museo1000
                        
                        self.buttonCollect = Button(textureName: "buttonGreen89x22", text: "COLLECT", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
                        self.addChild(self.buttonCollect!)
                        
                        self.labelTimeLeft.setText("FINISHED")
                    }
                    
                } else {
                    self.needUpdate = false
                }
            }
        }
    }
}
                
        