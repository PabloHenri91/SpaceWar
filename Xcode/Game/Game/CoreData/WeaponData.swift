//
//  WeaponData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(WeaponData)

class WeaponData: NSManagedObject {

    @NSManaged var level: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var player: PlayerData?
    @NSManaged var spaceship: SpaceshipData?

}

extension WeaponData {
    
}
