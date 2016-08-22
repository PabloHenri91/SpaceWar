//
//  Music.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/9/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import AVFoundation

class Music {
    
    enum musicTypes {
        case noMusic
        case menu
        case battle
    }
    
    struct fileNames {
        static var menu = [
            "klamm_space-life.mp3"]
        static var battle = [
            "bus-blanchie_bright-stars.mp3",
            "jredd_magma-crystal-falls.mp3",
            "pandamindset_pandamindset---space-sleepers.mp3"]
    }
    
    static let sharedInstance = Music()
    
    var audioPlayer:AVAudioPlayer!
    
    var musicName = ""
    var musicType:musicTypes = .noMusic
    
    func playMusicWithType(musicType:musicTypes) {
        if self.musicType != musicType {
            self.musicType = musicType
            var musicNames = [String]()
            switch musicType {
            case .noMusic:
                return
            case .menu:
                musicNames.appendContentsOf(Music.fileNames.menu)
                break
            case .battle:
                musicNames.appendContentsOf(Music.fileNames.battle)
                break
            }
            
            self.play(musicNamed: musicNames[Int.random(musicNames.count)])
        }
    }
    
    func playMusicWithName(musicName:String) {
        if self.musicName != musicName {
            self.musicName = musicName
            self.play(musicNamed: musicName)
        }
    }
    
    private func play(musicNamed name:String) {
        var auxName:[String] = name.componentsSeparatedByString(".")
        
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource(auxName[0], withExtension: auxName[1])//TODO: remover auxName[i]
        
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL!)
            self.audioPlayer.volume = 0.3
            self.audioPlayer.numberOfLoops = -1
            self.audioPlayer.prepareToPlay()
            self.play()
            //print("Music: " + name)
        } catch {
            #if DEBUG
                fatalError()
            #endif
        }
    }
    
    func play() {
        //self.audioPlayer.play()
    }
    
    func pause() {
        self.audioPlayer.pause()
    }
    
    func stop() {
        self.audioPlayer.stop()
        self.musicType = .noMusic
        self.musicName = ""
    }
}

