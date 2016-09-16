//
//  BatteryData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(BatteryData)

class BatteryData: NSManagedObject {
    
    @NSManaged var lastCharge: Date?
    @NSManaged var charge: NSNumber

}

extension MemoryCard {

    
    func newBatteryData() -> BatteryData {
        
        let batteryData = NSEntityDescription.insertNewObject(forEntityName: "BatteryData", into: self.managedObjectContext) as! BatteryData
        
        batteryData.charge = 4
        batteryData.lastCharge = Date()
        
        return batteryData
    }
}
