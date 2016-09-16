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
        return SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI * 2), duration: 1))
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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.buttonInviteAll = Button(textureName: "button", text: "Invite All", x: 20, y: 466, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonInviteAll)
        
        self.buttonInviteSome = Button(textureName: "button", text: "Invite Some", x: 167, y: 466, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonInviteSome)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
        //print(FacebookGameInviter.sharedInstance.countInvitesAccept())
    }
    

    override func update(_ currentTime: TimeInterval) {
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
                
            case .inviteAll:
                
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: Display.currentSceneSize.width/2 , y: -(Display.currentSceneSize.height/2))
                self.addChild(self.loadingImage)
                
                self.loadingImage.run(self.deathEffect)
                
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = 1000
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.inviteFriends(true)
                
                break
                
            case .inviteSomeFriends:
                
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: Display.currentSceneSize.width/2 , y: -(Display.currentSceneSize.height/2))
                self.addChild(self.loadingImage)
                
                self.loadingImage.run(self.deathEffect)
                
                self.blackSpriteNode.isHidden = false
                self.blackSpriteNode.zPosition = 1000
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.inviteFriends(false)
                
                break
                
            case .normal:
                self.blackSpriteNode.isHidden = true
                
                if let spriteNode = self.loadingImage {
                    spriteNode.removeFromParent()
                }
                
                break

                
            case .mothership:
                self.view?.presentScene(MothershipScene())
                break
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case .normal:
                    if(self.buttonInviteAll.contains(touch.location(in: self))) {
                        self.nextState = .inviteAll
                        return
                    }
                    
                    if(self.buttonInviteSome.contains(touch.location(in: self))) {
                        self.nextState = .inviteSomeFriends
                        return
                    }
                    
                    if(self.buttonBack.contains(touch.location(in: self))) {
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
    
    
    
    func inviteFriends(_ all: Bool){
        
        if all {
            
            FacebookClient.sharedInstance.listInvitablesFriends { (invitableFriends, error) in
                if error == nil {
                    
                    var idFriendArray = [Any]()
                    
                    for item in invitableFriends {
                        
                        var item = item.value as! Dictionary<String, AnyObject>
                        
                        if let idFriend = item.removeValue(forKey: "id") {
                            idFriendArray.append(idFriend as AnyObject)
                        }
                    }
                    
                    FacebookGameInviter.sharedInstance.inviteAllFriends(self,idFriendArray: idFriendArray)
                    
                } else {
                    //print(error)
                    self.nextState = .normal
                }
            }
            
        } else {
            FacebookGameInviter.sharedInstance.inviteSomeFriends(self)
        }
        
        
    }
    
    
    func alertError(_ error: String) {
        //print(error)
        self.nextState = .normal
    }
    
    
    func inviteSucess(_ invitedsCount: Int) {
        //print("sucess")
        //print(invitedsCount)
    }
    
    func inviteFinished() {
        //print("finished")
        self.nextState = .normal
    }
    
    override func removeFromParent() {
        self.loadingImage = nil
        super.removeFromParent()
    }
    
}
