//
//  RateMyApp.swift
//  RateMyApp
//
//  Created by Jimmy Jose on 08/09/14.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SpriteKit


class RateMyApp : UIViewController,UIAlertViewDelegate{
    
    private let kTrackingAppVersion     = "kRateMyApp_TrackingAppVersion"
    private let kFirstUseDate			= "kRateMyApp_FirstUseDate"
    private let kAppUseCount			= "kRateMyApp_AppUseCount"
    private let kSpecialEventCount		= "kRateMyApp_SpecialEventCount"
    private let kDidRateVersion         = "kRateMyApp_DidRateVersion"
    private let kDeclinedToRate			= "kRateMyApp_DeclinedToRate"
    private let kRemindLater            = "kRateMyApp_RemindLater"
    private let kRemindLaterPressedDate	= "kRateMyApp_RemindLaterPressedDate"
    
    private var reviewURL = "https://itunes.apple.com/app/viewContentsUserReviews?id="
    
    var promptAfterDays:Double = 30
    var promptAfterUses = 10
    var promptAfterCustomEventsCount = 10
    var daysBeforeReminding:Double = 1
    
    var alertTitle = NSLocalizedString("Rate Space War", comment: "RateMyApp")
    var alertMessage = "If you enjoy playing Space War, would you mind taking a moment to rate it? it won't take more than a minute. Thanks for your support."
    var alertOKTitle = NSLocalizedString("Yes, rate Space War", comment: "RateMyApp")
    var alertCancelTitle = NSLocalizedString("No, thanks", comment: "RateMyApp")
    var alertRemindLaterTitle = NSLocalizedString("Remind me later", comment: "RateMyApp")
    var appID = ""
    
    
    class var sharedInstance : RateMyApp {
        struct Static {
            static let instance : RateMyApp = RateMyApp()
        }
        return Static.instance
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    func initAllSettings(){
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        prefs.setObject(getCurrentAppVersion(), forKey: kTrackingAppVersion)
        prefs.setObject(NSDate(), forKey: kFirstUseDate)
        prefs.setInteger(1, forKey: kAppUseCount)
        prefs.setInteger(0, forKey: kSpecialEventCount)
        prefs.setBool(false, forKey: kDidRateVersion)
        prefs.setBool(false, forKey: kDeclinedToRate)
        prefs.setBool(false, forKey: kRemindLater)
        
    }
    
    func trackEventUsage(){
        incrementValueForKey(name: kSpecialEventCount)
    }
    
    func trackAppUsage() {
        incrementValueForKey(name: kAppUseCount)
    }
    
    func isFirstTime()->Bool{
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let trackingAppVersion = prefs.objectForKey(kTrackingAppVersion) as? NSString
        
        if((trackingAppVersion == nil) || !(getCurrentAppVersion().isEqualToString(trackingAppVersion! as String)))
        {
            return true
        }
        
        return false
        
    }
    
    func incrementValueForKey(name name:String){
        
        if(appID.characters.count == 0)
        {
            fatalError("Set iTunes connect appID to proceed, you may enter some random string for testing purpose. See line number 59")
        }
        
        if(isFirstTime())
        {
            initAllSettings()
            
        }
        else
        {
            let prefs = NSUserDefaults.standardUserDefaults()
            let currentCount = prefs.integerForKey(name)
            prefs.setInteger(currentCount+1, forKey: name)
            
        }
    }
    
    func shouldShowAlert() -> Bool{
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let usageCount = prefs.integerForKey(kAppUseCount)
        let eventsCount = prefs.integerForKey(kSpecialEventCount)
        
        let firstUse = prefs.objectForKey(kFirstUseDate) as! NSDate
        
        let timeInterval = NSDate().timeIntervalSinceDate(firstUse)
        
        let daysCount = ((timeInterval / 3600) / 24)
        
        let hasRatedCurrentVersion = prefs.boolForKey(kDidRateVersion)
        
        let hasDeclinedToRate = prefs.boolForKey(kDeclinedToRate)
        
        let hasChosenRemindLater = prefs.boolForKey(kRemindLater)
        
        if(hasDeclinedToRate)
        {
            return false
        }
        
        if(hasRatedCurrentVersion)
        {
            return false
        }
        
        if(hasChosenRemindLater)
        {
            let remindLaterDate = prefs.objectForKey(kRemindLaterPressedDate) as! NSDate
            
            let timeInterval = NSDate().timeIntervalSinceDate(remindLaterDate)
            
            let remindLaterDaysCount = ((timeInterval / 3600) / 24)
            
            return (remindLaterDaysCount >= daysBeforeReminding)
        }
        
        if(usageCount >= promptAfterUses)
        {
            return true
        }
        
        if(daysCount >= promptAfterDays)
        {
            return true
        }
        
        if(eventsCount >= promptAfterCustomEventsCount)
        {
            return true
        }
        
        return false
        
    }
    
    
    func showRatingAlert() {
        
        if shouldShowAlert() {
            
            let infoDocs : NSDictionary = NSBundle.mainBundle().infoDictionary!
            let appname : NSString = infoDocs.objectForKey("CFBundleName") as! NSString
            
            var message = NSLocalizedString("If you found %@ useful, please take a moment to rate it", comment: "RateMyApp")
            message = String(format:message, appname)
            
            if(alertMessage.characters.count == 0)
            {
                alertMessage = message
            }
            
            Control.gameScene.addChild(RateAlert(rateMyApp: self))
        }
    }
    
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if(buttonIndex == 0)
        {
            cancelButtonPressed()
        }
        else if(buttonIndex == 1)
        {
            remindLaterButtonPressed()
        }
        else if(buttonIndex == 2)
        {
            okButtonPressed()
        }
        
        alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        
    }
    
    func deviceOSVersion() -> Float{
        
        let device : UIDevice = UIDevice.currentDevice();
        let systemVersion = device.systemVersion;
        let iOSVerion : Float = (systemVersion as NSString).floatValue
        
        return iOSVerion
    }
    
    func hasOS8()->Bool{
        
        if(deviceOSVersion() < 8.0)
        {
            return false
        }
        
        return true
        
    }
    
    func okButtonPressed(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kDidRateVersion)
        let appStoreURL = NSURL(string:reviewURL+appID)
        UIApplication.sharedApplication().openURL(appStoreURL!)
        
    }
    
    func cancelButtonPressed(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kDeclinedToRate)
        
    }
    
    func remindLaterButtonPressed(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kRemindLater)
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: kRemindLaterPressedDate)
        
    }
    
    func getCurrentAppVersion()->NSString{
        
        return (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! NSString)
        
    }
    
    
    
}
