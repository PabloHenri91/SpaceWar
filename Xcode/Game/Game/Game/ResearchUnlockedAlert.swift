//
//  ResearchUnlockedAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 01/09/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class ResearchUnlockedAlert:Box {
    
    var buttonCancel: Button!
    var buttonGoToResearch: Button!

    
    init(researchData:ResearchData) {
        
        var rarityColor:SKColor!
        
        let researchType = Research.types[researchData.type.intValue]
        
        if let spaceshipUnlocked = researchType.spaceshipUnlocked {
            
            let spaceshipType = Spaceship.types[spaceshipUnlocked]
            
            switch spaceshipType.rarity {
            case .common:
                rarityColor = SKColor(red: 63/255, green: 119/255, blue: 73/255, alpha: 1)
                break
            case .rare:
                rarityColor = SKColor(red: 164/255, green: 69/255, blue: 48/255, alpha: 1)
                break
            case .epic:
                rarityColor = SKColor(red: 65/255, green: 70/255, blue: 123/255, alpha: 1)
                break
            case .legendary:
                rarityColor = SKColor(red: 76/255, green: 60/255, blue: 77/255, alpha: 1)
                break
            }
            
        }
        
        super.init(textureName: "researchUnlockedCard")
        self.zPosition = 10000000
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 246, y: 10,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
            })
        
        let labelTitle = Label(color: SKColor.white, text: "RESEARCH UNLOCKED", fontSize: 12 ,  x: 14, y: 21, horizontalAlignmentMode: .left , fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
        self.addChild(labelTitle)
        
        let labelGreat = Label(color: SKColor.black, text: "Great!", fontSize: 14 ,  x: 141, y: 66, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
        self.addChild(labelGreat)
        
        let labelUnlocked = Label(color: SKColor.black, text: "You unlocked a new research:", fontSize: 11 ,  x: 141, y: 81, fontName: GameFonts.fontName.museo500, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
        self.addChild(labelUnlocked)
        
        
       
        
        if researchData.spaceshipMaxLevel == 10 {
            
             let labelResearch = Label(color: rarityColor, text: researchType.name + "!", fontSize: 11 ,  x: 0, y: 104, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
            
            let labelResearchDescription = Label(color: SKColor.black, text: "Unlock ", fontSize: 11 ,  x: 0, y: 104, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
            
            let x = 141 - Int((labelResearch.calculateAccumulatedFrame().width + labelResearchDescription.calculateAccumulatedFrame().width)/2)
            
            
            self.addChild(labelResearchDescription)
            labelResearchDescription.screenPosition = CGPoint(x: x, y: 104)
            labelResearchDescription.resetPosition()
            
            self.addChild(labelResearch)
            labelResearch.screenPosition = CGPoint(x: labelResearchDescription.position.x + labelResearchDescription.calculateAccumulatedFrame().width, y: 104)
            labelResearch.resetPosition()
            
        }
        
        else {
            
            let labelResearch = Label(color: rarityColor, text: researchType.name, fontSize: 11 ,  x: 0, y: 104, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
            
            let improvementNumber = (researchData.spaceshipMaxLevel.intValue/10).description
            
            let labelResearchDescription = Label(color: SKColor.black, text: "improvement " + improvementNumber + "!", fontSize: 11 ,  x: 0, y: 104, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -1))
            
            let x = 141 - Int((labelResearch.calculateAccumulatedFrame().width + labelResearchDescription.calculateAccumulatedFrame().width)/2)
            
            
            self.addChild(labelResearch)
            labelResearch.screenPosition = CGPoint(x: x, y: 104)
            labelResearch.resetPosition()
            
            self.addChild(labelResearchDescription)
            labelResearchDescription.screenPosition = CGPoint(x: labelResearch.position.x + labelResearch.calculateAccumulatedFrame().width, y: 104)
            labelResearchDescription.resetPosition()
            
        }
        
        
        let fontShadowColor = SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 1)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.buttonGoToResearch = Button(textureName: "buttonDarkBlue131x30", text: "GO TO RESEARCHES", fontSize: 11, x: 77, y: 159, fontColor: SKColor.white, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonGoToResearch)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
