//
//  Sector.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 10/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Sector {
    
    private static var types: [Sector] = {
        
        var types = [Sector]()
        
        types.append(
            Sector(missions: [ // Sector 0
                SectorMission(enemies: [ // SectorMission 0
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue])
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1)
                    ]),
                
                SectorMission(enemies: [ // SectorMission 1
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue])
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1,
                        spaceshipType: Spaceship.types[SpaceshipIndex.tankerBlaster.rawValue])
                    ])
                ]
            )
        )
        
        
        types.append(
            Sector(missions: [ // Sector 1
                SectorMission(enemies: [  // SectorMission 0
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue])
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1)
                    ]),
                
                SectorMission(enemies: [ // SectorMission 1
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue]),
                    SectorMissionEnemy(level: 1, spaceshipType: Spaceship.types[SpaceshipIndex.intrepidBlaster.rawValue])
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1,
                        spaceshipType: Spaceship.types[SpaceshipIndex.speederBlaster.rawValue])
                    ])
                ]
            )
        )
        
        return types
    }()
    
    var missions = [SectorMission]()
    
    static func getSectorMission(sector: Int, sectorMission: Int) -> SectorMission {
        if sector < Sector.types.count {
            let sector = Sector.types[sector]
            if sectorMission < sector.missions.count {
                return sector.missions[sectorMission]
            } else {
                print("SectorMission unavailable sector: \(sector) sectorMission: \(sectorMission)")
                return sector.missions[Int.random(sector.missions.count)]
            }
        } else {
            print("SectorMission unavailable sector: \(sector) sectorMission: \(sectorMission)")
            let sector = Sector.types[Int.random(Sector.types.count)]
            return sector.missions[Int.random(sector.missions.count)]
        }
    }
    
    init(missions: [SectorMission]) {
        self.missions = missions
    }
}

class SectorMission {
    
    var enemies = [SectorMissionEnemy]()
    
    var sectorMissionRewards = [SectorMissionReward]()
    
    init(enemies: [SectorMissionEnemy], sectorMissionRewards: [SectorMissionReward]) {
        self.enemies = enemies
        self.sectorMissionRewards = sectorMissionRewards
    }
}

class SectorMissionEnemy {
    
    var level: Int
    var spaceshipType: SpaceshipType
    
    init(level: Int, spaceshipType: SpaceshipType) {
        self.level = level
        self.spaceshipType = spaceshipType
    }
}

class SectorMissionReward {
    
    var points: Int = 0
    var premiumPoints: Int = 0
    var spaceshipType: SpaceshipType?
    
    init(points: Int, premiumPoints: Int, spaceshipType: SpaceshipType? = nil) {
        self.points = points
        self.premiumPoints = premiumPoints
        self.spaceshipType = spaceshipType
    }
}








