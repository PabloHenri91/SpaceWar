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
    
    let friends = MemoryCard.sharedInstance.playerData.invitedFriends as! Set<FriendData>
    
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
        //print("complete")
        //print(results)
        //print((results["to"] as! NSArray).count)
        
        
     if let inviteds = results["to"] as? [String] {
        var needAdd = true
        
        for friend in inviteds {
            for item in self.friends {
                if item.id == friend {
                    needAdd = false
                    break
                }
            }
            
            if needAdd {
                MemoryCard.sharedInstance.playerData.addFriendData(MemoryCard.sharedInstance.newFriendData(id: friend))
            }
            
        }
          self.gameInviterDelegate.inviteSucess(inviteds.count)
      }
        
        
        self.inviteNow.removeAll()
        self.sliceFriendList()
        if self.inviteNow.count > 0 {
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
            } else {
            gameRequestContent.filters = FBSDKGameRequestFilter.AppNonUsers
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
            //print(error)
        }
    }
    
    func inviteAllFriends(delegate:FacebookGameInviterDelegate ,idFriendArray:[AnyObject]) {
        self.gameInviterDelegate = delegate
        self.idFriendArray = idFriendArray
        self.sliceFriendList()
        //print(self.inviteNow)
        self.invite(self.inviteNow)
    }
    
    func inviteSomeFriends(delegate:FacebookGameInviterDelegate) {
        self.gameInviterDelegate = delegate
        self.invite(nil)
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
    
    func updateInvitedFriends() {
        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            FacebookClient.sharedInstance.listGameFriends({ (meFriends, error) in
                if meFriends.count > 0 {
                    
                    let playerData = MemoryCard.sharedInstance.playerData
                    
                    for item in meFriends {
                        let id = item.objectForKey("id") as! String
                        for friend in self.friends {
                            if id == friend.id {
                                //print(item)
                                let name = item.objectForKey("name") as! String
                                let picture = item.objectForKey("picture")
                                let data = picture?.objectForKey("data")
                                let photoURL = data?.objectForKey("url") as! String
                                playerData.updateInvitedFriend(id: id, name: name, photoURL: photoURL, accepted: true)
                                //print("I invited you and update")
                                //print(MemoryCard.sharedInstance.playerData.invitedFriends)
                                return
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    func countInvitesAccept() -> Int {
        var count = 0
        for friend in self.friends {
            if friend.acceptedInvite == true {
                count = count + 1
            }
        }
        return count

    }
    
}