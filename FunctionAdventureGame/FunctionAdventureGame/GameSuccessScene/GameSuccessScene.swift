//
//  GameSuccessScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 11/23/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class GameSuccessScene: SKScene {
    var backgroundNode: SKSpriteNode!
    var menuButton: SKSpriteNode!
    var nextButton: SKSpriteNode!
    
    var performanceLevel = 0
    var level = 0
    
    override func didMove(to view: SKView) {
        backgroundNode = SKSpriteNode(imageNamed: "congratulations\(performanceLevel)")
        backgroundNode.position = CGPoint(x: 0, y: 0)
        backgroundNode.setScale(0.5)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
        
        menuButton = SKSpriteNode(imageNamed: "chooseLevelButton")
        menuButton.position = CGPoint(x: -self.frame.size.width/4, y: -self.frame.size.height/2 + 110)
        menuButton.zPosition = 2
        nextButton = SKSpriteNode(imageNamed: "nextLevelButton")
        nextButton.position = CGPoint(x: self.frame.size.width/4, y: -self.frame.size.height/2 + 110)
        
        self.addChild(menuButton)
        self.addChild(nextButton)
        run(Sound.reward.action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        
        if menuButton.contains(touch!.location(in: self)) {
            let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
            gameLevelScene?.scaleMode = .aspectFill
            self.view?.presentScene(gameLevelScene!)
        }
   
        if nextButton.contains(touch!.location(in: self)) {
            if level == 0 {
                let adventureScene2 = AdventureScene2(fileNamed: "AdventureScene2")
                adventureScene2?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene2!)
            }
            if level == 2{
                let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
                adventureScene3?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene3!)
            }
//            if level == 3{
//                let adventureScene4 = AdventureScene4(fileNamed: "AdventureScene4")
//                adventureScene4?.scaleMode = .aspectFill
//                self.view?.presentScene(adventureScene4!)
//            }
        }
    }
}
