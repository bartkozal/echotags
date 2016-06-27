//
//  Audio.swift
//  echotags
//
//  Created by bkzl on 01/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    var player: AVAudioPlayer?
    let session = AVAudioSession.sharedInstance()
    
    func play(recording: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // TODO: use commented version
            // if let sound = NSDataAsset(name: recording) {
            if let sound = NSDataAsset(name: "sample") {
                do {
                    try self.session.setCategory(AVAudioSessionCategoryPlayback, withOptions: [.DuckOthers, .InterruptSpokenAudioAndMixWithOthers])
                    try self.session.setActive(true)
                    
                    try self.player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeAppleM4A)
                    self.player?.delegate = self
                    self.player?.play()
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            do {
                try self.session.setActive(false)
            } catch {
                print(error)
            }
        }
    }
}