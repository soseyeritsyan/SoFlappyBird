//
//  StartGameScene.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 01.03.24.
//

import SpriteKit

class StartGameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        
        if soundSetting.addSound {
            MusicManager.shared.playBackgroundMusic()
        } else {
            MusicManager.shared.pauseBackgroundMusic()
        }
        
        // Set up background
        let background = SKSpriteNode(imageNamed: "startGameImage")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        self.addChild(background)
        
        // Add start button
        let startButton = SKSpriteNode(imageNamed: "StartButtonImage")
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startButton.name = "startButton"
        self.addChild(startButton)
        
        // Add settings button
        let settingsButton = SKSpriteNode(imageNamed: "SettingButtonimage")
        settingsButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 60)
        settingsButton.name = "settingsButton"
        self.addChild(settingsButton)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        VibrationManager.shared.generateHapticFeedback()
        
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            
            for node in nodes {
                if node.name == "startButton" {
                    startGame()
                } else if node.name == "settingsButton" {
                    settings()
                }
            }
        }
    }
    
    func startGame() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func settings() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = SettingsScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
