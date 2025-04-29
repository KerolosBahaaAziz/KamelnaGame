//
//  SoundManager.swift
//  Kamelna
//
//  Created by Yasser Yasser on 29/04/2025.
//

import Foundation
import AVFoundation

class SoundManager{
    static let shared = SoundManager()
    private var player : AVAudioPlayer?
    
    func playSound(named name: String){
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("❌ Sound file not found: \(name)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("❌ Failed to play sound: \(error.localizedDescription)")
            
        }
    }
}
