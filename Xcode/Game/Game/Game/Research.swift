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
    var researches = MemoryCard.sharedInstance.playerData.researches
    
    init(researchData:ResearchData) {
        self.researchData = researchData
        self.researchType = Research.types[researchData.type.integerValue]
        
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
        self.researchData?.startDate = nil
        if let researchData = self.researchData {
            researchData.done = true
            
            
            
            if let spaceship = self.researchType.spaceshipUnlocked {
                
                if let weapon = self.researchType.weaponUnlocked {
                    let weaponData = MemoryCard.sharedInstance.newWeaponData(type: weapon)
                    
                    let spaceShipData = MemoryCard.sharedInstance.newSpaceshipData(type: spaceship)
                    spaceShipData.addWeaponData(weaponData)
                    spaceShipData
                    MemoryCard.sharedInstance.playerData.unlockSpaceshipData(spaceShipData)
                }
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
            let research = ResearchType(index:0, name:"Spaceship with machine gun", duration:28800, cost:0, lineType: .general)
            research.researchDescription = "A commom spaceship with a fast machine gun."
            research.weaponUnlocked = 1
            research.spaceshipUnlocked = 0
            research.researchsNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:1, name:"Spaceship with shotgun", duration:43200, cost:0, lineType: .weapons)
            research.researchDescription = "A commom spaceship with a powerfull and low range gun."
            research.weaponUnlocked = 2
            research.spaceshipUnlocked = 0
            research.researchsNeeded = [0]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:2, name:"Spaceship with sniper rifle", duration:86400, cost:0, lineType: .weapons)
            research.researchDescription = "A commom spaceship with a long range gun."
            research.weaponUnlocked = 3
            research.spaceshipUnlocked = 0
            research.researchsNeeded = [1]
            research.requisites = []
            return research
        }(),
        
        
        {
            let research = ResearchType(index:3, name:"Space tanker with pistol", duration:14400, cost:0, lineType: .general)
            research.researchDescription = "A resistant spaceship with a commom gun."
            research.weaponUnlocked = 0
            research.spaceshipUnlocked = 1
            research.researchsNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:4, name:"Space tanker with machine gun", duration:28800, cost:0, lineType: .general)
            research.researchDescription = "A resistant spaceship with a fast machine gun."
            research.weaponUnlocked = 1
            research.spaceshipUnlocked = 1
            research.researchsNeeded = [3]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:5, name:"Space tanker with shotgun", duration:43200, cost:0, lineType: .weapons)
            research.researchDescription = "A resistante spaceship with a powerfull and low range gun."
            research.weaponUnlocked = 2
            research.spaceshipUnlocked = 1
            research.researchsNeeded = [4]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:6, name:"Space tanker with sniper rifle", duration:86400, cost:0, lineType: .weapons)
            research.researchDescription = "A resistant spaceship with a long range gun."
            research.weaponUnlocked = 3
            research.spaceshipUnlocked = 1
            research.researchsNeeded = [5]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:7, name:"Space speeder with pistol", duration:14400, cost:0, lineType: .general)
            research.researchDescription = "A fast spaceship with a commom gun."
            research.weaponUnlocked = 0
            research.spaceshipUnlocked = 2
            research.researchsNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:8, name:"Space speeder with machine gun", duration:28800, cost:0, lineType: .general)
            research.researchDescription = "A fast spaceship with a fast machine gun."
            research.weaponUnlocked = 1
            research.spaceshipUnlocked = 2
            research.researchsNeeded = [7]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:9, name:"Space speeder with shotgun", duration:43200, cost:0, lineType: .weapons)
            research.researchDescription = "A fast spaceship with a powerfull and low range gun."
            research.weaponUnlocked = 2
            research.spaceshipUnlocked = 2
            research.researchsNeeded = [8]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:10, name:"Space speeder with sniper rifle", duration:86400, cost:0, lineType: .weapons)
            research.researchDescription = "A fast spaceship with a long range gun."
            research.weaponUnlocked = 3
            research.spaceshipUnlocked = 2
            research.researchsNeeded = [9]
            research.requisites = []
            return research
        }(),
        
        
    
        
     
    
    ]
}