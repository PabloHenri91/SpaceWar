//
//  PlayerDataCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/26/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class PlayerDataCard: Control {
    
    var labelLevel:Label!
    var labelLevelShadow:Label!
    
    var labelXP:Label!
    var labelXPShadow:Label!
    
    var xpBarCircle:SKShapeNode!
    var xpBarSpriteNode:SKSpriteNode?

    override init() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        super.init(textureName: "playerDataCardBackground", x: -58, y: 0, xAlign: .center, yAlign: .up)
        
        let xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.integerValue)
        self.loadXPBar(xp: playerData.motherShip.xp.integerValue, xpForNextLevel: xpForNextLevel)
        self.loadLabelXP(playerData.motherShip.xp.description + "/" + xpForNextLevel.description)
        
        
        self.addChild(Control(textureName: "playerDataCardBackground1", x: 166, y: 14))
        
        self.loadLabelLevel(playerData.motherShip.level.description)
        
        self.loadResourcesLabels(playerData.points.integerValue, premiumPoints: playerData.premiumPoints.integerValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadResourcesLabels(points:Int, premiumPoints:Int) {
        let labelFontName = GameFonts.fontName.museo500
        let valueFontName = GameFonts.fontName.museo1000
        let fontSize = CGFloat(9)
        let pointsColor = SKColor(red: 45/255, green: 195/255, blue: 245/255, alpha: 1)
        let premiumPointsColor = SKColor(red: 255/255, green: 162/255, blue: 87/255, alpha: 1)
        
        let labelPointsLabelPosition = CGPoint(x: 298, y: 27)
        let labelPointsValuePosition = CGPoint(x: 300, y: 27)
        
        let labelPremiumPointsLabelPosition = CGPoint(x: 299, y: 41)
        let labelPremiumPointsValuePosition = CGPoint(x: 300, y: 41)
        
        self.addChild(Label(color: pointsColor, text: "F$", fontSize: fontSize, x: Int(labelPointsLabelPosition.x), y: Int(labelPointsLabelPosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Right, fontName: labelFontName))
        
        self.addChild(Label(color: pointsColor, text: points.description, fontSize: fontSize, x: Int(labelPointsValuePosition.x), y: Int(labelPointsValuePosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Left, fontName: valueFontName))
        
        self.addChild(Label(color: premiumPointsColor, text: "D$", fontSize: fontSize, x: Int(labelPremiumPointsLabelPosition.x), y: Int(labelPremiumPointsLabelPosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Right, fontName: labelFontName))
        
        self.addChild(Label(color: premiumPointsColor, text: premiumPoints.description, fontSize: fontSize, x: Int(labelPremiumPointsValuePosition.x), y: Int(labelPremiumPointsValuePosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Left, fontName: valueFontName))
    }
    
    func loadLabelLevel(text:String) {
        let fontName = GameFonts.fontName.museo1000
        let positionX = 217
        let positionY = 35
        let fontSize = CGFloat(14)
        let color = SKColor(red: 60/255, green: 75/255, blue: 88/255, alpha: 1)
        let shadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 8/100)
        
        self.labelLevel = Label(color: color, text: text, fontSize: fontSize, x: positionX, y: positionY, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.labelLevelShadow = Label(color: shadowColor, text: text, fontSize: fontSize, x: positionX, y: positionY + 1, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.addChild(self.labelLevelShadow)
        self.addChild(self.labelLevel)
    }
    
    func loadLabelXP(text:String) {
        let fontName = GameFonts.fontName.museo1000
        let positionX = 114
        let positionY = 35
        let fontSize = CGFloat(9)
        let color = SKColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let shadowColor = SKColor(red: 28/255, green: 112/255, blue: 141/255, alpha: 100/100)
        
        self.labelXP = Label(color: color, text: text, fontSize: fontSize, x: positionX, y: positionY, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.labelXPShadow = Label(color: shadowColor, text: text, fontSize: fontSize, x: positionX, y: positionY +  1, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.addChild(self.labelXPShadow)
        self.addChild(self.labelXP)
    }
    
    func loadXPBar(xp xp:Int, xpForNextLevel:Int) {
        
        let color = SKColor(red: 45/255, green: 195/255, blue: 245/255, alpha: 1)
        let width:CGFloat = 103 * (CGFloat(xp)/CGFloat(xpForNextLevel))
        let height:CGFloat = 17
        let positionX:CGFloat = 166
        let positionY:CGFloat = -26
        
        self.xpBarCircle = SKShapeNode(circleOfRadius: CGFloat(height/2))
        self.xpBarCircle.fillColor = color
        self.xpBarCircle.strokeColor = SKColor.clearColor()
        self.xpBarCircle.position = CGPoint(x: (positionX - width) + (height/2), y: positionY - (height/2))
        
        if width > height/2 {
            let anchorPoint = CGPoint(x: 1, y: 1)
            self.xpBarSpriteNode = SKSpriteNode(texture: nil, color: color, size: CGSize(width: width - (height/2), height: height))
            self.xpBarSpriteNode!.anchorPoint = anchorPoint
            self.xpBarSpriteNode!.position = CGPoint(x: positionX, y: positionY)
            self.addChild(self.xpBarSpriteNode!)
        }
        
        self.addChild(self.xpBarCircle)
    }
}
