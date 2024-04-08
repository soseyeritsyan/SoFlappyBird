//
//  MusicManager.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 03.03.24.
//

import Foundation
import AVFoundation

class MusicManager {
    static let shared = MusicManager()
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "Flappy", withExtension: "mp3") else {
            print("Background music file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    
    func pauseBackgroundMusic() {
        audioPlayer?.pause()
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil // Reset audio player
    }
}
