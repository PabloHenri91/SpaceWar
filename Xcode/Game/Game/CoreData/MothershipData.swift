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
    @NSManaged var player: PlayerData?

}

extension MemoryCard {
    
    func newMothershipData() -> MothershipData {
        
        let mothershipData = NSEntityDescription.insertNewObjectForEntityForName("MothershipData", inManagedObjectContext: self.managedObjectContext) as! MothershipData
        
        mothershipData.level = 1
        mothershipData.xp = 0
        
        return mothershipData
    }
}

extension MothershipData {
    
}
