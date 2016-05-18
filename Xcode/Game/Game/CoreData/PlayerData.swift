//
//  PlayerData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(PlayerData)

class PlayerData: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var points: NSNumber?
    @NSManaged var motherShip: MothershipData?
    @NSManaged var researches: NSSet?
    @NSManaged var spaceships: NSSet?
    @NSManaged var weapons: NSSet?

}

extension PlayerData {
    
    static func newPlayerData() -> PlayerData {
        
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: MemoryCard.sharedInstance.managedObjectContext) as! PlayerData
        
        return playerData
    }
}
