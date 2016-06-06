//
//  FacebookGameInviter.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 01/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import FBSDKShareKit

protocol FacebookGameInviterDelegate {
    func alertError(error:String)
    func inviteSucess(invitedsCount:Int)
    func inviteFinished()
}

class FacebookGameInviter:NSObject, FBSDKGameRequestDialogDelegate {
    
    static let sharedInstance = FacebookGameInviter()
    var idFriendArray = [AnyObject]()
    var inviteNow = [AnyObject]()
    var gameInviterDelegate:FacebookGameInviterDelegate!
    
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        //print("cancel")
        self.inviteNow.removeAll()
        self.gameInviterDelegate.alertError("User cancel")
        
    }
    
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        //print("fail")
        //print(error)
        self.inviteNow.removeAll()
        self.gameInviterDelegate.alertError(error.description)
        
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("complete")
        //print(results)
        //print((results["to"] as! NSArray).count)
        self.gameInviterDelegate.inviteSucess((results["to"] as! NSArray).count)
        
        self.inviteNow.removeAll()
        self.sliceFriendList()
        if (self.inviteNow.count > 0) {
            self.invite(self.inviteNow)
        } else {
            self.gameInviterDelegate.inviteFinished()
        }
        
    }
    
    func invite(friendList: [AnyObject]?) {
        
        FacebookClient.sharedInstance.loginToFacebookWithSuccess({
            let gameRequestContent : FBSDKGameRequestContent = FBSDKGameRequestContent()
            gameRequestContent.message = "Venha jogar este divertido jogo comigo e ganhar muitos diamantes"
            gameRequestContent.title = "SpaceWar"
            if friendList != nil {
                gameRequestContent.recipients = friendList
            }
            gameRequestContent.actionType = FBSDKGameRequestActionType.Turn
            
            let dialog : FBSDKGameRequestDialog = FBSDKGameRequestDialog()
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
    
    func inviteAllFriends(delegate:FacebookGameInviterDelegate ,idFriendArray:[AnyObject]) {
        self.gameInviterDelegate = delegate
        self.idFriendArray = idFriendArray
        self.sliceFriendList()
        //print(self.inviteNow)
        self.invite(self.inviteNow)
    }
    
    func sliceFriendList() {
        if self.idFriendArray.count > 0 {
            if self.idFriendArray.count >= 50 {
                for _ in 1...50 {
                    self.inviteNow.append(self.idFriendArray.removeLast())
                }
            } else {
                self.inviteNow = self.idFriendArray
                self.idFriendArray.removeAll()
            }
        }
    }
}