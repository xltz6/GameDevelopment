//
//  SettingsScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 2/1/19.
//  Copyright © 2019 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class SettingsScene: SKScene {
    var backButtonNode: SKSpriteNode!
    var resetButtonNode: SKSpriteNode!
    var switchOnButtonNode: SKSpriteNode!
    var switchOffButtonNode: SKSpriteNode!
    var listItemNode: SKSpriteNode!
    var settingsLabel: SKLabelNode!
    var lockNode: SKLabelNode!
    var resetNode: SKLabelNode!
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
//    var switchButton = UISwitch()
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
        backButtonNode = self.childNode(withName: "backButton") as? SKSpriteNode
        backButtonNode.position = CGPoint(x: backButtonNode.size.width/2 + 40 - self.frame.size.width/2, y: self.frame.size.height/2 - 40 - backButtonNode.size.height/2)
        backButtonNode.zPosition = 2
        
        listItemNode = self.childNode(withName: "listItembg") as? SKSpriteNode
        listItemNode.position = CGPoint(x: 0, y: self.frame.size.height/11)
        
        resetButtonNode = self.childNode(withName: "resetButton") as? SKSpriteNode
        resetButtonNode.position = CGPoint(x: listItemNode!.frame.size.width/4, y: self.frame.size.height/4 - 20 - listItemNode.frame.size.height/4)
        resetButtonNode.zPosition = 2
        
        
        settingsLabel = self.childNode(withName: "settingsLabel") as? SKLabelNode
        settingsLabel.zPosition = 2
        settingsLabel.horizontalAlignmentMode = .center
        
        lockNode = self.childNode(withName: "lockLabel") as? SKLabelNode
        lockNode?.zPosition = 2
        
        resetNode = self.childNode(withName: "resetLabel") as? SKLabelNode
        resetNode?.zPosition = 2
        
        switchOnButtonNode = self.childNode(withName: "switchOn") as? SKSpriteNode
        switchOnButtonNode?.zPosition = -2
        switchOnButtonNode?.position = CGPoint(x: listItemNode!.frame.size.width/4, y: self.frame.size.height/11 + listItemNode.frame.size.height*3/8)
        
        switchOffButtonNode = self.childNode(withName: "switchOff") as? SKSpriteNode
        switchOffButtonNode?.zPosition = 2
        switchOffButtonNode?.position = CGPoint(x: listItemNode!.frame.size.width/4, y: self.frame.size.height/11 + listItemNode.frame.size.height*3/8)
        
       
        if applicationDelegate.levelRecordDictionary["unlock"] as! String == "false"{
            switchOffButtonNode?.zPosition = 2
            switchOnButtonNode?.zPosition = -2
        }
        else {
            switchOffButtonNode?.zPosition = -2
            switchOnButtonNode?.zPosition = 2
        }
        
        
        alertNode = SKShapeNode(rectOf: CGSize(width: self.frame.size.width/4, height: self.frame.size.height/6), cornerRadius: 20)
        alertNode.zPosition = -5
        alertNode.position = CGPoint(x: 0, y: self.frame.size.height/25)
        alertNode.fillColor = UIColor(red:0.60, green:0.78, blue:0.20, alpha:1.0)
        self.addChild(alertNode)
        
        alertLabelNode.horizontalAlignmentMode = .center
        alertLabelNode.verticalAlignmentMode = .center
        alertLabelNode.position = CGPoint(x: 0, y: self.frame.size.height/15)
        alertLabelNode.fontName = "Arial"
        alertLabelNode.fontColor = UIColor.black
        alertLabelNode.fontSize = 20
        alertLabelNode.text = "Do you want to go back to levels?"
        alertLabelNode.numberOfLines = 5
        alertLabelNode.preferredMaxLayoutWidth = self.frame.size.width/4.5
        alertLabelNode.zPosition = -6
        self.addChild(alertLabelNode)
        
        okButtonNode = self.childNode(withName: "okButton")
        okButtonNode!.position = CGPoint(x: self.frame.size.width/16, y: self.frame.size.height/25 - okButtonNode!.frame.size.height*3/4)
        okButtonNode?.zPosition = -6
        
        cancelButtonNode = self.childNode(withName: "cancelButton")
        cancelButtonNode!.position = CGPoint(x: -self.frame.size.width/16, y: self.frame.size.height/25 - cancelButtonNode!.frame.size.height*3/4)
        cancelButtonNode?.zPosition = -6
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "backButton"{
                let menuScene = MenuScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFill
                self.view?.presentScene(menuScene!)
            }
            if nodesArray.first?.name == "switchOn"{
                //set switch off
                switchOffButtonNode?.zPosition = 2
                switchOnButtonNode?.zPosition = -2
                applicationDelegate.levelRecordDictionary["unlock"] = "false"
                
            }
            if nodesArray.first?.name == "switchOff"{
                //set switch on
                switchOffButtonNode?.zPosition = -2
                switchOnButtonNode?.zPosition = 2
                applicationDelegate.levelRecordDictionary["unlock"] = "true"
            }
            if nodesArray.first?.name == "resetButton"{
                //reset all achivement
                alertNode.zPosition = 5
                alertLabelNode.text = "Do you want to Reset All Achievements?"
                alertLabelNode.zPosition = 6
                okButtonNode!.zPosition = 6
                cancelButtonNode!.zPosition = 6
            }
            if nodesArray.first?.name == "okButton"{
                alertNode.zPosition = -5
                alertLabelNode.zPosition = -6
                okButtonNode!.zPosition = -6
                cancelButtonNode!.zPosition = -6
                //do reset
                for i in 1 ... 6 {
                    let data = applicationDelegate.levelRecordDictionary["level\(i)"] as! NSDictionary
                    var gameData = data as! Dictionary<String, Int>
                    gameData["highestStar"] = 0
                    gameData["timeCount"] = 100000
                    gameData["beginnerBadge"] = 0
                    gameData["competentBadge"] = 0
                    gameData["proficientBadge"] = 0
                    gameData["expertBadge"] = 0
                
                    applicationDelegate.levelRecordDictionary.setValue(gameData, forKey: "level\(i)")
                }
            }
            if nodesArray.first?.name == "cancelButton"{
                alertNode.zPosition = -5
                alertLabelNode.zPosition = -6
                okButtonNode!.zPosition = -6
                cancelButtonNode!.zPosition = -6
            }
        }
    }
}
