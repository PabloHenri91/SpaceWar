//
//  Boost.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/5/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(BoostData)

class BoostData: NSManagedObject {
    
    @NSManaged var lastCharge: NSDate
    @NSManaged var type: NSNumber
    
    @NSManaged var parentPlayer: PlayerData?

}

extension MemoryCard {
    
    func newBoostData(type: Int) -> BoostData {
        
        let boostData = NSEntityDescription.insertNewObjectForEntityForName("BoostData", inManagedObjectContext: self.managedObjectContext) as! BoostData
        
        boostData.type = type
        boostData.lastCharge = NSDate()
        
        return boostData
    }
}
