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

    @NSManaged var level: NSNumber?
    @NSManaged var xp: NSNumber?
    @NSManaged var player: PlayerData?

}

extension MothershipData {
    
}
