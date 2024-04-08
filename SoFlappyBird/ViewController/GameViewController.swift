//
//  GameViewController.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 01.03.24.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Create and present the loading scene
            let loadingScene = LoadingScene(size: view.bounds.size)
            loadingScene.scaleMode = .aspectFill
            view.presentScene(loadingScene)
        }

//        if let scene = GameScene(fileNamed:"GameScene") {
//            // Configure the view.
//            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .aspectFill
//            scene.size = self.view.bounds.size
//
//            skView.presentScene(scene)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    func prefersStatusBarHidden() -> Bool {
        return true
    }
}
