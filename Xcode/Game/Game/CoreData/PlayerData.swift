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
    @NSManaged var weapons: NSSet
    @NSManaged var invitedFriends: NSSet

}

extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: self.managedObjectContext) as! PlayerData
        
        playerData.name = "Name"
        playerData.points = 1000000
        playerData.motherShip = self.newMothershipData()
        
        //researches
        playerData.researches = NSSet()
        
        // spaceships
        playerData.spaceships = NSSet()
        
        var spaceshipData = self.newSpaceshipData(type: 0)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        var weaponData = self.newWeaponData(type: 0)
        spaceshipData.addWeaponData(weaponData)
        
        spaceshipData = self.newSpaceshipData(type: 1)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 1)
        spaceshipData.addWeaponData(weaponData)
        
        spaceshipData = self.newSpaceshipData(type: 2)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 2)
        spaceshipData.addWeaponData(weaponData)
        
        spaceshipData = self.newSpaceshipData(type: 2)
        playerData.motherShip.addSpaceshipData(spaceshipData)
        playerData.addSpaceshipData(spaceshipData)
        weaponData = self.newWeaponData(type: 2)
        spaceshipData.addWeaponData(weaponData)
        
        //weapons
        playerData.weapons = NSSet()
        
        weaponData = self.newWeaponData(type: 0)
        playerData.addWeaponData(weaponData)
        
        weaponData = self.newWeaponData(type: 1)
        playerData.addWeaponData(weaponData)
        
        weaponData = self.newWeaponData(type: 2)
        playerData.addWeaponData(weaponData)
        
        //list of facebook friends sent game invite
        playerData.invitedFriends = NSSet()
        playerData.addFriendData(self.newFriendData(id: "1118222074867862"))
        playerData.addFriendData(self.newFriendData(id: "1312123213231"))
        
        print(playerData.invitedFriends)
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
