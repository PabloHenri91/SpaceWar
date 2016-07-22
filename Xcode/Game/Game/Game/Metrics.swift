//
//  Metrics.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 20/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import GameAnalytics

class Metrics {
    
    static var battlesPlayed = 0
    
    static func win() {
        GameAnalytics.addProgressionEventWithProgressionStatus(<#T##progressionStatus: GAProgressionStatus##GAProgressionStatus#>, progression01: <#T##String!#>, progression02: <#T##String!#>, progression03: <#T##String!#>)
    }

    static func openTheGame() {
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let hour = formatter.stringFromDate(date)
        
        GameAnalytics.addDesignEventWithEventId("OpenTheGameAtHour" , value: Int(hour))
    }
    
    static func battlesPlayedPerSession() {
        GameAnalytics.addDesignEventWithEventId("BattlesPlayed" , value: Metrics.battlesPlayed)
    }
    
    static func battleTime(time:NSTimeInterval) {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        let totalTime = NSTimeInterval(Int(time))
    
        GameAnalytics.addDesignEventWithEventId("BattleTime:" + level.description , value: totalTime)
    }
    
    static func levelUp() {
        let level = MemoryCard.sharedInstance.playerData.motherShip.level
        let startDate = MemoryCard.sharedInstance.playerData.startDate
        
        let time = NSTimeInterval(Int(startDate!.timeIntervalSinceNow * -1))
        
        GameAnalytics.addDesignEventWithEventId("LevelUp:" + level.description , value: time)
    }
  
}