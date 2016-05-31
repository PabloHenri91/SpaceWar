//
//  SocialScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 31/05/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit
import FBSDKLoginKit
import FBSDKShareKit


class SocialScene: GameScene {
    
    
    var playerData = MemoryCard.sharedInstance.playerData
    
     var buttonInvite:Button!
    
    
    //facebook Request
    var after:String = ""
    var idFriendArray = NSMutableArray()
    var idFriendPushArray = NSMutableArray()
    var blockedArray = NSMutableArray()
    var nameFriendArray = NSMutableArray()
    var picsArray = NSMutableArray()
    var loadingImage:SKSpriteNode!
    var fbID: String!
    var picNodes = Array<Control>()

    
    lazy var deathEffect:SKAction = {
        return SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI * 2), duration: 1))
    }()
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case mothership
        
        //Estado de convidar amigos
        case invite
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonInvite = Button(textureName: "button", text: "invite", x: 93, y: 247, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonInvite)
        
        print((self.view?.window?.rootViewController))
        
       

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
            //Próximo estado
            switch (self.nextState) {
                
            case states.invite:
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: 1334/4, y: -750/4)
                self.addChild(self.loadingImage)
                
                self.loadingImage.runAction(self.deathEffect)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = 1000
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                //self.inviteFriends(nil, limit: 50)
                
                break
                
            case states.normal:
                self.blackSpriteNode.hidden = true
                
                if let teste = self.loadingImage {
                    teste.removeFromParent()
                }
                
                break

                
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: self.transition)
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
                    if(self.buttonInvite.containsPoint(touch.locationInNode(self))) {
                        loginToFacebookWithSuccess((self.view?.window?.rootViewController)!, successBlock: {
                            self.loadFriends()
                        }) { (error) in
                            print(error)
                        }
                        return
                    }
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
    
    
    func loadFriends(){
        
        let params: NSMutableDictionary = ["fields": "name" ]
        
        //var friendCell:FriendCell!
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params as [NSObject : AnyObject], HTTPMethod: "GET")
        
        
        
        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    
                    let resultDictionary = result as? NSDictionary
                    
                    print(resultDictionary)

                    
                }
            })
        }
        
        
        
        
        request.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            
            if (result != nil && error == nil){
                
                //print("request rodado")
                
                print (result)
                
                let friendArray = result.objectForKey("data") as! Array<NSDictionary>
                
                //print(friendArray)
                
                for item in friendArray
                {
                    let facebookID = item["id"] as! String
                    self.idFriendPushArray.addObject(facebookID)
                    
                    let pictureURL = NSURL(string: String("https://graph.facebook.com/" + facebookID + "/picture?height=50&return_ssl_resources=1"))
                    
                    //print("https://graph.facebook.com/" + facebookID + "/picture?height=50&return_ssl_resources=1")
                    self.picsArray.addObject(pictureURL!)
                    
                    
                }
                
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    
                    
                    for picURL in self.picsArray {
                        
                        // print("assinc loop picurl")
                        
                        let url = picURL as! NSURL
                        
                        if let imageData = NSData(contentsOfURL: url) {
                            //print("carregando imagem")
                            let image = UIImage(data: imageData)
                            
                            
                            
                            let spriteNode = SKSpriteNode(texture: SKTexture(image: image!))
                            
                            let control = Control(spriteNode: spriteNode)
                            
                            self.picNodes.append(control)
                            
                            if (self.picNodes.count == 3) {
                                //print("3 imagens, mandei para o scroll")
                                
//                                dispatch_async(dispatch_get_main_queue()) {
//                                    
//                                    //adicona no scroll
//                                    friendCell = FriendCell(friends: self.picNodes)
//                                    self.picNodes.removeAll()
//                                    self.friendsScroll.append(friendCell)
//                                    
//                                }
                                
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        
//                        if (self.picNodes.count > 0 ){
//                            
//                            //adicona no scroll
//                            friendCell = FriendCell(friends: self.picNodes)
//                            self.picNodes.removeAll()
//                            self.friendsScroll.append(friendCell)
//                            
//                        }
//                        
//                        
//                    }
                    
                    
                }
                
                
                
            } else if (result == nil){
                loginToFacebookWithSuccess((self.view?.window?.rootViewController)!, successBlock: {
                    self.loadFriends()
                }) { (error) in
                    print(error)
                }
            }
            
        })
        
        
        
        
        
        
        
    }

    
    
}