//
//  AchievementScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 12/3/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class AchievementScene: SKScene {
    var backgroundNode: SKSpriteNode!
    var backButtonNode: SKSpriteNode!
    var level1Node: SKSpriteNode!
    var level2Node: SKSpriteNode!
    var level3Node: SKSpriteNode!
    var level4Node: SKSpriteNode!
    var level5Node: SKSpriteNode!
    var level6Node: SKSpriteNode!
    var frameNode: SKSpriteNode!
    var beginnerBadgeNode: SKSpriteNode!
    var competentBadgeNode: SKSpriteNode!
    var proficientBadgeNode: SKSpriteNode!
    var expertBadgeNode: SKSpriteNode!
    var achievementLabel: SKLabelNode!
//    var soundButtonNode: SKSpriteNode!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func didMove(to view: SKView) {
        backgroundNode = self.childNode(withName: "background") as? SKSpriteNode
        backgroundNode.zPosition = -2
        
        backButtonNode = self.childNode(withName: "back") as? SKSpriteNode
        backButtonNode.position = CGPoint(x: backButtonNode.size.width/2 + 40 - self.frame.size.width/2, y: self.frame.size.height/2 - 40 - backButtonNode.size.height/2)
        backButtonNode.zPosition = 2
        
        achievementLabel = self.childNode(withName: "achievementLabel") as? SKLabelNode
        achievementLabel.zPosition = 2
        achievementLabel.horizontalAlignmentMode = .center
        
        level1Node = self.childNode(withName: "l1") as? SKSpriteNode
        level1Node.setScale(1)
        level2Node = self.childNode(withName: "l2") as? SKSpriteNode
        level2Node.setScale(0.9)
        level3Node = self.childNode(withName: "l3") as? SKSpriteNode
        level3Node.setScale(0.9)
        level4Node = self.childNode(withName: "l4") as? SKSpriteNode
        level4Node.setScale(0.9)
        level5Node = self.childNode(withName: "l5") as? SKSpriteNode
        level5Node.setScale(0.9)
        level6Node = self.childNode(withName: "l6") as? SKSpriteNode
        level6Node.setScale(0.9)
        
        frameNode = self.childNode(withName: "frame") as? SKSpriteNode
        frameNode.zPosition = 1
        
        beginnerBadgeNode = self.childNode(withName: "beginner") as? SKSpriteNode
//        beginnerBadgeNode.position = CGPoint(x: -20, y: 40)
        beginnerBadgeNode.zPosition = 2
        competentBadgeNode = self.childNode(withName: "competent") as? SKSpriteNode
//        competentBadgeNode.position = CGPoint(x: 100, y: 30)
        competentBadgeNode.zPosition = 2
        proficientBadgeNode = self.childNode(withName: "proficient") as? SKSpriteNode
//        proficientBadgeNode.position = CGPoint(x: -10, y: -100)
        proficientBadgeNode.zPosition = 2
        expertBadgeNode = self.childNode(withName: "expert") as? SKSpriteNode
//        expertBadgeNode.position = CGPoint(x: 90, y: -100)
        expertBadgeNode.zPosition = 2
        
        reset()
        resetBadgeAlpha()
        level1Node.setScale(1)
        badgeAlpha(level: "level1")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "l1"{
                reset()
                resetBadgeAlpha()
                level1Node.setScale(1)
                badgeAlpha(level: "level1")
            }
            else if nodesArray.first?.name == "l2"{
                reset()
                resetBadgeAlpha()
                level2Node.setScale(1)
                badgeAlpha(level: "level2")
            }
            else if nodesArray.first?.name == "l3"{
                reset()
                resetBadgeAlpha()
                level3Node.setScale(1)
                badgeAlpha(level: "level3")
            }
            else if nodesArray.first?.name == "l4"{
                reset()
                resetBadgeAlpha()
                level4Node.setScale(1)
                badgeAlpha(level: "level4")
            }
            else if nodesArray.first?.name == "l5"{
                reset()
                resetBadgeAlpha()
                level5Node.setScale(1)
                badgeAlpha(level: "level5")
            }
            else if nodesArray.first?.name == "l6"{
                reset()
                resetBadgeAlpha()
                level6Node.setScale(1)
                badgeAlpha(level: "level6")
            }
            else if nodesArray.first?.name == "back"{
                let menuScene = MenuScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFill
                self.view?.presentScene(menuScene!)
            }
        }
    }
    
    
    func reset(){
        level1Node.setScale(0.9)
        level2Node.setScale(0.9)
        level3Node.setScale(0.9)
        level4Node.setScale(0.9)
        level5Node.setScale(0.9)
        level6Node.setScale(0.9)
    }
    
    func badgeAlpha(level: String){
        resetBadgeAlpha()
        let number = applicationDelegate.levelRecordDictionary[level] as! [Int]
        if(number[0] == 1){
            beginnerBadgeNode.alpha = 1
        }
        if(number[0] == 2){
            competentBadgeNode.alpha = 1
        }
        if(number[0] == 3){
            proficientBadgeNode.alpha = 1
        }
    }
    
    func resetBadgeAlpha(){
        beginnerBadgeNode.alpha = 0.1
        competentBadgeNode.alpha = 0.1
        proficientBadgeNode.alpha = 0.1
        expertBadgeNode.alpha = 0.1
    }
}

