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
        
        super.init()
        
        self.missionSpaceship = missionSpaceship
        self.missionType = MissionSpaceship.types[index]
        self.addChild(Control(textureName: "missionTypeCard"))
        self.addChild(Label(color:SKColor.whiteColor() ,text: "XP:" + missionType.xpBonus.description + " P:" + missionType.pointsBonus.description + " T:" + GameMath.timeFormated(missionType.duration) , x: 15, y: 17, horizontalAlignmentMode: .Left))
        
        self.buttonSelect = Button(textureName: "buttonSelectMission", text: "", x: 219, y: 9)
        self.addChild(self.buttonSelect)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectMission() {
        if let missionSpaceshipData = self.missionSpaceship.missionspaceshipData {
            missionSpaceshipData.startMissionDate = NSDate()
            missionSpaceshipData.missionType = NSNumber(integer: missionType.index)
        }
        
    }
    

}