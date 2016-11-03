//
//  MemoryCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import CoreData

class MemoryCard {
    
    static let sharedInstance = MemoryCard()
    
    fileprivate var autoSave:Bool = false
    
    var playerData:PlayerData!
    
    init() {
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
            self.playerData.startDate = Date()
        }
        
        //nova estrutura de pesquisas
        
        if self.playerData.weapons.count > 0 {
            let weapons = self.playerData.weapons
            let spaceships = self.playerData.unlockedSpaceships

            
            self.playerData.weapons = NSSet()
            self.playerData.unlockedSpaceships = NSSet()
            self.playerData.researches = NSSet()
            
            for research in Research.types {
                let newResearch = self.newResearchData()
                newResearch.type = research.index as NSNumber
                self.playerData.addResearchData(newResearch)
            }
            
            let researches = self.playerData.researches
            
            for weapon in weapons {
                for spaceship in spaceships {
                    
                    let weaponData = self.newWeaponData(type: Int((weapon as! WeaponData).type))
                    
                    let spaceshipData = self.newSpaceshipData(type: Int((spaceship as! SpaceshipData).type))
                    spaceshipData.addWeaponData(weaponData)
                    
                    self.playerData.unlockSpaceshipData(spaceshipData)
                    
                    for research in researches {
                        let researchData = research as! ResearchData
                        let researchType = Research.types[Int(researchData.type.int32Value)]
                        
                        if researchType.weaponUnlocked == weaponData.type.intValue && researchType.spaceshipUnlocked == spaceshipData.type.intValue {
                            researchData.done = 1
                        }
                    }
                }
            }
        }
        
        // ALTERACAO DE PESQUISAS PARA VERSAO 6 DO DATA MODEL
        
        if self.playerData.datamodelVersion.intValue < 6 {
            
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
                    
                    let researchType = Research.types[researchData.type.intValue]
                    
                    for item in researchType.researchesNeeded {
                        for subItem in researches {
                            if let researchData = subItem as? ResearchData {
                                if researchData.type.intValue == item {
                                    if researchData.done.boolValue == false {
                                        unlocked = false
                                        print(researchType.researchDescription)
                                    }
                                }
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
        
        if self.playerData.datamodelVersion.intValue < 8 {
            self.playerData.datamodelVersion = 8
            
            var levelSum = 0
            var spaceshipDataCount = 0
            for item in self.playerData.spaceships {
                if let spaceshipData = item as? SpaceshipData {
                    levelSum = levelSum + spaceshipData.level.intValue
                    spaceshipDataCount = spaceshipDataCount + 1
                }
            }
            
            if spaceshipDataCount > 0 {
                self.playerData.botLevel = (levelSum/spaceshipDataCount) as NSNumber
            }
        }
        
        if self.playerData.datamodelVersion.intValue < 9 {
            self.playerData.datamodelVersion = 9
            
            for item in self.playerData.spaceships {
                if let spaceshipData = item as? SpaceshipData {
                    if let _ = spaceshipData.weapons.anyObject() as? WeaponData {
                        
                    } else {
                        let weaponData = self.newWeaponData()
                        weaponData.level = spaceshipData.level.intValue as NSNumber
                        spaceshipData.addWeaponData(weaponData)
                    }
                }
            }
        }
    }
    
    func reset() {
        //print("MemoryCard.reset()")
        
        let fetchRequestData:NSArray = fetchRequest()
        
        for item in fetchRequestData {
            self.managedObjectContext.delete(item as! NSManagedObject)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.newGame()
    }
    
    func fetchRequest() -> NSArray {
        let fetchRequest = self.managedObjectModel.fetchRequestTemplate(forName: "FetchRequest")!
        let fetchRequestData: NSArray! = try? self.managedObjectContext.fetch(fetchRequest) as NSArray!
        return fetchRequestData
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationCachesDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PabloHenri91.SpaceWar" in the application's caches Application Support directory.
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SpaceWar", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        let fileManager = FileManager.default
        
        var coordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        #if DEBUG
            let url: URL = {
                if let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
                    print("url iCloud " + url.path.description)
                    return url.appendingPathComponent("SpaceWarDebug.sqlite")
                } else {
                    let url = self.applicationDocumentDirectory
                    print("url local " + url.path.description)
                    return url.appendingPathComponent("SpaceWarDebug.sqlite")
                }
            }()
        #else
            let url = self.applicationDocumentDirectory.appendingPathComponent("SpaceWar.sqlite")
        #endif
        
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        let options = Dictionary(dictionaryLiteral:
            (NSMigratePersistentStoresAutomaticallyOption, true),
                                 (NSInferMappingModelAutomaticallyOption , true))
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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
    
    func resetTimers() {
//        let researches = playerData.researches
//        let missionShips = playerData.missionSpaceships
//        let battery = playerData.battery
//        
//        for item in researches {
//            if let research = item as? ResearchData {
//                if research.done == 0 {
//                    if research.startDate != nil {
//                        research.startDate = Date()
//                    }
//                }
//            }
//        }
//        
//        for item in missionShips {
//            if let missionShip = item as? MissionSpaceshipData {
//                if missionShip.missionType.int32Value >= 0 {
//                    missionShip.startMissionDate = Date()
//                }
//            }
//        }
//        
//        battery?.lastCharge = Date()  
    }
}
