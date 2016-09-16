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

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            return  UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue | UIInterfaceOrientationMask.portraitUpsideDown.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.present(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) in
            if viewController != nil {
                self.present(viewController!, animated: true, completion: nil)
            } else {
                //print("GKLocalPlayer.authenticated: " + GKLocalPlayer.localPlayer().authenticated.description)
            }
            
            if localPlayer.isAuthenticated {
                if let name = localPlayer.alias {
                    MemoryCard.sharedInstance.playerData!.name = name
                }
            }
        }
    }
    
    
    func saveLevel(_ level:Int) {
        
        if Metrics.canSendEvents() {
            
            //check if user is signed in
            if GKLocalPlayer.localPlayer().isAuthenticated {
                
                let scoreReporter = GKScore(leaderboardIdentifier: "com.Spacewar.Rank") //leaderboard id here
                
                scoreReporter.value = Int64(level) //score variable here (same as above)
                
                let scoreArray: [GKScore] = [scoreReporter]
                
                GKScore.report(scoreArray, withCompletionHandler: { (error: Error?) in
                    if error != nil {
                        //print("error")
                    }
                })
            }
        }
    }
    
}
