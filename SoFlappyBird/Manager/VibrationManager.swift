//
//  VibrationManager.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 03.03.24.
//

import UIKit

class VibrationManager {
    static let shared = VibrationManager()
    
    private init() {}
    
    func toggleVibration() {
        soundSetting.addVibration.toggle()
    }
    
    func generateHapticFeedback() {
        guard soundSetting.addVibration else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}
