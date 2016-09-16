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
        
        let mothershipData = NSEntityDescription.insertNewObject(forEntityName: "MothershipData", into: self.managedObjectContext) as! MothershipData
        
        mothershipData.level = 1
        mothershipData.xp = 0
        
        mothershipData.spaceships = NSOrderedSet()
        
        return mothershipData
    }
}

extension MothershipData {
    
    func addSpaceshipData(_ value: SpaceshipData, index: Int) {
        let items = self.mutableOrderedSetValue(forKey: "spaceships")
        //items.addObject(value)
        items.insert(value, at: index)
    }
    
    func removeSpaceshipData(_ value: SpaceshipData) {
        let items = self.mutableOrderedSetValue(forKey: "spaceships")
        items.remove(value)
    }
    
}
