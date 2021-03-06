//
//  MemoryCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

@objc class MemoryCard: NSObject {
    
    static let sharedInstance = MemoryCard()
    
    private var autoSave: Bool = false
    
    var playerData: PlayerData!
    
    override init() {
        super.init()
        self.loadGame()
    }
    
    func newGame() {
        //print("Creating new game...")
        
        self.playerData = self.newPlayerData()
        
        self.autoSave = true
        self.saveGame()
    }
    
    func saveGame() {
        if(self.autoSave) {
            self.autoSave = false
            //print("Saving game...")
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func loadGame() {
        if let _ = self.playerData {
            //print("Game already loaded.")
        } else {
            let fetchRequestData:NSArray = self.fetchRequest()
            
            if(fetchRequestData.count > 0) {
                //print("Loading game...")
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
        
        // ALTERACAO DE PESQUISAS PARA VERSAO 6 DO DATA MODEL
        
        if self.playerData.datamodelVersion.integerValue < 6 {
            
            self.playerData.datamodelVersion = 6
            
            
            
            let researches = self.playerData.researches
            self.playerData.researches = NSSet()
            
            let newResearch = self.newResearchData()
            newResearch.type = 11
            newResearch.spaceshipLevel = 10
            newResearch.spaceshipMaxLevel = 10
            
            self.playerData.addResearchData(newResearch)
            
            for item in researches {
                if let researchData = item as? ResearchData {
                    //let research = Research(researchData: researchData)
                    
                    
                    var unlocked = true
                    
                    let researchType = Research.types[researchData.type.integerValue]
                    
                    for item in researches {
                        if let researchData = item as? ResearchData {
                            if researchData.done == 0 {
                                unlocked = false
                                //print(researchType.researchDescription)
                            }
                        }
                    }
                    

                    if unlocked == true {
                        
                        if researchData.done == false {
                            // PESQUISA LIBERADA
                            researchData.spaceshipLevel = 0
                            researchData.spaceshipMaxLevel = 10
                            
                        } else {
                            // PESQUISA COMPLETA
                            researchData.spaceshipLevel = 10
                            researchData.spaceshipMaxLevel = 10
                        }

                        
                        self.playerData.addResearchData(researchData)
                    }
                }
            }
            
        }
        
        if self.playerData.datamodelVersion.integerValue < 8 {
            self.playerData.datamodelVersion = 8
            
            var levelSum = 0
            var spaceshipDataCount = 0
            for item in self.playerData.spaceships {
                if let spaceshipData = item as? SpaceshipData {
                    levelSum = levelSum + spaceshipData.level.integerValue
                    spaceshipDataCount = spaceshipDataCount + 1
                }
            }
            
            if spaceshipDataCount > 0 {
                self.playerData.botLevel = levelSum/spaceshipDataCount
            }
        }
        
        if self.playerData.datamodelVersion.integerValue < 9 {
            self.playerData.datamodelVersion = 9
        }
        
        if self.playerData.datamodelVersion.integerValue < 10 {
            self.playerData.datamodelVersion = 10
        }
    }
    
    func reset() {
        //print("MemoryCard.reset()")
        
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
    
    lazy var applicationDocumentDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
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
        
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        var coordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        #if DEBUG
            let fileName = "SpaceWarDebug.sqlite"
            let url: NSURL = {
                if let url: NSURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier("iCloud.com.PabloHenri91.GameIV") {
                    return url.URLByAppendingPathComponent(fileName)
                } else {
                    return self.applicationDocumentDirectory.URLByAppendingPathComponent(fileName)
                }
            }()
        #else
            let fileName = "SpaceWar.sqlite"
            let url: NSURL = {
                if let url: NSURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier("iCloud.com.PabloHenri91.GameIV") {
                    return url.URLByAppendingPathComponent(fileName)
                } else {
                    return self.applicationDocumentDirectory.URLByAppendingPathComponent(fileName)
                }
            }()
        #endif
        
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        let options = Dictionary(dictionaryLiteral:
            (NSPersistentStoreRemoveUbiquitousMetadataOption, true),
            (NSMigratePersistentStoresAutomaticallyOption, true),
            (NSInferMappingModelAutomaticallyOption , true))
        
        
        var addPersistentStoreWithType = false
        
        do {
            if fileManager.fileExistsAtPath(self.applicationCachesDirectory.URLByAppendingPathComponent(fileName).path!) {
                
                let cachesUrl: NSURL = self.applicationCachesDirectory.URLByAppendingPathComponent(fileName)
                
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: cachesUrl, options: options)
                addPersistentStoreWithType = true
                
                if url != cachesUrl {
                    for persistentStore in coordinator.persistentStores {
                        try! coordinator.migratePersistentStore(persistentStore, toURL: url, options: options, withType: NSSQLiteStoreType)
                    }
                    try! fileManager.removeItemAtURL(cachesUrl)
                }
            }
            
        } catch {
            #if DEBUG
                //try! NSFileManager.defaultManager().removeItemAtURL(url)
            #endif
            fatalError()
        }
        
        if !addPersistentStoreWithType {
            do {
                if fileManager.fileExistsAtPath(self.applicationDocumentDirectory.URLByAppendingPathComponent(fileName).path!) {
                    
                    let documentUrl: NSURL = self.applicationDocumentDirectory.URLByAppendingPathComponent(fileName)
                    
                    try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: documentUrl, options: options)
                    addPersistentStoreWithType = true
                    
                    if url != documentUrl {
                        for persistentStore in coordinator.persistentStores {
                            try! coordinator.migratePersistentStore(persistentStore, toURL: url, options: options, withType: NSSQLiteStoreType)
                        }
                        try! fileManager.removeItemAtURL(documentUrl)
                    }
                }
                
            } catch {
                #if DEBUG
                    //try! NSFileManager.defaultManager().removeItemAtURL(url)
                #endif
                fatalError()
            }
        }
        
        if !addPersistentStoreWithType {
            try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
    
    func resetTimers() {
//        let researches = playerData.researches
//        let missionShips = playerData.missionSpaceships
//        let battery = playerData.battery
//        
//        for item in researches {
//            if let research = item as? ResearchData {
//                if research.done == 0 {
//                    if research.startDate != nil {
//                        research.startDate = NSDate()
//                    }
//                }
//            }
//        }
//        
//        for item in missionShips {
//            if let missionShip = item as? MissionSpaceshipData {
//                if missionShip.missionType.int32Value >= 0 {
//                    missionShip.startMissionDate = NSDate()
//                }
//            }
//        }
//        
//        battery?.lastCharge = NSDate()
    }
}
