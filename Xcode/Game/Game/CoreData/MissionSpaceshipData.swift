//
//  MissionSpaceshipData.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 01/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData


@objc(MissionSpaceshipData)

class MissionSpaceshipData: NSManagedObject {
    
    @NSManaged var level: NSNumber
    @NSManaged var startMissionDate: NSDate?
    @NSManaged var missionType: NSNumber?
    
    @NSManaged var parentPlayer: PlayerData?


}


extension MemoryCard {
    
    func newMissionSpaceshipData() -> MissionSpaceshipData {
        
        let missionSpaceshipData = NSEntityDescription.insertNewObjectForEntityForName("MissionSpaceshipData", inManagedObjectContext: self.managedObjectContext) as! MissionSpaceshipData
        missionSpaceshipData.level = 1

        return missionSpaceshipData
    }
}
