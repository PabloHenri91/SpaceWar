//
//  PlayerData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(PlayerData)

class PlayerData: NSManagedObject {
    
    @NSManaged var battery: BatteryData?
    @NSManaged var botUpdateInterval: NSNumber
    @NSManaged var botLevel: NSNumber
    @NSManaged var name: String
    @NSManaged var needBattleTraining: NSNumber
    @NSManaged var points: NSNumber
    @NSManaged var pointsSum: NSNumber
    @NSManaged var premiumPoints: NSNumber
    @NSManaged var motherShip: MothershipData
    @NSManaged var researches: NSSet
    @NSManaged var spaceships: NSSet
    @NSManaged var missionSpaceships: NSOrderedSet
    @NSManaged var weapons: NSSet
    @NSManaged var invitedFriends: NSSet
    @NSManaged var unlockedSpaceships: NSSet
    @NSManaged var startDate: Date?
    @NSManaged var winCount: NSNumber
    @NSManaged var winningStreakBest: NSNumber
    @NSManaged var winningStreakCurrent: NSNumber
    @NSManaged var datamodelVersion: NSNumber
    @NSManaged var boosts: NSSet

}

extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        
        let playerData = NSEntityDescription.insertNewObject(forEntityName: "PlayerData", into: self.managedObjectContext) as! PlayerData
        
        playerData.battery = self.newBatteryData()
        playerData.botUpdateInterval = 10
        
        playerData.name = CharacterGenerator().getName()
        #if DEBUG
            playerData.needBattleTraining = false
        #else
            playerData.needBattleTraining = true
        #endif
        
        playerData.points = 0
        playerData.pointsSum = 0
        playerData.premiumPoints = 100
        playerData.motherShip = self.newMothershipData()
        
        
        // spaceships
        playerData.spaceships = NSSet()
        
        
        //adicionei a nave 0 a nave mae
        var spaceshipData = self.newSpaceshipData(type: 0)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        var weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)

        
        
        //adicionei a nave 1 a nave mae
        spaceshipData = self.newSpaceshipData(type: 0)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)
        

        
        //adicionei a nave 2 na nave mae 2 vezes
        spaceshipData = self.newSpaceshipData(type: 0)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)
        
     
        
        // adicionei a nave 3 na nave mae
        spaceshipData = self.newSpaceshipData(type: 0)
        playerData.motherShip.addSpaceshipData(spaceshipData, index: 0)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)
        
        
        // unlocked spaceships
        playerData.unlockedSpaceships = NSSet()
        
        spaceshipData = self.newSpaceshipData(type: 0)
        weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)
        playerData.unlockSpaceshipData(spaceshipData)
        

        
        // weapons
        playerData.weapons = NSSet()
        
        // mission spaceships
        playerData.missionSpaceships = NSOrderedSet()
        
        let missionSpaceshipData = self.newMissionSpaceshipData()
        playerData.addMissionSpaceshipData(missionSpaceshipData)
        
        // researches
        playerData.researches = NSSet()
        
        let newResearch = self.newResearchData()
        newResearch.type = 11
        newResearch.spaceshipLevel = 10
        playerData.addResearchData(newResearch)
        
        
        // list of facebook friends sent game invite
        playerData.invitedFriends = NSSet()
        playerData.addFriendData(self.newFriendData(id: "1312123213231"))
        
        playerData.startDate = Date()
        
        playerData.winCount = 0
        playerData.winningStreakCurrent = 0
        playerData.winningStreakBest = 0
        
        playerData.boosts = NSSet()
        
        playerData.datamodelVersion = 8
        
        playerData.botLevel = 1
        
        return playerData
    }
}

extension PlayerData {
    
    func removeBoostData(_ value: BoostData) {
        let items = self.mutableSetValue(forKey: "boosts")
        items.remove(value)
    }
    
    func addBoostData(_ value: BoostData) {
        let items = self.mutableSetValue(forKey: "boosts")
        items.add(value)
    }
    
    func addResearchData(_ value: ResearchData) {
        let items = self.mutableSetValue(forKey: "researches")
        items.add(value)
    }
    
    func removeResearchData(_ value: ResearchData) {
        let items = self.mutableSetValue(forKey: "researches")
        items.remove(value)
    }
    
    func addSpaceshipData(_ value: SpaceshipData) {
        let items = self.mutableSetValue(forKey: "spaceships")
        items.add(value)
    }
    
    func unlockSpaceshipData(_ value: SpaceshipData) {
        let items = self.mutableSetValue(forKey: "unlockedSpaceships")
        items.add(value)
    }
    
    func addMissionSpaceshipData(_ value: MissionSpaceshipData) {
        let items = self.mutableOrderedSetValue(forKey: "missionSpaceships")
        items.add(value)
    }
    
    func removeSpaceshipData(_ value: SpaceshipData) {
        let items = self.mutableSetValue(forKey: "spaceships")
        items.remove(value)
    }
    
    func addWeaponData(_ value: WeaponData) {
        let items = self.mutableSetValue(forKey: "weapons")
        items.add(value)
    }
    
    func removeWeaponData(_ value: WeaponData) {
        let items = self.mutableSetValue(forKey: "weapons")
        items.remove(value)
    }
    
    func addFriendData(_ value: FriendData) {
        let items = self.mutableSetValue(forKey: "invitedFriends")
        items.add(value)
    }
    
    func removeFriendData(_ value: FriendData) {
        let items = self.mutableSetValue(forKey: "invitedFriends")
        items.remove(value)
    }
    
    func updateInvitedFriend(id:String, name: String, photoURL: String, accepted: Bool) {
        for item in self.invitedFriends {
            if let friend = item as? FriendData {
                if friend.id == id {
                    friend.name = name
                    friend.photoURL = photoURL
                    friend.acceptedInvite = NSNumber(value: accepted)
                    return
                }
            }
        }
        
    }
}
