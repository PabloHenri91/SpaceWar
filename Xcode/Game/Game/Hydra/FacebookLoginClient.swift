//
//  FacebookLoginClient.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 31/05/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import Foundation

// according to SDK documentation, this is now possible, check https://developers.facebook.com/docs/ios/getting-started/advanced#swift
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit


let facebookReadPermissions = ["public_profile", "email", "user_friends"]
//Some other options: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"

func loginToFacebookWithSuccess(callingViewController: UIViewController, successBlock: () -> (), andFailure failureBlock: (NSError?) -> ()) {
    
    if FBSDKAccessToken.currentAccessToken() != nil {
        //For debugging, when we want to ensure that facebook login always happens
        FBSDKLoginManager().logOut()
        //Otherwise do:
        return
    }
    
    FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: callingViewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
        if error != nil {
            //According to Facebook:
            //Errors will rarely occur in the typical login flow because the login dialog
            //presented by Facebook via single sign on will guide the users to resolve any errors.
            
            // Process error
            FBSDKLoginManager().logOut()
            failureBlock(error)
        } else if result.isCancelled {
            // Handle cancellations
            FBSDKLoginManager().logOut()
            failureBlock(nil)
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            var allPermsGranted = true
            
            //result.grantedPermissions returns an array of _NSCFString pointers
            let grantedPermissions = Array(result.grantedPermissions).map( {"\($0)"} )
            for permission in facebookReadPermissions {
                if !grantedPermissions.contains(permission) {
                    allPermsGranted = false
                    break
                }
            }
            if allPermsGranted {
                // Do work
                let fbToken = result.token.tokenString
                let fbUserID = result.token.userID
                
                //Send fbToken and fbUserID to your web API for processing, or just hang on to that locally if needed
                //self.post("myserver/myendpoint", parameters: ["token": fbToken, "userID": fbUserId]) {(error: NSError?) ->() in
                //  if error != nil {
                //      failureBlock(error)
                //  } else {
                //      successBlock(maybeSomeInfoHere?)
                //  }
                //}
                
                successBlock()
            } else {
                //The user did not grant all permissions requested
                //Discover which permissions are granted
                //and if you can live without the declined ones
                failureBlock(nil)
            }
        }
    })
}