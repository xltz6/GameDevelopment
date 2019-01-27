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
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
//    var soundButtonNode: SKSpriteNode!
    
    var levelLabel = "level 1"
    var beginnerBadgePressed = false
    var competentBadgePressed = false
    var proficientBadgePressed = false
    var expertBadgePressed = false
    
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func didMove(to view: SKView) {
        backgroundNode = self.childNode(withName: "background") as? SKSpriteNode
        backgroundNode.zPosition = -2
        
//        boardNode = self.childNode(withName: "board") as? SKSpriteNode
//        boardNode.zPosition = -3
        alertNode = SKShapeNode(rectOf: CGSize(width: self.frame.size.width/3.8, height: self.frame.size.height/5.7), cornerRadius: 20)
        alertNode.zPosition = 5
        alertNode.position = CGPoint(x: 0, y: 0)
        alertNode.fillColor = UIColor(red:0.75, green:0.86, blue:0.99, alpha:1.0)
        self.addChild(alertNode)
        
        alertLabelNode.horizontalAlignmentMode = .center
        alertLabelNode.verticalAlignmentMode = .center
        alertLabelNode.position = CGPoint(x: -self.frame.size.width/6, y: self.frame.size.height/12)
        alertLabelNode.fontName = "Arial"
        alertLabelNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.6)
        alertLabelNode.fontSize = 20
        alertLabelNode.text = "Get Only One Star in level 1!\n Obtain Beginner Badge!\n Congratulations!"
        alertLabelNode.numberOfLines = 5
        alertLabelNode.preferredMaxLayoutWidth = self.frame.size.width/4.1
        alertLabelNode.zPosition = -3
        self.addChild(alertLabelNode)
        
        backButtonNode = self.childNode(withName: "back") as? SKSpriteNode
        backButtonNode.position = CGPoint(x: backButtonNode.size.width/2 + 40 - self.frame.size.width/2, y: self.frame.size.height/2 - 40 - backButtonNode.size.height/2)
        backButtonNode.zPosition = 2
        
        achievementLabel = self.childNode(withName: "achievementLabel") as? SKLabelNode
        achievementLabel.zPosition = 2
        achievementLabel.horizontalAlignmentMode = .center
        
        level1Node = self.childNode(withName: "l1") as? SKSpriteNode
        level1Node.setScale(1)
        level1Node.alpha = 0.4
        level2Node = self.childNode(withName: "l2") as? SKSpriteNode
        level2Node.setScale(0.85)
        level2Node.alpha = 0.4
        level3Node = self.childNode(withName: "l3") as? SKSpriteNode
        level3Node.setScale(0.85)
        level3Node.alpha = 0.4
        level4Node = self.childNode(withName: "l4") as? SKSpriteNode
        level4Node.setScale(0.85)
        level4Node.alpha = 0.4
        level5Node = self.childNode(withName: "l5") as? SKSpriteNode
        level5Node.setScale(0.85)
        level5Node.alpha = 0.4
        level6Node = self.childNode(withName: "l6") as? SKSpriteNode
        level6Node.setScale(0.85)
        level6Node.alpha = 0.4
        
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
        level1Node.setScale(1.1)
        level1Node.alpha = 1
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
                level1Node.setScale(1.1)
                level1Node.alpha = 1
                badgeAlpha(level: "level1")
                levelLabel = "level 1"
            }
            if nodesArray.first?.name == "l2"{
                reset()
                resetBadgeAlpha()
                level2Node.setScale(1.1)
                level2Node.alpha = 1
                badgeAlpha(level: "level2")
                levelLabel = "level 2"
            }
            if nodesArray.first?.name == "l3"{
                reset()
                resetBadgeAlpha()
                level3Node.setScale(1.1)
                level3Node.alpha = 1
                badgeAlpha(level: "level3")
                levelLabel = "level 3"
            }
            if nodesArray.first?.name == "l4"{
                reset()
                resetBadgeAlpha()
                level4Node.setScale(1.1)
                level4Node.alpha = 1
                badgeAlpha(level: "level4")
                levelLabel = "level 4"
            }
            if nodesArray.first?.name == "l5"{
                reset()
                resetBadgeAlpha()
                level5Node.setScale(1.1)
                level5Node.alpha = 1
                badgeAlpha(level: "level5")
                levelLabel = "level 5"
            }
            if nodesArray.first?.name == "l6"{
                reset()
                resetBadgeAlpha()
                level6Node.setScale(1.1)
                level6Node.alpha = 1
                badgeAlpha(level: "level6")
                levelLabel = "level 6"
            }
            if nodesArray.first?.name == "back"{
                let menuScene = MenuScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFill
                self.view?.presentScene(menuScene!)
            }
            if nodesArray.first?.name == "beginner" {
                beginnerBadgePressed = true
            }
            if nodesArray.first?.name == "competent" {
                competentBadgePressed = true
            }
            if nodesArray.first?.name == "proficient" {
                proficientBadgePressed = true
            }
            if nodesArray.first?.name == "expert" {
                expertBadgePressed = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if beginnerBadgeNode.contains(touch!.location(in: self)) {
            beginnerBadgePressed = false
        }
        if competentBadgeNode.contains(touch!.location(in: self)) {
            competentBadgePressed = false
        }
        if proficientBadgeNode.contains(touch!.location(in: self)) {
            proficientBadgePressed = false
        }
        if expertBadgeNode.contains(touch!.location(in: self)) {
            expertBadgePressed = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        print("beginnerBadgePressed: \(beginnerBadgePressed)")
//        print("competentBadgePressed: \(competentBadgePressed)")
//        print("proficientBadgePressed: \(proficientBadgePressed)")
//        print("expertBadgePressed: \(expertBadgePressed)")
        if beginnerBadgePressed == true && competentBadgePressed == false && proficientBadgePressed == false && expertBadgePressed == false {
            alertNode.zPosition = 5
            alertLabelNode.text = "Get Only One Star in \(levelLabel)!\n Obtain Beginner Badge!\n Congratulations!"
            alertLabelNode.position = CGPoint(x: -self.frame.size.width/6, y: self.frame.size.height/12)
            alertNode.position = CGPoint(x: -self.frame.size.width/6, y: self.frame.size.height/12)
            alertLabelNode.zPosition = 6
        }
        
        if beginnerBadgePressed == false && competentBadgePressed == true && proficientBadgePressed == false && expertBadgePressed == false {
            alertNode.zPosition = 5
            alertLabelNode.text = "Get Two Stars in \(levelLabel)!\n Obtain Competent Badge!\n Congratulations!"
            alertLabelNode.position = CGPoint(x: 20, y: self.frame.size.height/12 + 20)
            alertNode.position = CGPoint(x: 20, y: self.frame.size.height/12 + 20)
            alertLabelNode.zPosition = 6
        }
        
        if beginnerBadgePressed == false && competentBadgePressed == false && proficientBadgePressed == true && expertBadgePressed == false{
            alertNode.zPosition = 5
            alertLabelNode.text = "Get Three Stars in \(levelLabel)!\n Obtain Proficient Badge!\n Congratulations!"
            alertLabelNode.position = CGPoint(x: -self.frame.size.width/12, y: -self.frame.size.height/5)
            alertNode.position = CGPoint(x: -self.frame.size.width/12, y: -self.frame.size.height/5)
            alertLabelNode.zPosition = 6
        }
        if beginnerBadgePressed == false && competentBadgePressed == false && proficientBadgePressed == false && expertBadgePressed == true{
            alertNode.zPosition = 5
            alertLabelNode.text = "Get Three Stars in \(levelLabel)!\n Obtain Expert Badge!\n Congratulations!"
            alertLabelNode.position = CGPoint(x: self.frame.size.width/12, y: -self.frame.size.height/8)
            alertNode.position = CGPoint(x: self.frame.size.width/12, y: -self.frame.size.height/8)
            alertLabelNode.zPosition = 6
        }
        if beginnerBadgePressed == false && competentBadgePressed == false && proficientBadgePressed == false && expertBadgePressed == false{
            alertNode.zPosition = -3
            alertLabelNode.zPosition = -3
        }
    }
    
    
    func reset(){
        level1Node.setScale(0.85)
        level1Node.alpha = 0.4
        level2Node.setScale(0.85)
        level2Node.alpha = 0.4
        level3Node.setScale(0.85)
        level3Node.alpha = 0.4
        level4Node.setScale(0.85)
        level4Node.alpha = 0.4
        level5Node.setScale(0.85)
        level5Node.alpha = 0.4
        level6Node.setScale(0.85)
        level6Node.alpha = 0.4
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

