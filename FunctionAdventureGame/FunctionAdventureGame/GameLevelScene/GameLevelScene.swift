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
    var backButtonNode: SKNode?
    

    override func didMove(to view: SKView) {
        gameLevelbgNode = self.childNode(withName: "gameLevelbg")
        gameLevelbgNode?.zPosition = -1
        levelNode1 = self.childNode(withName: "level1")
        levelNode1?.position = CGPoint(x: self.frame.size.width/2 - 90, y: -(35+45))
        levelNode2 = self.childNode(withName: "level2")
        levelNode2?.position = CGPoint(x: self.frame.size.width/6, y: -self.frame.size.height/3)
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Add click function to buttons to switch to different scenes.
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "level1"{
                //                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                //                let adventureScene = AdventureScene.init(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                let adventureScene = AdventureScene(fileNamed: "AdventureScene")
                //                init(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                adventureScene?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene!)
                
            }
            else if nodesArray.first?.name == "level2"{
                let adventureScene2 = AdventureScene2(fileNamed: "AdventureScene2")
                //                init(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                adventureScene2?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene2!)
            }
            else if nodesArray.first?.name == "level3"{
                let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
                //                init(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                adventureScene3?.scaleMode = .aspectFill
                self.view?.presentScene(adventureScene3!)
            }
            else if nodesArray.first?.name == "level4"{
                
            }
            else if nodesArray.first?.name == "level5"{
                
            }
            else if nodesArray.first?.name == "level6"{
                
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
}
