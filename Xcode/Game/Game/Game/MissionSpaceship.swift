//
//  MissionSpaceship.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 01/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MissionSpaceship: Control {
    
    var missionType:Int = -1
    var level:Int!
    var missionspaceshipData:MissionSpaceshipData?
    var missionStartDate:NSDate?
    
    
    init(missionSpaceshipData:MissionSpaceshipData) {
        
        super.init()
        self.missionspaceshipData = missionSpaceshipData
        self.level = missionSpaceshipData.level.integerValue
        
        if missionSpaceshipData.missionType.integerValue >= 0 {
            self.missionType = missionSpaceshipData.missionType.integerValue
            self.missionStartDate = missionSpaceshipData.startMissionDate
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class MissionType {
    
    var duration: Int
    var xpBonus: Int
    var pointsBonus: Int
    var index: Int
    var minHangarLevel: Int
    var diamondChance: Int
    
    init(index: Int, minHangarLevel: Int, duration: Int, xpBonus: Int, pointsBonus: Int, diamondChance: Int) {
        
        self.index = index
        self.minHangarLevel = minHangarLevel
        self.duration = duration
        self.xpBonus = xpBonus
        self.pointsBonus = pointsBonus
        self.diamondChance = diamondChance
        
    }
    
}


extension MissionSpaceship {
    
    static var types:[MissionType] = [
    
        {
            let missionSpaceShipType = MissionType(index: 0, minHangarLevel: 1, duration: 30, xpBonus: 50, pointsBonus: 50, diamondChance: 0)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 1, minHangarLevel: 1, duration: 300, xpBonus: 200, pointsBonus: 400, diamondChance: 1)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 2, minHangarLevel: 2, duration: 1800, xpBonus: 1000, pointsBonus: 2000, diamondChance: 2)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 3, minHangarLevel: 2, duration: 3600, xpBonus: 1500, pointsBonus: 3500, diamondChance: 5)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 4, minHangarLevel: 3, duration: 7200, xpBonus: 2000, pointsBonus: 5000, diamondChance: 10)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 5, minHangarLevel: 3, duration: 14400, xpBonus: 3000, pointsBonus: 7500, diamondChance: 15)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 6, minHangarLevel: 4, duration: 28800, xpBonus: 5000, pointsBonus: 12000, diamondChance: 20)
            return missionSpaceShipType
        }(),
        
        {
            let missionSpaceShipType = MissionType(index: 7, minHangarLevel: 4, duration: 86400, xpBonus: 10000, pointsBonus: 24000, diamondChance: 25)
            return missionSpaceShipType
        }(),
    
    ]
}
