//
//  MothershipData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(MothershipData)

class MothershipData: NSManagedObject {

    @NSManaged var level: NSNumber
    @NSManaged var xp: NSNumber
    
    @NSManaged var spaceships: NSSet

}

extension MemoryCard {
    
    func newMothershipData() -> MothershipData {
        
        let mothershipData = NSEntityDescription.insertNewObjectForEntityForName("MothershipData", inManagedObjectContext: self.managedObjectContext) as! MothershipData
        
        mothershipData.level = 1
        mothershipData.xp = 0
        
        mothershipData.spaceships = NSSet()
        
        return mothershipData
    }
}

extension MothershipData {
    
    func addSpaceshipData(value: SpaceshipData) {
        let items = self.mutableSetValueForKey("spaceships")
        items.addObject(value)
    }
    
    func removeSpaceshipData(value: SpaceshipData) {
        let items = self.mutableSetValueForKey("spaceships")
        items.removeObject(value)
    }
    
}
