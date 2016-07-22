//
//  MemoryCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation
import CoreData

class MemoryCard {
    
    static let sharedInstance = MemoryCard()
    
    private var autoSave:Bool = false
    
    var playerData:PlayerData!
    
    init() {
        self.loadGame()
    }
    
    func newGame() {
        print("Creating new game...")
        
        self.playerData = self.newPlayerData()
        
        self.autoSave = true
        self.saveGame()
    }
    
    func saveGame() {
        if(self.autoSave) {
            self.autoSave = false
            print("Saving game...")
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func loadGame() {
        if let _ = self.playerData {
            print("Game already loaded.")
        } else {
            let fetchRequestData:NSArray = self.fetchRequest()
            
            if(fetchRequestData.count > 0) {
                print("Loading game...")
                self.playerData = (fetchRequestData.lastObject as! PlayerData)
                self.updateModelVersion()
                self.autoSave = true
            } else {
                self.newGame()
            }
        }
    }
    
    func updateModelVersion() {
        //SpaceWar 2
        if self.playerData.battery == nil {
            self.playerData.battery = self.newBatteryData()
        }
        
        if self.playerData.startDate == nil {
            self.playerData.startDate = NSDate()
        }
    }
    
    func reset() {
        print("MemoryCard.reset()")
        
        let fetchRequestData:NSArray = fetchRequest()
        
        for item in fetchRequestData {
            self.managedObjectContext.deleteObject(item as! NSManagedObject)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.newGame()
    }
    
    func fetchRequest() -> NSArray {
        let fetchRequest = self.managedObjectModel.fetchRequestTemplateForName("FetchRequest")!
        let fetchRequestData: NSArray! = try? self.managedObjectContext.executeFetchRequest(fetchRequest)
        return fetchRequestData
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationCachesDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PabloHenri91.SpaceWar" in the application's caches Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SpaceWar", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationCachesDirectory.URLByAppendingPathComponent("SpaceWar.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            try! ALIterativeMigrator.iterativeMigrateURL(url, ofType: NSSQLiteStoreType, toModel: self.managedObjectModel, orderedModelNames: [ "SpaceWar", "SpaceWar 2" ])
            
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            
            return coordinator
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
