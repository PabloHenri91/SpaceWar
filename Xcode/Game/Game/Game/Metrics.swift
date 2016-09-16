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
    
    static func purchasedPremiumPointsAtGameStore(_ storeItem: StoreItem) {
        if Metrics.canSendEvents() {
            GameAnalytics.addBusinessEvent(withCurrency: "USD", amount: Int(100 * storeItem.price), itemType: "premiumPoints", itemId: storeItem.productIdentifier, cartType: "GameStore", autoFetchReceipt: true)
        }
    }
    
    static func tryCheat() {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "tryCheat")
        }
    }
    
    static func killerSpaceship(_ spaceship: String) {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "Killer:" + spaceship)
        }
    }
    
    static func oneHitKillerSpaceship(_ spaceship: String) {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "OneHitKiller:" + spaceship)
        }
    }
    
    static func win() {
        let level = MemoryCard.sharedInstance.playerData!.motherShip.level
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "BattleWin:" + level.description)
        }
    }
    
    static func loose() {
        let level = MemoryCard.sharedInstance.playerData!.motherShip.level
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "BattleLoose:" + level.description)
        }
    }
    
    static func openTheGame() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let hour = formatter.string(from: date)
        
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "OpenTheGameAtHour:" + hour)
        }
    }
    
    static func battlesPlayedPerSession() {
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "BattlesPlayed" , value: Metrics.battlesPlayed as NSNumber)
        }
    }
    
    static func battleTime(_ time:TimeInterval) {
        let level = MemoryCard.sharedInstance.playerData!.motherShip.level
        let totalTime = TimeInterval(Int(time))
        
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "BattleTime:" + level.description , value: totalTime as NSNumber)
        }
    }
    
    static func levelUp() {
        let level = MemoryCard.sharedInstance.playerData!.motherShip.level
        let startDate = MemoryCard.sharedInstance.playerData!.startDate
        
        let time = TimeInterval(Int(startDate!.timeIntervalSinceNow * -1))
        
        if Metrics.canSendEvents() {
            GameAnalytics.addDesignEvent(withEventId: "LevelUp:" + level.description , value: time as NSNumber)
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
