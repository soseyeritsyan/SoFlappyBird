//
//  SettingScene.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 01.03.24.
//

import SpriteKit

var difficulty: (speed: CGFloat, duration: TimeInterval) = (speed: 2, duration: 2)
var soundSetting: (addSound: Bool, addVibration: Bool) = (addSound: true, addVibration: false)


class SettingsScene: SKScene {
    var easyButton = SKSpriteNode(imageNamed: "easySelected")
    var mediumButton = SKSpriteNode(imageNamed: "mediumDiselected")
    var hardButton = SKSpriteNode(imageNamed: "hardDiselected")
    var soundButton = SKSpriteNode(imageNamed: "soundSelected")
    var vibrationButton = SKSpriteNode(imageNamed: "vibrationDiselected")
    
    let desiredSize = CGSize(width: 130, height: 30)

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "SettingsImage")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        self.addChild(background)
        createButtons()
        
    }
    
    func createButtons() {

        let gameModes = SKLabelNode(fontNamed: "Inter-Black")
        gameModes.text = "GAME MODES"
        gameModes.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 120)
        gameModes.fontColor = UIColor.black
        gameModes.fontSize = 18
        self.addChild(gameModes)
        
        easyButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 50)
        easyButton.name = "easyButton"
        self.addChild(easyButton)
        
        mediumButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        mediumButton.name = "mediumButton"
        self.addChild(mediumButton)
    
        hardButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 50)
        hardButton.name = "hardButton"
        self.addChild(hardButton)
        
        soundButton.position = CGPoint(x: 100, y: self.size.height / 2 + 250)
        soundButton.size = desiredSize
        soundButton.name = "soundButton"
        self.addChild(soundButton)
        
        vibrationButton.position = CGPoint(x: self.size.width - 100, y: self.size.height / 2 + 250)
        vibrationButton.size = desiredSize
        vibrationButton.name = "vibrationButton"
        self.addChild(vibrationButton)
        
        if difficulty.speed == 2 {
            easySelected()
            
        } else if difficulty.speed == 3 {
            mediomSelected()
            
        } else if difficulty.speed == 4 {
            hardSelected()
        }
        
        soundButtonSetup()
        
        vibrationButtonSetup()

    }
    
    func easySelected() {
        self.easyButton.texture = SKTexture(imageNamed: "easySelected")
        self.mediumButton.texture = SKTexture(imageNamed: "mediumDiselected")
        self.hardButton.texture = SKTexture(imageNamed: "hardDiselected")
    }
    
    func mediomSelected() {
        self.easyButton.texture = SKTexture(imageNamed: "easyDiselected")
        self.mediumButton.texture = SKTexture(imageNamed: "meduimSelected")
        self.hardButton.texture = SKTexture(imageNamed: "hardDiselected")
    }
    
    func hardSelected() {
        self.easyButton.texture = SKTexture(imageNamed: "easyDiselected")
        self.mediumButton.texture = SKTexture(imageNamed: "mediumDiselected")
        self.hardButton.texture = SKTexture(imageNamed: "hardSelected")
        
    }
    
    func soundButtonSetup() {
        if soundSetting.addSound {
            self.soundButton.texture = SKTexture(imageNamed: "soundSelected")
            soundButton.size = desiredSize
            MusicManager.shared.playBackgroundMusic()

        } else {
            self.soundButton.texture = SKTexture(imageNamed: "soundDiselected")
            soundButton.size = desiredSize
            MusicManager.shared.pauseBackgroundMusic()

        }
    }
    
    func vibrationButtonSetup() {
        if soundSetting.addVibration {
            self.vibrationButton.texture = SKTexture(imageNamed: "vibrationSelected")
            vibrationButton.size = desiredSize

        } else {
            self.vibrationButton.texture = SKTexture(imageNamed: "vibrationDiselected")
            vibrationButton.size = desiredSize
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        VibrationManager.shared.generateHapticFeedback()
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            
            for node in nodes {
                handleButtonTap(node)
            }
        }
    }
    
    func handleButtonTap(_ button: SKNode) {
        switch button.name {
        case "easyButton":
            difficulty = (speed: 2, duration: 2)
            easySelected()
            transitionToStartGameScene()
            
        case "mediumButton":
            difficulty = (speed: 3, duration: 1.7)
            mediomSelected()
            transitionToStartGameScene()
            
        case "hardButton":
            difficulty = (speed: 4, duration: 1.2)
            hardSelected()
            transitionToStartGameScene()
        
        case "soundButton":
            soundSetting.addSound.toggle()
            soundButtonSetup()
            
        case "vibrationButton":
            soundSetting.addVibration.toggle()
            vibrationButtonSetup()

        default:
            break
        }
    }
    
    func transitionToStartGameScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let startGameScene = StartGameScene(size: self.size)
        self.view?.presentScene(startGameScene, transition: transition)
    }
}
