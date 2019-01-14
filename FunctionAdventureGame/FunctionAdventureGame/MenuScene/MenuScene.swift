//
//  MenuScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 11/5/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class MenuScene: SKScene {
    var bgNode: SKSpriteNode!
    var adventureButtonNode: SKSpriteNode!
    var aboutButtonNode: SKSpriteNode!
    var achievementsButtonNode: SKSpriteNode!
    var soundButtonNode: SKSpriteNode!
//    let soundAction = SKAction.repeatForever(SKAction.playSoundFileNamed("music.wav", waitForCompletion: true))
    let soundNode = SKAudioNode(fileNamed: "music.wav")
    var gameNameLabel: SKLabelNode!
    
    var musicOn = true
    
    override func didMove(to view: SKView) {
        
        
        // Set SpriteNode and LabelNode to appropriate position
        adventureButtonNode = self.childNode(withName: "adventureButton") as? SKSpriteNode
        adventureButtonNode.position = CGPoint(x: 0, y: adventureButtonNode.size.height + 20)
        adventureButtonNode.zPosition = 2
//        adventureButtonNode.setScale(1.2)
        aboutButtonNode = self.childNode(withName: "aboutButton") as? SKSpriteNode
        aboutButtonNode.position = CGPoint(x: 0, y: -aboutButtonNode.size.height - 20)
        aboutButtonNode.zPosition = 2
//        aboutButtonNode.setScale(1.2)
        achievementsButtonNode = self.childNode(withName: "achievementsButton") as? SKSpriteNode
        achievementsButtonNode.position = CGPoint(x: 0, y: 0)
        achievementsButtonNode.zPosition = 2
//        achievementsButtonNode.setScale(1.2)
        soundButtonNode = self.childNode(withName: "soundNode") as? SKSpriteNode
        soundButtonNode.position = CGPoint(x: 0, y: -aboutButtonNode.size.height - 40 - soundButtonNode.size.height)
        soundButtonNode.zPosition = 2
        
        
        gameNameLabel = self.childNode(withName: "gameLabel") as? SKLabelNode
        gameNameLabel.zPosition = 2
        gameNameLabel.horizontalAlignmentMode = .center
        
        
        self.addChild(soundNode)
        soundNode.run(SKAction.play())
//        let pling = SKAudioNode(fileNamed: "music.wav")
//        // this is important (or else the scene starts to play the sound in
//        // an infinite loop right after adding the node to the scene).
//        pling.autoplayLooped = false
//        self.addChild(pling)
//        self.run(SKAction.sequence([
//            SKAction.wait(forDuration: 0.5),
//            SKAction.run {
//                // this will start playing the pling once.
//                pling.run(SKAction.play())
//            }
//            ]))
        
        
//        run(soundAction)
//        run(Sound.reward.action)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "adventureButton"{
                let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
                gameLevelScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameLevelScene!)
                
            }
            else if nodesArray.first?.name == "aboutButton"{
                print("Here is about us!!!")
            }
            else if nodesArray.first?.name == "achievementsButton"{
                let achivementScene = AchievementScene(fileNamed: "AchievementScene")
                //                init(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                achivementScene?.scaleMode = .aspectFill
                self.view?.presentScene(achivementScene!)
            }
            else if nodesArray.first?.name == "soundNode"{
                print("turn off the music")
                if(musicOn){
                    soundNode.run(SKAction.stop())
                    musicOn = false
                }
                else{
                    soundNode.run(SKAction.play())
                    musicOn = true
                }
            }
        }
    }
}
