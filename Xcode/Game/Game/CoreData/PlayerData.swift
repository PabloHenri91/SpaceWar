//
//  PlayerData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(PlayerData)

class PlayerData: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var points: NSNumber
    @NSManaged var motherShip: MothershipData
    @NSManaged var researches: NSSet
    @NSManaged var spaceships: NSSet
    @NSManaged var missionSpaceships: NSOrderedSet
    @NSManaged var weapons: NSSet
    @NSManaged var invitedFriends: NSSet
    @NSManaged var unlockedSpaceships: NSSet

}

extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: self.managedObjectContext) as! PlayerData
        
        playerData.name = "Name"
        playerData.points = 1000000
        playerData.motherShip = self.newMothershipData()
        
        
        // spaceships
        playerData.spaceships = NSSet()
        
        
        //adicionei a nave 0 a nave mae
        var spaceshipData = self.newSpaceshipData(type: 0)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        var weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)

        
        
        //adicionei a nave 1 a nave mae
        spaceshipData = self.newSpaceshipData(type: 1)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 1)
        spaceshipData.addWeaponData(weaponData)
        

        
        //adicionei a nave 2 na nave mae 2 vezes
        spaceshipData = self.newSpaceshipData(type: 2)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 2)
        spaceshipData.addWeaponData(weaponData)
        
     
        
        //adicionei a nave 3 na nave mae
        spaceshipData = self.newSpaceshipData(type: 3)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 3)
        spaceshipData.addWeaponData(weaponData)
        
        
        // unlocked spaceships
        playerData.unlockedSpaceships = NSSet()
        
        spaceshipData = self.newSpaceshipData(type: 0)
        playerData.unlockSpaceshipData(spaceshipData)
        
        spaceshipData = self.newSpaceshipData(type: 1)
        playerData.unlockSpaceshipData(spaceshipData)
        
        spaceshipData = self.newSpaceshipData(type: 2)
        playerData.unlockSpaceshipData(spaceshipData)
        
        spaceshipData = self.newSpaceshipData(type: 3)
        playerData.unlockSpaceshipData(spaceshipData)
        

        
        //weapons
        playerData.weapons = NSSet()
        
        weaponData = self.newWeaponData(type: 0)
        playerData.addWeaponData(weaponData)
        
        weaponData = self.newWeaponData(type: 1)
        playerData.addWeaponData(weaponData)
        
        weaponData = self.newWeaponData(type: 2)
        playerData.addWeaponData(weaponData)
        
        weaponData = self.newWeaponData(type: 3)
        playerData.addWeaponData(weaponData)
        
        
        // mission spaceships
        playerData.missionSpaceships = NSOrderedSet()
        
        var missionSpaceshipData = self.newMissionSpaceshipData()
        playerData.addMissionSpaceshipData(missionSpaceshipData)
        
        missionSpaceshipData = self.newMissionSpaceshipData()
        missionSpaceshipData.level = 2
        playerData.addMissionSpaceshipData(missionSpaceshipData)
        
        missionSpaceshipData = self.newMissionSpaceshipData()
        missionSpaceshipData.level = 3
        playerData.addMissionSpaceshipData(missionSpaceshipData)
        
        missionSpaceshipData = self.newMissionSpaceshipData()
        missionSpaceshipData.level = 4
        playerData.addMissionSpaceshipData(missionSpaceshipData)
        
        
        //researches
        playerData.researches = NSSet()
        
        for research in Research.types {
            var newResearch = self.newResearchData()
            newResearch.type = research.index
            playerData.addResearchData(newResearch)
        }
        
        
        //list of facebook friends sent game invite
        playerData.invitedFriends = NSSet()
        playerData.addFriendData(self.newFriendData(id: "1118222074867862"))
        playerData.addFriendData(self.newFriendData(id: "1312123213231"))
        
        
        return playerData
    }
}

extension PlayerData {
    
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
    
    func addWeaponData(value: WeaponData) {
        let items = self.mutableSetValueForKey("weapons")
        items.addObject(value)
    }
    
    func removeWeaponData(value: WeaponData) {
        let items = self.mutableSetValueForKey("weapons")
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
