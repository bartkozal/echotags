//
//  Audio.swift
//  echotags
//
//  Created by bkzl on 01/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import AVFoundation

class Audio {
    var player: AVAudioPlayer?
    
    func play(recording: String) {
        if let sound = NSDataAsset(name: "sample") {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .DuckOthers)
                try player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeAppleM4A)
                
                player?.numberOfLoops = -1
                player?.play()
            } catch(let error) {
                print(error)
            }
        }
    }
}
