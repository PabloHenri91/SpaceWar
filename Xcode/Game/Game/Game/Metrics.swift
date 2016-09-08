//
//  Metrics.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 20/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

#if os(iOS)
    import GameAnalytics
#else
    import Foundation
#endif

class Metrics {
    
    static var battlesPlayed = 0
    
    static func purchasedPremiumPointsAtGameStore(storeItem: StoreItem) {
        if Metrics.canSendEvents() {
            GameAnalytics.addBusinessEventWithCurrency("USD", amount: Int(100 * storeItem.price), itemType: "premiumPoints", itemId: storeItem.productIdentifier, cartType: "GameStore", autoFetchReceipt: true)
        }
    }
    
    static func tryCheat() {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("tryCheat")
        }
    }
    
    static func killerSpaceship(spaceship: String) {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("Killer:" + spaceship)
        }
    }
    
    static func oneHitKillerSpaceship(spaceship: String) {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("OneHitKiller:" + spaceship)
        }
    }
    
    static func win() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("BattleWin:" + level.description)
        }
    }
    
    static func loose() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("BattleLoose:" + level.description)
        }
    }
    
    static func openTheGame() {
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let hour = formatter.stringFromDate(date)
        
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("OpenTheGameAtHour:" + hour)
        }
    }
    
    static func battlesPlayedPerSession() {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("BattlesPlayed" , value: Metrics.battlesPlayed)
        }
    }
    
    static func battleTime(time:NSTimeInterval) {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        let totalTime = NSTimeInterval(Int(time))
        
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("BattleTime:" + level.description , value: totalTime)
        }
    }
    
    static func levelUp() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        let startDate = MemoryCard.sharedInstance.playerData.startDate
        
        let time = NSTimeInterval(Int(startDate!.timeIntervalSinceNow * -1))
        
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEventWithEventId("LevelUp:" + level.description , value: time)
        }
    }
    
    static func canSendEvents() -> Bool {
        #if DEBUG || !os(iOS)
            return false
        #else
            return true
        #endif
    }
}

#if !os(iOS)
    class GameAnalytics {
        static func addDesignEventWithEventId(string: String, value: AnyObject? = nil) { }
        
        static func addBusinessEventWithCurrency(currency: String!, amount: Int, itemType: String!, itemId: String!, cartType: String!, autoFetchReceipt: Bool) { }
        
    }
#endif