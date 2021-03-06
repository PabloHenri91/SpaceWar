//
//  GameViewController.swift
//  Game-iOS
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright (c) 2016 PabloHenri91. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        Display.viewBoundsSize = skView.bounds.size
        
        let scene = LoadScene()
        
        #if DEBUG
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsPhysics = true
        #endif
        
        skView.presentScene(scene)
        
        self.authenticateLocalPlayer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as! SKView
        
        Display.viewBoundsSize = skView.bounds.size
        skView.scene?.size = Display.updateSceneSize()
        Control.resetControls()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return  UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.Portrait.rawValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(completion block: () -> Void = {}) {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        if localPlayer.authenticated {
            block()
            
        } else {
            
            localPlayer.authenticateHandler = {(viewController: UIViewController?, error: NSError?) in
                
                if viewController != nil {
                    self.presentViewController(viewController!, animated: true, completion: nil)
                }
                
                if localPlayer.authenticated {
                    block()
                    
                    if let name = localPlayer.alias {
                        MemoryCard.sharedInstance.playerData.name = name
                    }
                }
            }
        }
    }
    
    func saveSkillLevel(level:Int) {
        
        if Metrics.canSendEvents() {
            
            if GKLocalPlayer.localPlayer().authenticated {
                
                let score = GKScore(leaderboardIdentifier: "com.Spacewar.SkillRank")
                score.value = Int64(level)
                
                GKScore.reportScores([score], withCompletionHandler: { (error: NSError?) in
                    if error != nil {
                        //print("error")
                    }
                })
                
            } else {
                self.authenticateLocalPlayer(completion: { [weak self] in
                    self?.saveSkillLevel(level)
                })
            }
        }
    }
    
    
    func saveLevel(level:Int) {
        
        if Metrics.canSendEvents() {
            
            //check if user is signed in
            if GKLocalPlayer.localPlayer().authenticated {
                
                let scoreReporter = GKScore(leaderboardIdentifier: "com.Spacewar.Rank") //leaderboard id here
                
                scoreReporter.value = Int64(level) //score variable here (same as above)
                
                let scoreArray: [GKScore] = [scoreReporter]
                
                GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                    if error != nil {
                        //print("error")
                    }
                })
            } else {
                self.authenticateLocalPlayer(completion: { [weak self] in
                    self?.saveLevel(level)
                })
            }
        }
    }
    
}
