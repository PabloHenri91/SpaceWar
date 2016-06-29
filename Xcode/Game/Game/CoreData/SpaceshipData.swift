//
//  SpaceshipData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(SpaceshipData)

class SpaceshipData: NSManagedObject {

    @NSManaged var level: NSNumber
    @NSManaged var type: NSNumber
    @NSManaged var xp: NSNumber
    @NSManaged var weapons: NSSet
    @NSManaged var crashDate: NSDate
    
    @NSManaged var parentPlayer: PlayerData?
    

}

extension MemoryCard {
    
    func newSpaceshipData(type type:Int) -> SpaceshipData {
        
        let spaceshipData = NSEntityDescription.insertNewObjectForEntityForName("SpaceshipData", inManagedObjectContext: self.managedObjectContext) as! SpaceshipData
        
        spaceshipData.level = 1
        spaceshipData.type = type
        spaceshipData.xp = 0
        spaceshipData.weapons = NSSet()
        spaceshipData.crashDate = NSDate(timeInterval: -7200, sinceDate: NSDate())
        
        return spaceshipData
    }
}

extension SpaceshipData {
    
    func addWeaponData(value: WeaponData) {
        let items = self.mutableSetValueForKey("weapons")
        items.addObject(value)
    }
    
    func removeWeaponData(value: WeaponData) {
        let items = self.mutableSetValueForKey("weapons")
        items.removeObject(value)
    }
    
}
