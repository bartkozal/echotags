//
//  Audio.swift
//  echotags
//
//  Created by bkzl on 01/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import AVFoundation

class Audio: NSObject {
    var player: AVAudioPlayer?
    
    func play(recording: String) {
        if let sound = NSDataAsset(name: recording) {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [.DuckOthers, .InterruptSpokenAudioAndMixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
                
                try player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeAppleM4A)
                player?.delegate = self
                player?.play()
            } catch {
                print(error)
            }
        }
    }
}

extension Audio: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error)
        }
    }
}