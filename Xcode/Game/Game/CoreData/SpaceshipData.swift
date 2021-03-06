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

    @NSManaged var crashDate: NSDate
    @NSManaged var killCount: NSNumber
    @NSManaged var level: NSNumber
    @NSManaged var type: NSNumber
    @NSManaged var xp: NSNumber
    
    @NSManaged var parentMothership: MothershipData?
    @NSManaged var parentPlayer: PlayerData?
}

extension MemoryCard {
    
    func newSpaceshipData() -> SpaceshipData {
        return self.newSpaceshipData(type: Int.random(Spaceship.types.count))
    }
    
    func newSpaceshipData(type type:Int) -> SpaceshipData {
        
        let spaceshipData = NSEntityDescription.insertNewObjectForEntityForName("SpaceshipData", inManagedObjectContext: self.managedObjectContext) as! SpaceshipData
        
        spaceshipData.crashDate = NSDate(timeInterval: -7200, sinceDate: NSDate())
        spaceshipData.killCount = 0
        spaceshipData.level = 1
        spaceshipData.type = type
        spaceshipData.xp = 0
        
        return spaceshipData
    }
}
