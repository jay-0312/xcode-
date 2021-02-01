//
//  SoundManager.swift
//  Match App
//
//  Created by dhananjay pratap singh on 25/11/2020.
//

import Foundation

import AVFoundation

class SoundManager {
    
   static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect{
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
   static func  playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        // sound effect to be played
        switch effect {
        
        case .flip:
            soundFileName = "cardflip"
        case .shuffle:
            soundFileName = "shuffle"
        case .match:
            soundFileName = "dingcorrect"
        case .nomatch:
            soundFileName = "dingwrong"
        }
        
        // get the path to the sound file inside the bundle
        let path =  Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard path != nil else{
            
            print("File no found \(soundFileName )")
            return
        }
        
        // create a URL object from this String path
        
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            // create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // play the sound
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create object")
        }
        
        
    }
}
