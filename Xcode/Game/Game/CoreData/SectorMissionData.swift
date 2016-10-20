//
//  SectorMissionData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 10/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData


class SectorMissionData: NSManagedObject {

    @NSManaged var stars: NSNumber?
    @NSManaged var sectorIndex: NSNumber?
    @NSManaged var sectorMissionIndex: NSNumber?
    
    @NSManaged var parentPlayer: PlayerData?
    
}

extension MemoryCard {
    
    func newSectorMissionData(sectorIndex: Int, sectorMissionIndex: Int) -> SectorMissionData {
        let sectorMissionData = NSEntityDescription.insertNewObjectForEntityForName("SectorMissionData", inManagedObjectContext: self.managedObjectContext) as! SectorMissionData
        
        sectorMissionData.stars = 0
        sectorMissionData.sectorIndex = sectorIndex
        sectorMissionData.sectorMissionIndex = sectorMissionIndex
        
        return sectorMissionData
    }
    
}
