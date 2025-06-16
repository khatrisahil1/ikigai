//
//  SoundManager.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//  This class manages sound playback in the app, allowing sounds to be played by name.

import Foundation
import AVFoundation

class SoundManager {
    // A single, shared instance that the whole app can use.
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundName: String) {
        // Find the sound file in our app's bundle.
        guard let url = Bundle.main.url(forResource: soundName, withExtension: nil) else {
            print("Error: Could not find sound file named \(soundName)")
            return
        }
        
        do {
            // Initialize the audio player with the sound file.
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // Play the sound.
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
