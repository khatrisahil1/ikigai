//
//  SoundManager.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    // --- UPDATED: The function now accepts a file extension ---
    func playSound(named soundName: String, withExtension fileExtension: String) {
        // --- UPDATED: The url call now uses both the name and the extension ---
        guard let url = Bundle.main.url(forResource: soundName, withExtension: fileExtension) else {
            print("Error: Could not find sound file named \(soundName).\(fileExtension)")
            return
        }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
