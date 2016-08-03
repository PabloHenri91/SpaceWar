//
//  InviteFriendsScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 31/05/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class InviteFriendsScene: GameScene, FacebookGameInviterDelegate {
    
    var buttonInviteAll:Button!
    var buttonInviteSome:Button!
    var loadingImage:SKSpriteNode!
    lazy var deathEffect:SKAction = {
        return SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI * 2), duration: 1))
    }()
    
    var buttonBack:Button!
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case mothership
        
        //Estado de convidar todos amigos
        case inviteAll
        
        //Estado de convidar alguns amigos
        case inviteSomeFriends
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonInviteAll = Button(textureName: "button", text: "Invite All", x: 20, y: 466, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonInviteAll)
        
        self.buttonInviteSome = Button(textureName: "button", text: "Invite Some", x: 167, y: 466, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonInviteSome)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
        //print(FacebookGameInviter.sharedInstance.countInvitesAccept())
  

    }
    

    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
                
                
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case states.inviteAll:
                
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: Display.currentSceneSize.width/2 , y: -(Display.currentSceneSize.height/2))
                self.addChild(self.loadingImage)
                
                self.loadingImage.runAction(self.deathEffect)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = 1000
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.inviteFriends(true)
                
                break
                
            case states.inviteSomeFriends:
                
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: Display.currentSceneSize.width/2 , y: -(Display.currentSceneSize.height/2))
                self.addChild(self.loadingImage)
                
                self.loadingImage.runAction(self.deathEffect)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = 1000
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.inviteFriends(false)
                
                break
                
            case states.normal:
                self.blackSpriteNode.hidden = true
                
                if let spriteNode = self.loadingImage {
                    spriteNode.removeFromParent()
                }
                
                break

                
            case .mothership:
                self.view?.presentScene(MothershipScene())
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.normal:
                    if(self.buttonInviteAll.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .inviteAll
                        return
                    }
                    
                    if(self.buttonInviteSome.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .inviteSomeFriends
                        return
                    }
                    
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .mothership
                        return
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
    
    
    func inviteFriends(all: Bool){
        
        if all {
            
            FacebookClient.sharedInstance.listInvitablesFriends { (invitableFriends, error) in
                if error == nil {
                    
                    var idFriendArray = [AnyObject]()
                    
                    for item in invitableFriends
                    {
                        if let idFriend = item.objectForKey("id"){
                            idFriendArray.append(idFriend)
                        }
                    }
                    
                    FacebookGameInviter.sharedInstance.inviteAllFriends(self,idFriendArray: idFriendArray)
                    
                } else {
                    print(error)
                    self.nextState = .normal
                }
            }
            
        } else {
            FacebookGameInviter.sharedInstance.inviteSomeFriends(self)
        }
        
        
    }
    
    
    func alertError(error: String) {
        print(error)
        self.nextState = .normal
    }
    
    
    func inviteSucess(invitedsCount: Int) {
        //print("sucess")
        //print(invitedsCount)
    }
    
    func inviteFinished() {
        //print("finished")
        self.nextState = .normal
    }
    
}