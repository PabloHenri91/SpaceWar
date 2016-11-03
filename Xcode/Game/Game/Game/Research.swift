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
        
        for item in playerData.researches {
            if let researchData = item as? ResearchData {
                if researchData.done == false {
                    return false
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
            
            if let spaceshipIndex = self.researchType.spaceshipUnlockedIndex {
                    
                    let spaceshipData = MemoryCard.sharedInstance.newSpaceshipData(type: spaceshipIndex)
                    
                    MemoryCard.sharedInstance.playerData.unlockSpaceshipData(spaceshipData)
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
                    let spaceshipType = Spaceship.types[researchType.spaceshipUnlockedIndex!]
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
            //                //print("rare")
            //            } else if (diceRoll <= 99) {
            //                //print("epic")
            //            } else {
            //                //print("legendary")
            //            }
        }
        
        return nil
        
    }
}

class ResearchType {
    
    var index: Int = -1
    var name: String = ""
    var researchDescription: String = ""
    var duration: Int = 0
    
    var spaceshipUnlockedIndex: Int?
    
    init(index:Int, name:String, duration:Int) {
        self.index = index
        self.name = name
        self.duration = duration
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
            newResearch.spaceshipLevel = 0
            newResearch.spaceshipMaxLevel = 1000
            MemoryCard.sharedInstance.playerData.addResearchData(newResearch)
        }
    }
    
    static var types: [ResearchType] = {
        
        var types = [ResearchType]()
        
        var index = 0
        
        for spaceshipType in Spaceship.types {
            let researchType = ResearchType(index: index, name: spaceshipType.name, duration: 7200)
            researchType.spaceshipUnlockedIndex = spaceshipType.index
            types.append(researchType)
            index = index + 1
        }
        
        return types
    }()
}