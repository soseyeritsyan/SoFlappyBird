//
//  LoadingScene.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 01.03.24.
//

import SpriteKit

class LoadingScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Set up background
        let background = SKSpriteNode(imageNamed: "loadingImage")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        self.addChild(background)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Transition to start game scene or any other scene
            self.transitionToStartGameScene()
        }
    }
    
    func transitionToStartGameScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let startGameScene = StartGameScene(size: self.size)
        self.view?.presentScene(startGameScene, transition: transition)
    }
}
