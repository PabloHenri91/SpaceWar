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
    var buttonUpgrade: Button?
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    
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
        
        if let mission = self.missionSpaceship.missionType {
            
            
        } else {
            
            self.labelDescription = Label(text: "No mission", fontSize: 8 , x: 62, y: 58, horizontalAlignmentMode: .Left)
            
            self.buttonBegin = Button(textureName: "buttonSmall", text: "Begin",  x: 29, y: 85)
            self.addChild(self.buttonBegin!)
            
            
            self.buttonUpgrade = Button(textureName: "buttonSmall", text: "Upgrade",  x: 144, y: 85)
            self.addChild(self.buttonUpgrade!)
        }
    
        
        self.addChild(self.labelDescription)
        
    }
    
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
