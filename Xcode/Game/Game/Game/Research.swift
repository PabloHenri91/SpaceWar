//
//  Research.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 05/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Research: Control {
    
    var researchType:ResearchType!
    var researchData:ResearchData?
    var researchStartDate:NSDate?
    var researches = MemoryCard.sharedInstance.playerData.researches
    
    init(researchData:ResearchData) {
        self.researchData = researchData
        self.researchType = Research.types[researchData.type.integerValue]
        if researchData.startDate != nil {
            self.researchStartDate = researchData.startDate
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isUnlocked() -> Bool {
        
        for item in self.researchType.researchsNeeded {
            for subItem in self.researches {
                if let researchData = subItem as? ResearchData {
                    if researchData.type == item {
                        if researchData.done == 0 {
                            return false
                        }
                    }
                }
            }
        }
        
        
        return true
    }
    
    func start() -> Bool {
        
        
        for research in MemoryCard.sharedInstance.playerData.researches {
            let researchData = research as! ResearchData
            if ((researchData.startDate != nil) && (researchData.done == 0)) {
                return false
            }
        }
        
        
        if let researchData = self.researchData {
            researchData.startDate = NSDate()
        }
        
        return true
        
    }
    
    func colect() {
        self.researchStartDate = nil
        if let researchData = self.researchData {
            researchData.done = true
            
            if let weapon = self.researchType.weaponUnlocked {
                let weaponData = MemoryCard.sharedInstance.newWeaponData(type: weapon)
                MemoryCard.sharedInstance.playerData.addWeaponData(weaponData)
            }
            
            if let spaceship = self.researchType.spaceshipUnlocked {
                let spaceShipData = MemoryCard.sharedInstance.newSpaceshipData(type: spaceship)
                MemoryCard.sharedInstance.playerData.unlockSpaceshipData(spaceShipData)
            }
            
            MemoryCard.sharedInstance.playerData.motherShip.xp = NSNumber(integer: MemoryCard.sharedInstance.playerData.motherShip.xp.integerValue + Int(self.researchType.cost / 2))
        }
    }

}


public enum ResearchLineType:Int {
    case general
    case spaceships
    case weapons
    case spaceshipsImproves
    case weaponsImproves
    
}

class ResearchType {
    var index: Int!
    var name: String!
    var researchDescription: String!
    var duration: Int!
    var cost: Int!
    var lineType: ResearchLineType!
    var requisites: [String] = []
    var researchsNeeded: [Int] = []
    var weaponUnlocked: Int?
    var spaceshipUnlocked: Int?
    
    init(index:Int, name:String, duration:Int, cost: Int, lineType:ResearchLineType) {
        self.index = index
        self.name = name
        self.duration = duration
        self.cost = cost
        self.lineType = lineType
    }
    
}


extension Research {
    
    static var types:[ResearchType] = [
        {
            let research = ResearchType(index:0, name:"Weapons", duration:14400, cost:1000, lineType: .general)
            research.researchDescription = "Do this research to unlock weapons researchs."
            research.researchsNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:1, name:"Super machine-gun", duration:28800, cost:1000, lineType: .weapons)
            research.researchDescription = "You will unlock a weapon who have a large range and a fabulous fire rate, your enemies will be confused with so many shots."
            research.researchsNeeded = [0]
            research.weaponUnlocked = 1
            research.requisites = []
            return research
        }(),
        
        
        {
            let research = ResearchType(index:2, name:"Super shotgun", duration:28800, cost:1000, lineType: .weapons)
            research.researchDescription = "This research unlock a weapon who have the world's deadliest shot, however only accepts enemies within 1 meter of you."
            research.researchsNeeded = [0]
            research.weaponUnlocked = 2
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:3, name:"Super sniper", duration:28800, cost:1000, lineType: .weapons)
            research.researchDescription = "This research unlock a weapon that can shot the other side of the universe!"
            research.researchsNeeded = [0]
            research.weaponUnlocked = 3
            research.requisites = []
            return research
        }(),
        
        
        
        
        {
            let research = ResearchType(index:4, name:"Spaceships", duration:14400, cost:1000, lineType: .general)
            research.researchDescription = "Do this research to unlock weapons researchs."
            research.researchsNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:5, name:"Faster Spaceship", duration:28800, cost:1000, lineType: .spaceships)
            research.researchDescription = "This research will unlock a faster spaceship to buy in factory."
            research.researchsNeeded = [4]
            research.spaceshipUnlocked = 2
            research.requisites = []
            return research
        }(),
        
        
        {
            let research = ResearchType(index:6, name:"Tanker Spaceship", duration:28800, cost:1000, lineType: .spaceships)
            research.researchDescription = "This research will unlock a spaceship with a great amount of health."
            research.researchsNeeded = [4]
            research.spaceshipUnlocked = 1
            research.requisites = []
            return research
        }()
        
     
    
    ]
}