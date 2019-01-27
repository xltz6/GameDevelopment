//
//  GameOverScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 11/26/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class GameOverScene: SKScene {
    var gameOverbgNode: SKNode!
    var backLevelButton: SKSpriteNode!
    var replayLevelButton: SKSpriteNode!
    
    var level = 0
    
    override func didMove(to view: SKView) {
        gameOverbgNode = self.childNode(withName: "gameOverBackground")
        gameOverbgNode.zPosition = -1
        backLevelButton = SKSpriteNode(imageNamed: "backLevelButton")
        backLevelButton.position = CGPoint(x: -self.frame.size.width/4, y: -self.frame.size.height/2 + 110)
        backLevelButton.setScale(0.6)
        backLevelButton.zPosition = 2
        replayLevelButton = SKSpriteNode(imageNamed: "replayLevelButton")
        replayLevelButton.position = CGPoint(x: self.frame.size.width/4, y: -self.frame.size.height/2 + 110)
        replayLevelButton.setScale(0.6)
        
        self.addChild(backLevelButton)
        self.addChild(replayLevelButton)
        
        run(Sound.hit.action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        
        if backLevelButton.contains(touch!.location(in: self)) {
            let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
            gameLevelScene?.scaleMode = .aspectFill
            self.view?.presentScene(gameLevelScene!)
        }
        
        if replayLevelButton.contains(touch!.location(in: self)) {
            if level == 0 {
                let adventureScene = AdventureScene(fileNamed: "AdventureScene")
                adventureScene?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene!)
            }
            if level == 2{
                let adventureScene2 = AdventureScene2(fileNamed: "AdventureScene2")
                adventureScene2?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene2!)
            }
            if level == 3{
                let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
                adventureScene3?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene3!)
            }
//            if level == 4{
//                let adventureScene4 = AdventureScene4(fileNamed: "AdventureScene4")
//                adventureScene4?.scaleMode = .aspectFill
//                self.view?.presentScene(adventureScene4!)
//            }
//            if level == 5{
//                let adventureScene5 = AdventureScene5(fileNamed: "AdventureScene5")
//                adventureScene5?.scaleMode = .aspectFill
//                self.view?.presentScene(adventureScene5!)
//            }
//            if level == 6{
//                let adventureScene6 = AdventureScene6(fileNamed: "AdventureScene6")
//                adventureScene6?.scaleMode = .aspectFill
//                self.view?.presentScene(adventureScene6!)
//            }
        }
    }
}
