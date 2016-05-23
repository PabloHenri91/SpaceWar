//
//  ResearchData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

@objc(ResearchData)

class ResearchData: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var startDate: NSDate
    @NSManaged var type: NSNumber
    @NSManaged var player: PlayerData?

}

extension ResearchData {
    
}
