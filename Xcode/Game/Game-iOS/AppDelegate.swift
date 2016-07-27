//
//  AppDelegate.swift
//  Game-iOS
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Fabric
import Crashlytics
import GameAnalytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //App launch code
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //Optionally add to ensure your credentials are valid:
        FBSDKLoginManager.renewSystemCredentials { (result:ACAccountCredentialRenewResult, error:NSError!) -> Void in
            //print(result.hashValue)
            FacebookGameInviter.sharedInstance.updateInvitedFriends()
        }
        
        
        Fabric.with([Crashlytics.self, GameAnalytics.self])

        // Enable log to output simple details (disable in production)
        //GameAnalytics.setEnabledInfoLog(true)
        // Enable log to output full event JSON (disable in production)
        //GameAnalytics.setEnabledVerboseLog(true)
        
        // Example: configure available virtual currencies and item types for later use in resource events
        // GameAnalytics.configureAv$ailableResourceCurrencies(["gems", "gold"])
        // GameAnalytics.configureAvailableResourceItemTypes(["boost", "lives"])
        
        // Example: configure available custom dimensions for later use when specifying these
        // GameAnalytics.configureAvailableCustomDimensions01(["ninja", "samurai"])
        // GameAnalytics.configureAvailableCustomDimensions02(["whale", "dolphin"])
        // GameAnalytics.configureAvailableCustomDimensions03(["horde", "alliance"])
        
        // Configure build version
        GameAnalytics.configureBuild("1.0.0")
        
        // initialize GameAnalytics - this method will use app keys injected by Fabric
        GameAnalytics.initializeWithConfiguredGameKeyAndGameSecret()
        // to manually specify keys use this method:
        //GameAnalytics.initializeWithGameKey("[game_key]", gameSecret:"[game_secret]")
        
        print("didFinishLaunch")

        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //Even though the Facebook SDK can make this determinitaion on its own,
        //let's make sure that the facebook SDK only sees urls intended for it,
        //facebook has enough info already!
        guard url.scheme.hasPrefix("fb\(FBSDKSettings.appID())") && url.host == "authorize" else {
            return false
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }
    
    func applicationSignificantTimeChange(application: UIApplication) {
        //TODO: applicationSignificantTimeChange
        //http://stackoverflow.com/questions/13741585/notify-app-when-ipad-date-time-settings-changed
        //http://stackoverflow.com/questions/12221528/nsdate-get-precise-time-independent-of-device-clock
        print("treta na hora")
        MemoryCard.sharedInstance.resetTimers()
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        MemoryCard.sharedInstance.saveGame()
        Metrics.battlesPlayedPerSession()
        Metrics.battlesPlayed = 0
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        Metrics.openTheGame()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

