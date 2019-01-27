//
//  GameLevelScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 11/12/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class GameLevelScene: SKScene {
    var gameLevelbgNode: SKNode?
    var levelNode1: SKNode?
    var levelNode2: SKNode?
    var levelNode3: SKNode?
    var levelNode4: SKNode?
    var levelNode5: SKNode?
    var levelNode6: SKNode?
    var backButtonNode: SKNode?
    
    var level2lock = true
    var level3lock = true
    var level4lock = true
    var level5lock = true
    var level6lock = true
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func didMove(to view: SKView) {
        gameLevelbgNode = self.childNode(withName: "gameLevelbg")
        gameLevelbgNode?.zPosition = -1
        
        levelNode1 = self.childNode(withName: "level1")
        levelNode1?.position = CGPoint(x: self.frame.size.width/2 - 90, y: -(35+45))
        for star in 1 ... 3{
            let starNode = SKSpriteNode(imageNamed: "starEmpty")
            starNode.setScale(0.09)
            starNode.position = CGPoint(x: self.frame.size.width/2 - 90 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -(35+47))
            starNode.zPosition = 5
            self.addChild(starNode)
        }
        var number1 = applicationDelegate.levelRecordDictionary["level1"] as! [Int]
        if number1[0] != 0 {
            for star in 1 ... number1[0] {
                let starNode = SKSpriteNode(imageNamed: "starFull")
                starNode.setScale(0.09)
                starNode.position = CGPoint(x: self.frame.size.width/2 - 90 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -(35+47))
                starNode.zPosition = 6
                self.addChild(starNode)
            }
        }
//        else{
//            let lockNode = SKSpriteNode(imageNamed: "lock")
//            lockNode.setScale(0.04)
//            lockNode.position = CGPoint(x: self.frame.size.width/2 - 90 + 45, y: -(35+45) + 10)
//            lockNode.zPosition = 5
//            self.addChild(lockNode)
//        }
        
        levelNode2 = self.childNode(withName: "level2")
        levelNode2?.position = CGPoint(x: self.frame.size.width/6, y: -self.frame.size.height/3)
        for star in 1 ... 3{
            let starNode = SKSpriteNode(imageNamed: "starEmpty")
            starNode.setScale(0.09)
            starNode.position = CGPoint(x: self.frame.size.width/6 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -self.frame.size.height/3 - 2)
            starNode.zPosition = 5
            self.addChild(starNode)
        }
        var number2 = applicationDelegate.levelRecordDictionary["level2"] as! [Int]
        if number2[0] != 0 {
            for star in 1 ... number2[0] {
                let starNode = SKSpriteNode(imageNamed: "starFull")
                starNode.setScale(0.09)
                starNode.position = CGPoint(x: self.frame.size.width/6 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -self.frame.size.height/3 - 2)
                starNode.zPosition = 6
                self.addChild(starNode)
            }
        }
        if number1[0] != 3 {
            level2lock = true
            let lockNode = SKSpriteNode(imageNamed: "lock")
            lockNode.setScale(0.04)
            lockNode.position = CGPoint(x: self.frame.size.width/6 - 25 + 70, y: -self.frame.size.height/3 + 10)
            lockNode.zPosition = 5
            self.addChild(lockNode)
        }
        else{
            level2lock = false
        }
        
        levelNode3 = self.childNode(withName: "level3")
        levelNode3?.position = CGPoint(x: -self.frame.size.width/6 - 25, y: -self.frame.size.height/3)
        for star in 1 ... 3{
            let starNode = SKSpriteNode(imageNamed: "starEmpty")
            starNode.setScale(0.09)
            starNode.position = CGPoint(x: -self.frame.size.width/6 - 50 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -self.frame.size.height/3 - 2)
            starNode.zPosition = 5
            self.addChild(starNode)
        }
        var number3 = applicationDelegate.levelRecordDictionary["level3"] as! [Int]
        if number3[0] != 0 {
            for star in 1 ... number3[0] {
                let starNode = SKSpriteNode(imageNamed: "starFull")
                starNode.setScale(0.09)
                starNode.position = CGPoint(x: -self.frame.size.width/6 - 50 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -self.frame.size.height/3 - 2)
                starNode.zPosition = 6
                self.addChild(starNode)
            }
        }
        if number2[0] != 3 {
            level3lock = true
            let lockNode = SKSpriteNode(imageNamed: "lock")
            lockNode.setScale(0.04)
            lockNode.position = CGPoint(x: -self.frame.size.width/6 - 50 + 70, y: -self.frame.size.height/3 + 10)
            lockNode.zPosition = 5
            self.addChild(lockNode)
        }
        else{
            level3lock = false
        }
        
        levelNode4 = self.childNode(withName: "level4")
        levelNode4?.position = CGPoint(x: -self.frame.size.width/3, y: 0)
        for star in 1 ... 3{
            let starNode = SKSpriteNode(imageNamed: "starEmpty")
            starNode.setScale(0.09)
            starNode.position = CGPoint(x: -self.frame.size.width/3 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -2)
            starNode.zPosition = 5
            self.addChild(starNode)
        }
        var number4 = applicationDelegate.levelRecordDictionary["level4"] as! [Int]
        if number4[0] != 0 {
            for star in 1 ... number4[0] {
                let starNode = SKSpriteNode(imageNamed: "starFull")
                starNode.setScale(0.09)
                starNode.position = CGPoint(x: -self.frame.size.width/3 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -2)
                starNode.zPosition = 6
                self.addChild(starNode)
            }
        }
        if number3[0] != 3 {
            level4lock = true
            let lockNode = SKSpriteNode(imageNamed: "lock")
            lockNode.setScale(0.04)
            lockNode.position = CGPoint(x: -self.frame.size.width/3 - 25 + 70, y: 10)
            lockNode.zPosition = 5
            self.addChild(lockNode)
        }
        else{
            level4lock = false
        }
        
        levelNode5 = self.childNode(withName: "level5")
        levelNode5?.position = CGPoint(x: 0, y: -levelNode5!.frame.size.height/2)
        for star in 1 ... 3{
            let starNode = SKSpriteNode(imageNamed: "starEmpty")
            starNode.setScale(0.09)
            starNode.position = CGPoint(x: -25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -levelNode5!.frame.size.height/2 - 2)
            starNode.zPosition = 5
            self.addChild(starNode)
        }
        var number5 = applicationDelegate.levelRecordDictionary["level5"] as! [Int]
        if number5[0] != 0 {
            for star in 1 ... number5[0] {
                let starNode = SKSpriteNode(imageNamed: "starFull")
                starNode.setScale(0.09)
                starNode.position = CGPoint(x: -25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: -levelNode5!.frame.size.height/2 - 2)
                starNode.zPosition = 6
                self.addChild(starNode)
            }
        }
        if number4[0] != 3 {
            level5lock = true
            let lockNode = SKSpriteNode(imageNamed: "lock")
            lockNode.setScale(0.04)
            lockNode.position = CGPoint(x: -25 + 70, y: -levelNode5!.frame.size.height/2 + 10)
            lockNode.zPosition = 5
            self.addChild(lockNode)
        }
        else{
            level5lock = false
        }
        
        levelNode6 = self.childNode(withName: "level6")
        levelNode6?.position = CGPoint(x: self.frame.size.width/4, y: levelNode5!.frame.size.height*3/2)
        for star in 1 ... 3{
            let starNode = SKSpriteNode(imageNamed: "starEmpty")
            starNode.setScale(0.09)
            starNode.position = CGPoint(x: self.frame.size.width/4 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: levelNode5!.frame.size.height*3/2 - 2)
            starNode.zPosition = 5
            self.addChild(starNode)
        }
        var number6 = applicationDelegate.levelRecordDictionary["level6"] as! [Int]
        if number6[0] != 0 {
            for star in 1 ... number6[0] {
                let starNode = SKSpriteNode(imageNamed: "starFull")
                starNode.setScale(0.09)
                starNode.position = CGPoint(x: self.frame.size.width/4 - 25 + CGFloat(star - 1) * (starNode.frame.size.width + 2), y: levelNode6!.frame.size.height*3/2 - 2)
                starNode.zPosition = 6
                self.addChild(starNode)
            }
        }
        if number5[0] != 3 {
            level6lock = true
            let lockNode = SKSpriteNode(imageNamed: "lock")
            lockNode.setScale(0.04)
            lockNode.position = CGPoint(x: self.frame.size.width/4 - 25 + 70, y: levelNode6!.frame.size.height*3/2 + 10)
            lockNode.zPosition = 5
            self.addChild(lockNode)
        }
        else{
            level6lock = false
        }
        
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "level1"{
                let adventureScene = AdventureScene(fileNamed: "AdventureScene")
                adventureScene?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene!)
            }
            else if nodesArray.first?.name == "level2"{
                if level2lock == true{
                    showAlertLock(withTitle: "Locked", message: "You can't play this level!")
                }
                else {
                    let adventureScene2 = AdventureScene2(fileNamed: "AdventureScene2")
                    adventureScene2?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene2!)
                }
            }
            else if nodesArray.first?.name == "level3"{
                if level3lock == true{
                    showAlertLock(withTitle: "Locked", message: "You can't play this level!")
                }
                else {
                    let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
                    adventureScene3?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene3!)
                }
            }
            else if nodesArray.first?.name == "level4"{
                if level4lock == true{
                    showAlertLock(withTitle: "Locked", message: "You can't play this level!")
                }
                else {
                    let adventureScene4 = AdventureScene4(fileNamed: "AdventureScene4")
                    adventureScene4?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene4!)
                }
            }
            else if nodesArray.first?.name == "level5"{
//                if level5lock == true{
//                    showAlertLock(withTitle: "Locked", message: "You can't play this level!")
//                }
//                else {
                    let adventureScene5 = AdventureScene5(fileNamed: "AdventureScene5")
                    adventureScene5?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene5!)
//                }
            }
            else if nodesArray.first?.name == "level6"{
//                if level6lock == true{
//                    showAlertLock(withTitle: "Locked", message: "You can't play this level!")
//                }
//                else {
                    let adventureScene6 = AdventureScene6(fileNamed: "AdventureScene6")
                    adventureScene6?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene6!)
//                }
            }
            else if nodesArray.first?.name == "backButton"{
                print("back Button clicked")
                let menuScene = MenuScene(fileNamed: "MenuScene")
                //                init(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                menuScene?.scaleMode = .aspectFill
                self.view?.presentScene(menuScene!)
            }
        }
    }
    
    func showAlertLock(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Locked", style: .cancel) { _ in
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}
