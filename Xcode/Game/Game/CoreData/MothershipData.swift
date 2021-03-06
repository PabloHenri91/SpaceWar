//
//  MothershipData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(MothershipData)

class MothershipData: NSManagedObject {

    @NSManaged var level: NSNumber
    @NSManaged var xp: NSNumber
    
    @NSManaged var spaceships: NSOrderedSet

}

extension MemoryCard {
    
    func newMothershipData() -> MothershipData {
        
        let mothershipData = NSEntityDescription.insertNewObjectForEntityForName("MothershipData", inManagedObjectContext: self.managedObjectContext) as! MothershipData
        
        mothershipData.level = 1
        mothershipData.xp = 0
        
        mothershipData.spaceships = NSOrderedSet()
        
        return mothershipData
    }
}

extension MothershipData {
    
    func addSpaceshipData(value: SpaceshipData, index: Int) {
        let items = self.mutableOrderedSetValueForKey("spaceships")
        //items.addObject(value)
        items.insertObject(value, atIndex: index)
    }
    
    func removeSpaceshipData(value: SpaceshipData) {
        let items = self.mutableOrderedSetValueForKey("spaceships")
        items.removeObject(value)
    }
    
}
