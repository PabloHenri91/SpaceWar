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
    
    @NSManaged var lastCharge: Date
    @NSManaged var type: NSNumber
    
    @NSManaged var parentPlayer: PlayerData?

}

extension MemoryCard {
    
    func newBoostData(_ type: Int) -> BoostData {
        
        let boostData = NSEntityDescription.insertNewObject(forEntityName: "BoostData", into: self.managedObjectContext) as! BoostData
        
        boostData.type = type as NSNumber
        boostData.lastCharge = Date()
        
        return boostData
    }
}
