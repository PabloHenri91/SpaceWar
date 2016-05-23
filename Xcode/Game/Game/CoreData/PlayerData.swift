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

}

extension MemoryCard {
    
    func newPlayerData() -> PlayerData {
        
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: self.managedObjectContext) as! PlayerData
        
        playerData.name = "Name"
        playerData.points = 1000000
        playerData.motherShip = self.newMothershipData()
        playerData.researches = NSSet()
        
        playerData.spaceships = NSSet()
        
        var spaceshipData = self.newSpaceshipData(type: 0)
        playerData.addSpaceshipData(spaceshipData)
        
        spaceshipData = self.newSpaceshipData(type: 1)
        playerData.addSpaceshipData(spaceshipData)
        
        spaceshipData = self.newSpaceshipData(type: 2)
        playerData.addSpaceshipData(spaceshipData)
        
        playerData.weapons = NSSet()
        
        return playerData
    }
}

extension PlayerData {
    
    func addResearchData(value: ResearchData) {
        let items = self.mutableSetValueForKey("researches")
        items.addObject(value)
    }
    
    func addSpaceshipData(value: SpaceshipData) {
        let items = self.mutableSetValueForKey("spaceships")
        items.addObject(value)
    }
    
    func addWeaponData(value: WeaponData) {
        let items = self.mutableSetValueForKey("weapons")
        items.addObject(value)
    }
}
