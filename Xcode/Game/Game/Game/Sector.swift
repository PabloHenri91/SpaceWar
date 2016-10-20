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
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster)
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1)
                    ]),
                
                SectorMission(enemies: [ // SectorMission 1
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster)
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1,
                        spaceship: (spaceshipType: SpaceshipType.tanker, weaponType: WeaponType.blaster))
                    ])
                ]
            )
        )
        
        
        types.append(
            Sector(missions: [ // Sector 1
                SectorMission(enemies: [  // SectorMission 0
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster)
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1)
                    ]),
                
                SectorMission(enemies: [ // SectorMission 1
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster),
                    SectorMissionEnemy(level: 1, spaceshipType: SpaceshipType.intrepid, weaponType: WeaponType.blaster)
                    ],
                    sectorMissionRewards: [
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1),
                        SectorMissionReward(points: 100, premiumPoints: 1,
                        spaceship: (spaceshipType: SpaceshipType.speeder, weaponType: WeaponType.blaster))
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
    var weaponType: WeaponType
    
    init(level: Int, spaceshipType: SpaceshipType, weaponType: WeaponType) {
        self.level = level
        self.spaceshipType = spaceshipType
        self.weaponType = weaponType
    }
}

class SectorMissionReward {
    
    var points: Int = 0
    var premiumPoints: Int = 0
    var spaceship: (spaceshipType: SpaceshipType, weaponType: WeaponType)?
    
    init(points: Int, premiumPoints: Int, spaceship: (spaceshipType: SpaceshipType, weaponType: WeaponType)? = nil) {
        self.points = points
        self.premiumPoints = premiumPoints
        self.spaceship = spaceship
    }
}








