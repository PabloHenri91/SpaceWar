//
//  WeaponData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(WeaponData)

class WeaponData: NSManagedObject {

    @NSManaged var level: NSNumber
    @NSManaged var type: NSNumber

}

extension MemoryCard {
    
    func newWeaponData() -> WeaponData {
        return self.newWeaponData(type: Int.random(Weapon.types.count))
    }
    
    func newWeaponData(type type:Int) -> WeaponData {
        
        let weaponData = NSEntityDescription.insertNewObjectForEntityForName("WeaponData", inManagedObjectContext: self.managedObjectContext) as! WeaponData
        
        weaponData.level = 1
        weaponData.type = type
        
        return weaponData
    }
}

extension WeaponData {
    
}
