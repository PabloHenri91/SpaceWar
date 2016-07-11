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
                MemoryCard.sharedInstance.playerData.addWeaponData(weapon)
            }
            
            if let spaceship = self.researchType.spaceshipUnlocked {
                MemoryCard.sharedInstance.playerData.addSpaceshipData(spaceship)
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
    var weaponUnlocked: WeaponData?
    var spaceshipUnlocked: SpaceshipData?
    
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
            let research = ResearchType(index:0, name:"Super Mega Weapon", duration:120, cost:1000, lineType: .weapons)
            research.researchDescription = "This research will unlock a Super Mega weapon, this powerfull weapon have a big range and can be used to kill anything."
            research.researchsNeeded = []
            research.requisites = ["Have 1 Super Weapon", "Play 10 times with a super weapon"]
            return research
        }(),
        
        {
            let research = ResearchType(index:1, name:"Super Mega Octblast Weapon", duration:1200, cost:10000, lineType: .weapons)
            research.researchDescription = "A evolved version of Super Mega Weapon, this weapon have a so powerfull tecnology that can destroy planets!!!"
            research.researchsNeeded = [0]
            research.requisites = ["Have 1 Super Weapon very cool", "Play 10 times with a super weapon", "Win 3 matchs using a super weapon"]
            return research
        }(),
        
        
        {
            let research = ResearchType(index:2, name:"Super Mega Spaceship", duration:240, cost:2000, lineType: .spaceships)
            research.researchDescription = "A very cool spaceship, you will win if research this, shut up and give me your money."
            research.researchsNeeded = []
            research.requisites = []
            return research
        }()
    
    ]
}