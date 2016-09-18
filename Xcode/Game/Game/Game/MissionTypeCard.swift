//
//  MissionTypeCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 04/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MissionTypeCard: Control {
    
    var missionType: MissionType!
    var missionSpaceship: MissionSpaceship!
    var buttonSelect: Button!
    
    init(missionSpaceship:MissionSpaceship, index:Int) {
        
        super.init(textureName: "asteroidTypeCard")
        self.missionSpaceship = missionSpaceship
        self.missionType = MissionSpaceship.types[index]
        
        let labelTitle = Label(text: missionType.name , fontSize: 10, x: 14, y: 9, xAlign: .left , verticalAlignmentMode: .top, horizontalAlignmentMode: .left,  fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100),  shadowOffset:CGPoint(x: 0, y: -2))
        self.addChild(labelTitle)
        
        let iconTime = Control(textureName: "timeIcon", x: 13, y: 26)
        self.addChild(iconTime)
        
        let labelTime = Label(text: GameMath.timeLeftFormatted(timeLeft: missionType.duration) , fontSize: 10, x: 30, y: 26, xAlign: .left , verticalAlignmentMode: .top, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100),  shadowOffset:CGPoint(x: 0, y: -2))
        self.addChild(labelTime)
        
        
        let iconXP = Control(textureName: "xpIcon", x: 87, y: 26)
        self.addChild(iconXP)
        
        let labelXP = Label(text: missionType.xpBonus.description , fontSize: 10, x: 103, y: 26, xAlign: .left , verticalAlignmentMode: .top, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100),  shadowOffset:CGPoint(x: 0, y: -2))
        self.addChild(labelXP)
        
        let iconFragments = Control(textureName: "fragIcon", x: 151, y: 26)
        self.addChild(iconFragments)
        
        let labelFragments = Label(text: missionType.pointsBonus.description , fontSize: 10, x: 167, y: 26, xAlign: .left , verticalAlignmentMode: .top, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100),  shadowOffset:CGPoint(x: 0, y: -2))
        self.addChild(labelFragments)
        
        
        let fontColor = SKColor.white
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.buttonSelect = Button(textureName: "buttonGreen66x21", text: "BEGIN", fontSize: 13, x: 207, y: 11, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonSelect)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectMission() {
        if let missionSpaceshipData = self.missionSpaceship.missionspaceshipData {
            missionSpaceshipData.startMissionDate = Date()
            missionSpaceshipData.missionType = missionType.index as NSNumber
        }
        
    }
    

}
