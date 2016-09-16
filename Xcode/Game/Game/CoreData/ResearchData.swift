//
//  ResearchData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(ResearchData)

class ResearchData: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var startDate: Date?
    @NSManaged var type: NSNumber
    @NSManaged var spaceshipLevel: NSNumber
    @NSManaged var spaceshipMaxLevel: NSNumber

}

extension ResearchData {

}

extension MemoryCard {
    
    func newResearchData() -> ResearchData {
        
        let researchData = NSEntityDescription.insertNewObject(forEntityName: "ResearchData", into: self.managedObjectContext) as! ResearchData
        researchData.done = false
        researchData.startDate = nil
        
        return researchData
    }
}
