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
    
    var spaceship:Spaceship?
    
    var timeBar:TimeBar!
    
    init?(research:Research) {
        
        var textureName = ""
        
        if let spaceshipUnlockedIndex = research.researchType.spaceshipUnlockedIndex {
            
            let spaceshipType = Spaceship.types[spaceshipUnlockedIndex]
            
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
            
            self.spaceship = Spaceship(type: spaceshipType.index, level: 1)
            self.spaceship?.position = CGPoint(x:33, y: -33)
        }
        
        super.init(textureName: textureName)
        
        if let spaceship = self.spaceship {
            
            spaceship.setScale(min(55/spaceship.size.width, (self.size.height-10)/spaceship.size.height))
            if spaceship.xScale > 2 {
                spaceship.setScale(2)
            }
            
            self.addChild(spaceship)
        }
    
        let fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        
        self.research = research
   
        let researchType = self.research.researchType
        
        var text = researchType.name
        
        let level = self.research.researchData.spaceshipLevel.integerValue
        if  level == 0 {
             text = "Unlock " + text
        } else {
            text = text + " Improvement " + (level/10).description
        }
        
        self.addChild(Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: text, fontSize: 12, x: 76, y: 22, fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 1), shadowOffset: CGPoint(x: 0, y: -2)))
        
        self.timeBar = TimeBar(textureName: "timeBarResearchCard", x: 78, y: 31, loadLabel: false, type: TimeBar.types.researchTimer, loadBorder: false)
        self.addChild(self.timeBar!.cropNode)
        self.addChild(Control(textureName: "timeBarResearchCardBorder", x: 77, y: 30))
        
        self.labelTimeLeft = Label(color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), text: "???", fontSize: 11, x: 126, y: 44, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), shadowOffset: CGPoint(x: 0, y: -1))
        self.addChild(self.labelTimeLeft)
        
        if let startDate = self.research.researchData.startDate {
            
            self.timeBar.update(startDate: startDate, duration: self.research.researchType.duration)
            
            let timeLeft = GameMath.timeLeft(startDate, duration: researchType.duration)
            
            if timeLeft > 0 {
                
                self.buttonSpeedUp = Button(textureName: "buttonGreen89x22", text: "SPEED UP", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
                self.addChild(self.buttonSpeedUp!)
                
                self.labelTimeLeft.setText(GameMath.timeLeftFormattedAbbreviated(timeLeft))
                
            } else {
                
                self.labelTimeLeft.setText("FINISHED")
                
                self.buttonCollect = Button(textureName: "buttonGreen89x22", text: "COLLECT", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
                self.addChild(self.buttonCollect!)
            }
            
        } else {
            self.buttonBegin = Button(textureName: "buttonGreen89x22", text: "BEGIN", fontSize: 13, x: 182, y: 35, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
            self.addChild(self.buttonBegin!)

            self.labelTimeLeft.setText(GameMath.timeLeftFormattedAbbreviated(self.research.researchType.duration))
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentTime: NSTimeInterval) {
        
        if currentTime - self.lastUpdate > 1 {
            self.lastUpdate = currentTime

            if self.needUpdate {
                if self.research.researchData.startDate != nil {
                    
                    let time = GameMath.timeLeft(self.research.researchData.startDate! , duration: self.research.researchType.duration)
                    
                    self.timeBar.update(startDate: self.research.researchData.startDate!, duration: self.research.researchType.duration)
                    
                    if time > 0 {
                        self.labelTimeLeft.setText(GameMath.timeLeftFormattedAbbreviated(time))
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
                
        