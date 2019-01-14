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
            let adventureScene = AdventureScene(fileNamed: "AdventureScene")
            adventureScene?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene!)
        }
    }
}
