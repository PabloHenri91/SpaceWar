//
//  AdColonyDelegate.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 8/15/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import UIKit

class GameAdManager: UIResponder, AdColonyDelegate, AdColonyAdDelegate {
    
    static let sharedInstance = GameAdManager()
    
    let adcolonyAppID = "app76bbb0183d2d4e109b"
    let adcolonyZoneID = "vz9bdb0a31cbae4a37b0"
    
    var zoneIsReady = false
    
    private override init() {
        super.init()
        AdColony.configureWithAppID(self.adcolonyAppID, zoneIDs: [self.adcolonyZoneID], delegate: self, logging: false)
    }
    
    func playVideoAd() {
        if self.zoneIsReady {
            Music.sharedInstance.pause()
            
            AdColony.playVideoAdForZone(self.adcolonyZoneID, withDelegate: self)
        }
    }
    
    //=============================================
    // MARK:- AdColony Ad Fill
    //=============================================
    
    /**
     Callback triggered when the state of ad readiness changes
     If the AdColony SDK tells us our zone either has, or doesn't have, ads, we
     need to tell our view controller to update its UI elements appropriately
     */
    func onAdColonyAdAvailabilityChange(available: Bool, inZone zoneID: String) {
        self.zoneIsReady = available
        if available {
            Control.gameScene.zoneReady()
        } else {
            Control.gameScene.zoneLoading()
        }
    }
    
    func onAdColonyAdAttemptFinished(shown: Bool, inZone zoneID: String)  {
        Music.sharedInstance.play()
        
        Control.gameScene.videoAdAttemptFinished(shown)
        
        if !shown && AdColony.zoneStatusForZone(self.adcolonyZoneID) != ADCOLONY_ZONE_STATUS.ACTIVE {
            Control.gameScene.zoneLoading()
        } else if !shown {
            Control.gameScene.zoneReady()
        }
    }
}

extension GameScene {
    
    func playVideoAd() {
        GameAdManager.sharedInstance.playVideoAd()
    }
    
    func videoAdAttemptFinished(shown: Bool) {
        if let scene = self as? MissionScene {
            scene.videoAdAttemptFinished(shown)
            return
        }
    }
    
    func zoneReady() {
        if let scene = self as? MissionScene {
            scene.zoneReady()
            return
        }
    }
    
    func zoneLoading() {
        func zoneReady() {
            if let scene = self as? MissionScene {
                scene.zoneLoading()
                return
            }
        }
    }
}
