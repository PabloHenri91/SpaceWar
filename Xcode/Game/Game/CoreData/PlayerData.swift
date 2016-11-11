//
//  PlayerData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData
import UIKit

@objc(PlayerData)

class PlayerData: NSManagedObject {
    
    @NSManaged var battery: BatteryData?
    @NSManaged var botUpdateInterval: NSNumber
    @NSManaged var botLevel: NSNumber
    @NSManaged var musicEnabled: NSNumber
    @NSManaged var name: String
    @NSManaged var needBattleTraining: NSNumber
    @NSManaged var points: NSNumber
    @NSManaged var pointsSum: NSNumber
    @NSManaged var premiumPoints: NSNumber
    @NSManaged var motherShip: MothershipData
    @NSManaged var researches: NSSet
    @NSManaged var spaceships: NSSet
    @NSManaged var missionSpaceships: NSOrderedSet
    @NSManaged var invitedFriends: NSSet
    @NSManaged var unlockedSpaceships: NSSet
    @NSManaged var soundEnabled: NSNumber
    @NSManaged var startDate: NSDate?
    @NSManaged var winCount: NSNumber
    @NSManaged var winningStreakBest: NSNumber
    @NSManaged var winningStreakCurrent: NSNumber
    @NSManaged var datamodelVersion: NSNumber
    @NSManaged var boosts: NSSet

}

extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: self.managedObjectContext) as! PlayerData
        
        playerData.battery = self.newBatteryData()
        playerData.botUpdateInterval = NSNumber(double: 10)
    
        playerData.name = UIDevice.currentDevice().name
        
        #if DEBUG
            playerData.needBattleTraining = NSNumber(bool: false)
        #else
            playerData.needBattleTraining = NSNumber(bool: true)
        #endif
        
        playerData.points = 0
        playerData.pointsSum = 0
        playerData.premiumPoints = 100
        playerData.motherShip = self.newMothershipData()
        
        
        // spaceships
        playerData.spaceships = NSSet()
        
        
        //adicionei a nave 0 a nave mae
        var spaceshipData = self.newSpaceshipData(type: SpaceshipIndex.intrepidBlaster.rawValue)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)

        
        
        //adicionei a nave 1 a nave mae
        spaceshipData = self.newSpaceshipData(type: SpaceshipIndex.intrepidBlaster.rawValue)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        

        
        //adicionei a nave 2 na nave mae 2 vezes
        spaceshipData = self.newSpaceshipData(type: SpaceshipIndex.intrepidBlaster.rawValue)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        
     
        
        // adicionei a nave 3 na nave mae
        spaceshipData = self.newSpaceshipData(type: SpaceshipIndex.intrepidBlaster.rawValue)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        
        
        // unlocked spaceships
        playerData.unlockedSpaceships = NSSet()
        
        spaceshipData = self.newSpaceshipData(type: SpaceshipIndex.intrepidBlaster.rawValue)
        playerData.unlockSpaceshipData(spaceshipData)

        
        // mission spaceships
        playerData.missionSpaceships = NSOrderedSet()
        
        let missionSpaceshipData = self.newMissionSpaceshipData()
        playerData.addMissionSpaceshipData(missionSpaceshipData)
        
        // researches
        playerData.researches = NSSet()
        
        let newResearch = self.newResearchData()
        newResearch.type = SpaceshipIndex.intrepidBlaster.rawValue
        newResearch.spaceshipLevel = 10
        playerData.addResearchData(newResearch)
        
        
        // list of facebook friends sent game invite
        playerData.invitedFriends = NSSet()
        playerData.addFriendData(self.newFriendData(id: "1312123213231"))
        
        playerData.startDate = NSDate()
        
        playerData.winCount = 0
        playerData.winningStreakCurrent = 0
        playerData.winningStreakBest = 0
        
        playerData.boosts = NSSet()
        
        playerData.datamodelVersion = 8
        
        playerData.botLevel = 1
        
        playerData.soundEnabled = true
        playerData.musicEnabled = true
        
        print(playerData.soundEnabled)
        
        return playerData
    }
}

extension PlayerData {
    
    func removeSectorMissionData(value: SectorMissionData) {
        let items = self.mutableSetValueForKey("sectorMissions")
        items.removeObject(value)
    }
    
    func addSectorMissionData(value: SectorMissionData) {
        let items = self.mutableSetValueForKey("sectorMissions")
        items.addObject(value)
    }
    
    func removeBoostData(value: BoostData) {
        let items = self.mutableSetValueForKey("boosts")
        items.removeObject(value)
    }
    
    func addBoostData(value: BoostData) {
        let items = self.mutableSetValueForKey("boosts")
        items.addObject(value)
    }
    
    func addResearchData(value: ResearchData) {
        let items = self.mutableSetValueForKey("researches")
        items.addObject(value)
    }
    
    func removeResearchData(value: ResearchData) {
        let items = self.mutableSetValueForKey("researches")
        items.removeObject(value)
    }
    
    func addSpaceshipData(value: SpaceshipData) {
        let items = self.mutableSetValueForKey("spaceships")
        items.addObject(value)
    }
    
    func unlockSpaceshipData(value: SpaceshipData) {
        let items = self.mutableSetValueForKey("unlockedSpaceships")
        items.addObject(value)
    }
    
    func addMissionSpaceshipData(value: MissionSpaceshipData) {
        let items = self.mutableOrderedSetValueForKey("missionSpaceships")
        items.addObject(value)
    }
    
    func removeSpaceshipData(value: SpaceshipData) {
        let items = self.mutableSetValueForKey("spaceships")
        items.removeObject(value)
    }
    
    func addFriendData(value: FriendData) {
        let items = self.mutableSetValueForKey("invitedFriends")
        items.addObject(value)
    }
    
    func removeFriendData(value: FriendData) {
        let items = self.mutableSetValueForKey("invitedFriends")
        items.removeObject(value)
    }
    
    func updateInvitedFriend(id id:String, name: String, photoURL: String, accepted: Bool) {
        for item in self.invitedFriends {
            if let friend = item as? FriendData {
                if friend.id == id {
                    friend.name = name
                    friend.photoURL = photoURL
                    friend.acceptedInvite = NSNumber(bool: accepted)
                    return
                }
            }
        }
        
    }
}
