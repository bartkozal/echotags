//
//  Audio.swift
//  echotags
//
//  Created by bkzl on 01/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import AVFoundation

let audio = Audio()

class Audio: NSObject {
    var player: AVAudioPlayer?
    let session = AVAudioSession.sharedInstance()

    func play(_ recording: String) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            if let sound = NSDataAsset(name: recording) {
                do {
                    try self.session.setCategory(AVAudioSessionCategoryPlayback, with: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
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

extension Audio: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
            do {
                try self.session.setActive(false)
            } catch {
                print(error)
            }
        }
    }
}
