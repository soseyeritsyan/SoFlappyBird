//
//  GameScene.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 01.03.24.
//

import SpriteKit

struct PhysicsCatagory {
    static let Bird : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var homeButton = SKSpriteNode(imageNamed: "homeButton")
    var soundButton = SKSpriteNode(imageNamed: "soundOn")
    
    var background = SKSpriteNode()
    var Ground = SKSpriteNode()
    var Bird = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    let scoreLabel = SKLabelNode()
   
    var died = Bool()
    var restartButton = SKSpriteNode()
    

    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createButtons() {
        homeButton.position = CGPoint(x: 50, y: 50)
        homeButton.name = "homeButton"
        homeButton.zPosition = 4
        self.addChild(homeButton)
        
        soundButton.position = CGPoint(x: self.size.width - 50, y: 50)
        soundButton.name = "soundButton"
        soundButton.zPosition = 4
        self.addChild(soundButton)
    }
    
    func setupBackground() {
        for i in 0..<2 {
            background = SKSpriteNode(imageNamed: "BackgroundImage")
            background.anchorPoint = CGPointZero
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            
        }
    }
    
    func setupScoreLabel() {
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 3)
        scoreLabel.text = "\(score)"
        scoreLabel.fontName = UIFont.boldSystemFont(ofSize: scoreLabel.fontSize).fontName
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 60
        self.addChild(scoreLabel)
    }
    
    func setupGround() {
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(1)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Bird
        Ground.physicsBody?.contactTestBitMask  = PhysicsCatagory.Bird
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
    }
    
    func setupBird() {
        Bird = SKSpriteNode(imageNamed: "birdImage")
        Bird.size = CGSize(width: 70, height: 70)
        Bird.position = CGPoint(x: self.frame.width / 2 - Bird.frame.width, y: self.frame.height / 2)
        
        Bird.physicsBody = SKPhysicsBody(circleOfRadius: Bird.frame.height / 2)
        Bird.physicsBody?.categoryBitMask = PhysicsCatagory.Bird
        Bird.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Bird.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        Bird.physicsBody?.affectedByGravity = false
        Bird.physicsBody?.isDynamic = true
        
        Bird.zPosition = 2
        
        
        self.addChild(Bird)
    }
    
    func createScene() {
        
        self.physicsWorld.contactDelegate = self
        
        self.setupBackground()
        self.setupScoreLabel()
        self.setupGround()
        self.setupBird()
        self.createButtons()
        
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Bird {
            score += 1
            scoreLabel.text = "\(score)"
            firstBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == PhysicsCatagory.Bird && secondBody.categoryBitMask == PhysicsCatagory.Score {
            score += 1
            scoreLabel.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == PhysicsCatagory.Bird && (secondBody.categoryBitMask == PhysicsCatagory.Wall || secondBody.categoryBitMask == PhysicsCatagory.Ground) {
            gameOver()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        VibrationManager.shared.generateHapticFeedback()

        if gameStarted == false {
            
            gameStarted =  true
            
            Bird.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({ () in
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: difficulty.duration)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Bird.physicsBody?.velocity = CGVectorMake(0, 0)
            Bird.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            
        } else {
            
            if died == true {
                gameOver()
                
            } else {
                Bird.physicsBody?.velocity = CGVectorMake(0, 0)
                Bird.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            }
            
        }

        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)

            for node in nodes {
                if node.name == "homeButton" {
                    transitionToStartGameScene()
                    
                } else if node.name == "soundButton" {
                    soundSetting.addSound.toggle()
                    if soundSetting.addSound {
                        self.soundButton.texture = SKTexture(imageNamed: "soundOn")
                        MusicManager.shared.playBackgroundMusic()
                        
                    } else {
                        self.soundButton.texture = SKTexture(imageNamed: "soundOff")
                        MusicManager.shared.stopBackgroundMusic()
                    }
                }
            }
            
            if died == true {
                if restartButton.contains(location){
                    restartScene()
                    
                }
            }
        }
    }
    
    func createWalls() {
        
        let coinNode = SKSpriteNode(imageNamed: "Coin")
        
        coinNode.size = CGSize(width: 50, height: 50)
        coinNode.position = CGPoint(x: self.frame.width + 40, y: self.frame.height / 2)
        coinNode.physicsBody = SKPhysicsBody(rectangleOf: coinNode.size)
        coinNode.physicsBody?.affectedByGravity = false
        coinNode.physicsBody?.isDynamic = false
        coinNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        coinNode.physicsBody?.collisionBitMask = 0
        coinNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird
        coinNode.color = SKColor.blue
        
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "PipeDown")
        let btmWall = SKSpriteNode(imageNamed: "PipeUp")
        
        topWall.position = CGPoint(x: self.frame.width + 50, y: self.frame.height / 2 + 350)
        btmWall.position = CGPoint(x: self.frame.width + 50, y: self.frame.height / 2 - 350)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Bird
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Bird
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false


        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -150, max: 150)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(coinNode)
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
   
    override func update(_ currentTime: TimeInterval) {
        let backgroundSpeed: CGFloat = difficulty.speed

        if gameStarted, !died {
            enumerateChildNodes(withName: "background", using: { node, _ in
                if let bg = node as? SKSpriteNode {
                    bg.position.x -= backgroundSpeed
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position.x += bg.size.width * 2
                    }
                }
            })
        }
    }

    
    func gameOver() {
        died = true
        Bird.physicsBody?.collisionBitMask = PhysicsCatagory.Ground
        Bird.removeAllActions()
        self.removeAllActions()
        createRestartButton()
        
    }
    
    func createRestartButton() {
        let gameOverLabel = SKLabelNode(fontNamed: "Inter-Black")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 50)
        gameOverLabel.fontColor = UIColor.red
        gameOverLabel.zPosition = 5
        gameOverLabel.fontSize = 32
        self.addChild(gameOverLabel)
        
        restartButton = SKSpriteNode(imageNamed: "RestartBtn")
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 )
        restartButton.zPosition = 6
        addChild(restartButton)
    }
    
    func transitionToStartGameScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let startGameScene = StartGameScene(size: self.size)
        self.view?.presentScene(startGameScene, transition: transition)
    }
}
