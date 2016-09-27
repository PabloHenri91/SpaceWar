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
    var level:Int = 1
    var missionspaceshipData:MissionSpaceshipData
    
    init(missionSpaceshipData:MissionSpaceshipData) {
        self.missionspaceshipData = missionSpaceshipData
        super.init()
        self.load(missionSpaceshipData.missionType.integerValue, level: missionSpaceshipData.level.integerValue)
    }
    
    func load(type:Int, level:Int) {
        self.level = level
        if type >= 0 {
            self.missionType = type
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
    var name = ""
    
    init(index: Int, minHangarLevel: Int, duration: Int, xpBonus: Int, pointsBonus: Int, diamondChance: Int) {
        
        self.index = index
        self.minHangarLevel = minHangarLevel
        self.duration = duration
        self.xpBonus = xpBonus
        self.pointsBonus = pointsBonus
        self.diamondChance = diamondChance
    }
}


class Mission {
    
    static func cheatDuration() {
        for missionType in Mission.types {
            missionType.duration = 3
        }
    }
    
    static var types:[MissionType] = [
    
        {
            let missionSpaceshipType = MissionType(index: 0, minHangarLevel: 1, duration: 30, xpBonus: 50, pointsBonus: 50, diamondChance: 0)
            missionSpaceshipType.name = "TINY ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 1, minHangarLevel: 1, duration: 300, xpBonus: 200, pointsBonus: 400, diamondChance: 1)
            missionSpaceshipType.name = "LITTLE ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 2, minHangarLevel: 2, duration: 1800, xpBonus: 1000, pointsBonus: 2000, diamondChance: 2)
            missionSpaceshipType.name = "MEDIUM ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 3, minHangarLevel: 2, duration: 3600, xpBonus: 1500, pointsBonus: 3500, diamondChance: 5)
            missionSpaceshipType.name = "BIG ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 4, minHangarLevel: 3, duration: 7200, xpBonus: 2000, pointsBonus: 5000, diamondChance: 10)
            missionSpaceshipType.name = "HUGE ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 5, minHangarLevel: 3, duration: 14400, xpBonus: 3000, pointsBonus: 7500, diamondChance: 15)
            missionSpaceshipType.name = "GIANT ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 6, minHangarLevel: 4, duration: 28800, xpBonus: 5000, pointsBonus: 12000, diamondChance: 20)
            missionSpaceshipType.name = "IMMENSE ASTEROID"
            return missionSpaceshipType
        }(),
        
        {
            let missionSpaceshipType = MissionType(index: 7, minHangarLevel: 4, duration: 86400, xpBonus: 10000, pointsBonus: 24000, diamondChance: 25)
            missionSpaceshipType.name = "COLOSSAL ASTEROID"
            return missionSpaceshipType
        }(),
    
    ]
}
