//
//  Research.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 05/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Research: Control {
    
    var researchType:ResearchType
    var researchData:ResearchData
    
    init(researchData:ResearchData) {
        self.researchData = researchData
        self.researchType = Research.types[researchData.type.integerValue]
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isUnlocked() -> Bool {
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        for item in self.researchType.researchesNeeded {
            for subItem in playerData.researches {
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
    
    func forceStart() {
        self.researchData.startDate = NSDate()
    }
    
    static func canStart() -> Bool {
        
         let playerData = MemoryCard.sharedInstance.playerData
        
        for research in playerData.researches {
            let researchData = research as! ResearchData
            if researchData.startDate != nil && researchData.done == false {
                return false
            }
        }
        
        return true
    }
    
    func collect() {
        
        self.researchData.startDate = nil
        self.researchData.done = true
        
        // se o level da nave for 0 ta liberando, se nao aumentando o level maximo
        
        self.researchData.spaceshipLevel = NSNumber(integer: self.researchData.spaceshipLevel.integerValue + 10)
        
        if self.researchData.spaceshipLevel.integerValue == 10 {
            
            if let spaceship = self.researchType.spaceshipUnlocked {
                
                if let weapon = self.researchType.weaponUnlocked {
                    let weaponData = MemoryCard.sharedInstance.newWeaponData(type: weapon)
                    
                    let spaceshipData = MemoryCard.sharedInstance.newSpaceshipData(type: spaceship)
                    spaceshipData.addWeaponData(weaponData)
                    spaceshipData
                    
                    MemoryCard.sharedInstance.playerData.unlockSpaceshipData(spaceshipData)
                }
            }
        }
    }
    
    
    static func unlockRandomResearch() -> ResearchData? {
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        var needNewResearch = true
        
        for item in playerData.researches {
            if let researchData = item as? ResearchData {
                if researchData.spaceshipLevel != researchData.spaceshipMaxLevel {
                    needNewResearch = false
                    break
                }
            }
        }
        
        var winSpaceship = 0
        
        if needNewResearch {
            winSpaceship = 100
        } else {
            winSpaceship = Int.random(101)
        }
        
        // Chance de ganhar uma pesquisa >=90 ( 10% de chance)
        if (winSpaceship >= 75) {
            
            var researchTypes = [ResearchType]()
            
            let diceRoll = Int.random(101)
            
            // Commom <85 ( 85 % de chance de ser comum)
            if (diceRoll <= 100) {
                
                for researchType in Research.types {
                    let spaceshipType = Spaceship.types[researchType.spaceshipUnlocked!]
                    if spaceshipType.rarity == .common {
                        researchTypes.append(researchType)
                    }
                }
                
                let index = Int.random(researchTypes.count)
                
                for item in playerData.researches {
                    if let researchData = item as? ResearchData {
                        
                        if researchData.type.integerValue == researchTypes[index].index {
                            
                            researchData.spaceshipMaxLevel = researchData.spaceshipMaxLevel.integerValue + 10
                            
                            return researchData
                        }
                    }
                }
                
                let newResearch = MemoryCard.sharedInstance.newResearchData()
                newResearch.type = researchTypes[index].index
                playerData.addResearchData(newResearch)
                
                return newResearch
            }
            
            //            } else if (diceRoll <= 95) {
            //                print("rare")
            //            } else if (diceRoll <= 99) {
            //                print("epic")
            //            } else {
            //                print("legendary")
            //            }
        }
        
        return nil
        
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
    var researchesNeeded: [Int] = []
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
    
    static func cheatDuration() {
        for researchType in Research.types {
            researchType.duration = 3
        }
    }
    
    static func cheatUnlockAll() {
        
        MemoryCard.sharedInstance.playerData.researches = NSSet()
        
        for researchType in Research.types {
            let newResearch = MemoryCard.sharedInstance.newResearchData()
            newResearch.type = researchType.index
            newResearch.spaceshipLevel = 10
            newResearch.spaceshipMaxLevel = 1000
            MemoryCard.sharedInstance.playerData.addResearchData(newResearch)
        }
    }
    
    static var types:[ResearchType] = [
        
        {
            let research = ResearchType(index:0, name:"Intrepid Striker", duration:28800, cost:0, lineType: .general)
            research.researchDescription = "A common spaceship with a fast Striker."
            research.weaponUnlocked = 1
            research.spaceshipUnlocked = 0
            research.researchesNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:1, name:"Intrepid Destroyer", duration:43200, cost:0, lineType: .weapons)
            research.researchDescription = "A common spaceship with a powerfull and low range gun."
            research.weaponUnlocked = 2
            research.spaceshipUnlocked = 0
            research.researchesNeeded = [0]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:2, name:"Intrepid Sniper", duration:86400, cost:0, lineType: .weapons)
            research.researchDescription = "A common spaceship with a long range gun."
            research.weaponUnlocked = 3
            research.spaceshipUnlocked = 0
            research.researchesNeeded = [1]
            research.requisites = []
            return research
        }(),
        
        
        {
            let research = ResearchType(index:3, name:"Tanker Blaster", duration:14400, cost:0, lineType: .general)
            research.researchDescription = "A resistant spaceship with a common gun."
            research.weaponUnlocked = 0
            research.spaceshipUnlocked = 1
            research.researchesNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:4, name:"Tanker Striker", duration:28800, cost:0, lineType: .general)
            research.researchDescription = "A resistant spaceship with a fast Striker."
            research.weaponUnlocked = 1
            research.spaceshipUnlocked = 1
            research.researchesNeeded = [3]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:5, name:"Tanker Destroyer", duration:43200, cost:0, lineType: .weapons)
            research.researchDescription = "A resistante spaceship with a powerfull and low range gun."
            research.weaponUnlocked = 2
            research.spaceshipUnlocked = 1
            research.researchesNeeded = [4]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:6, name:"Tanker Sniper", duration:86400, cost:0, lineType: .weapons)
            research.researchDescription = "A resistant spaceship with a long range gun."
            research.weaponUnlocked = 3
            research.spaceshipUnlocked = 1
            research.researchesNeeded = [5]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:7, name:"Speedy Blaster", duration:14400, cost:0, lineType: .general)
            research.researchDescription = "A fast spaceship with a common gun."
            research.weaponUnlocked = 0
            research.spaceshipUnlocked = 2
            research.researchesNeeded = []
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:8, name:"Speedy Striker", duration:28800, cost:0, lineType: .general)
            research.researchDescription = "A fast spaceship with a fast Striker."
            research.weaponUnlocked = 1
            research.spaceshipUnlocked = 2
            research.researchesNeeded = [7]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:9, name:"Speedy Destroyer", duration:43200, cost:0, lineType: .weapons)
            research.researchDescription = "A fast spaceship with a powerfull and low range gun."
            research.weaponUnlocked = 2
            research.spaceshipUnlocked = 2
            research.researchesNeeded = [8]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:10, name:"Speedy Sniper", duration:86400, cost:0, lineType: .weapons)
            research.researchDescription = "A fast spaceship with a long range gun."
            research.weaponUnlocked = 3
            research.spaceshipUnlocked = 2
            research.researchesNeeded = [9]
            research.requisites = []
            return research
        }(),
        
        {
            let research = ResearchType(index:11, name:"Spaceship Blaster", duration:28800, cost:0, lineType: .general)
            research.researchDescription = ""
            research.weaponUnlocked = 0
            research.spaceshipUnlocked = 0
            research.researchesNeeded = [99]
            research.requisites = []
            return research
        }(),

    ]
}