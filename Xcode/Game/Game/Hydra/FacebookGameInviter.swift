//
//  FacebookGameInviter.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 01/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import FBSDKShareKit

class FacebookGameInviter:NSObject, FBSDKGameRequestDialogDelegate {
    
    static let sharedInstance = FacebookGameInviter()
    
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        print("cancel")
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        print("fail")
        print(error)
    }
    
   func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("complete")
        print(results)
    }
    
    func invite() {
        
        FacebookClient.sharedInstance.loginToFacebookWithSuccess({
            var gameRequestContent : FBSDKGameRequestContent = FBSDKGameRequestContent()
            gameRequestContent.message = "Venha jogar este divertido jogo comigo e ganhar muitos diamantes"
            gameRequestContent.title = "SpaceWare"
            //gameRequestContent.recipients = self.idFriendArray as [AnyObject]
            gameRequestContent.actionType = FBSDKGameRequestActionType.Turn
            
            
            var dialog : FBSDKGameRequestDialog = FBSDKGameRequestDialog()
            dialog.frictionlessRequestsEnabled = true
            dialog.content = gameRequestContent
            dialog.delegate = self
            
            if dialog.canShow(){
                dialog.show()
            }
            
        }) { (error) in
            print(error)
        }
    }


}