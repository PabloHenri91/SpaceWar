//
//  FriendData.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 06/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc(FriendData)

class FriendData: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String?
    @NSManaged var photoURL: String?
    @NSManaged var acceptedInvite: NSNumber
    @NSManaged var parentPlayer: PlayerData?
    

}


extension MemoryCard {
    
    func newFriendData(id id:String) -> FriendData {
        
        let friendData = NSEntityDescription.insertNewObjectForEntityForName("FriendData", inManagedObjectContext: self.managedObjectContext) as! FriendData
        
        friendData.id = id
        friendData.acceptedInvite = NSNumber(bool: false)

        return friendData
    }
    
    
}
