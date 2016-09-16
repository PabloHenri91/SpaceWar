//
//  SpaceshipData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(SpaceshipData)

class SpaceshipData: NSManagedObject {

    @NSManaged var crashDate: Date
    @NSManaged var killCount: NSNumber
    @NSManaged var level: NSNumber
    @NSManaged var type: NSNumber
    @NSManaged var xp: NSNumber
    
    @NSManaged var parentMothership: MothershipData?
    @NSManaged var parentPlayer: PlayerData?
    @NSManaged var weapons: NSSet
}

extension MemoryCard {
    
    func newSpaceshipData() -> SpaceshipData {
        return self.newSpaceshipData(type: Int.random(Spaceship.types.count))
    }
    
    func newSpaceshipData(type:Int) -> SpaceshipData {
        
        let spaceshipData = NSEntityDescription.insertNewObject(forEntityName: "SpaceshipData", into: self.managedObjectContext) as! SpaceshipData
        
        spaceshipData.crashDate = Date(timeInterval: -7200, since: Date())
        spaceshipData.killCount = 0
        spaceshipData.level = 1
        spaceshipData.type = type as NSNumber
        spaceshipData.xp = 0
        
        spaceshipData.weapons = NSSet()
        
        return spaceshipData
    }
}

extension SpaceshipData {
    
    func addWeaponData(_ value: WeaponData) {
        let items = self.mutableSetValue(forKey: "weapons")
        items.add(value)
    }
    
    func removeWeaponData(_ value: WeaponData) {
        let items = self.mutableSetValue(forKey: "weapons")
        items.remove(value)
    }
    
}
