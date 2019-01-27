//
//  AdventureScene6.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 1/20/19.
//  Copyright © 2019 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class AdventureScene6: SKScene, SKPhysicsContactDelegate {
    var bgNodeAd6: SKNode?
    var playerNodeAd6: SKNode?
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    
    // Chart
    var path1 = CGMutablePath()
    var path2 = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineShape1 = SKShapeNode()
    let lineShape2 = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    //x^6,x^5,x^4,x^3,x^2,x^1,x^0,a,temp, x-interval, x-start, y-start, loopNum
    var polyArray: [[Double]] = [[0.0, -1.0, -2.0, 2.0, 3.0, -1.0, 1.0, 4.0, 16.0, 60.0, 2.0, 8.0, 70.0], [0.0, 0.0, -1.0, 0.0, 3.0, -1.0, 3.0, 3.0, 16.0, 50.0, 2.5, 8.0, 70.0], [-0.336, 6.342, -45.194, 149.875, -225.969, 116.283, 19.0, 1.0, 80.0, 70.0, 2.2, 8.0, 80.0], [0.0, 0.0, -0.167, 0.833, -0.5, -0.833, 1, 2.0, 8.0, 60.0, 2.2, 8.0, 70.0], [0.0, 3.0, 7.0, -37.0, -55.0, 58.0, 24.0, 5.0, 570.0, 80.0, 2.2, 100.0, 80.0]]
    let num = 2
    var count: Int = 10
    var heightChange:[CGFloat] = []
    var pause = false
    
    let titleLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        bgNodeAd6 = childNode(withName: "bgAd6")
        bgNodeAd6?.zPosition = -2
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        backButtonNode?.zPosition = 2
        pauseButtonNode = self.childNode(withName: "pauseButton")
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        pauseButtonNode?.zPosition = 2
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/12)
        replayButtonNode?.zPosition = 2
        
        playerNodeAd6 = childNode(withName: "playerAd6")
        playerNodeAd6?.setScale(0.9)
        playerNodeAd6?.zPosition = 3
        playerNodeAd6?.position = CGPoint(x: -self.frame.size.width/CGFloat(polyArray[num][10]), y: -self.frame.size.height/CGFloat(polyArray[num][11])+10)
        
        titleLabel.zPosition = 2
        titleLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        titleLabel.fontSize = 26
        titleLabel.fontName = "Arial"
        titleLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/8)
        titleLabel.text = "How does the height change?"
        self.addChild(titleLabel)
        
        
        //draw border
//        shape.path = UIBezierPath(rect: CGRect(x: -self.frame.size.width/6, y: -self.frame.size.height/6, width: self.frame.size.width/3, height: self.frame.size.height/3)).cgPath
//        shape.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5)
//        shape.alpha = 0.5
//        shape.strokeColor = UIColor.black
//        shape.lineWidth = 2
//        shape.zPosition = 2
//        self.addChild(shape)
        
        path1.move(to: CGPoint(x: -self.frame.size.width/CGFloat(polyArray[num][10]), y: -self.frame.size.height/CGFloat(polyArray[num][11])))
        currentLocation = CGPoint(x: -self.frame.size.width/CGFloat(polyArray[num][10]), y: -self.frame.size.height/CGFloat(polyArray[num][11]))
        lineShape1.zPosition = 2
        lineShape1.strokeColor = UIColor.black
        self.addChild(lineShape1)
        //-x^5 - 2x^4 + 2x^3 + 3x^2 - x + 1
        //0x^5 - x^4 + 0x^3 + 3x^2 - x
        //-0.3x^6 + 6x^5 - 45x^4 + 150x^3 - 226x^2 + 116x + 19
        //0.0x^6 + 0.0x^5 -0.167x^4 + 0.833x^3 -0.5x^2 -0.833x + 1.0 (1/6(x-1)^2(x+1)(x-4))
        //0.0x^6 + 3.0x^5+ 7.0x^4 -37.0x^3 -55.0x^2 + 58.0x +24.0 ()
        //x6−32x5+405x4−2570x3+8560x2−14208x+9216 ((x-2)(x-3)^2(x-8)^3)
        let a = polyArray[num][7]
        
        for i in 10 ... Int(polyArray[num][12]){
            let part0 = polyArray[num][6] * pow(Double(i)/10.0 - a, Double(0))
            let part1 = polyArray[num][5] * pow(Double(i)/10.0 - a, Double(1))
            let part2 = polyArray[num][4] * pow(Double(i)/10.0 - a, Double(2))
            let part3 = polyArray[num][3] * pow(Double(i)/10.0 - a, Double(3))
            let part4 = polyArray[num][2] * pow(Double(i)/10.0 - a, Double(4))
            let part5 = polyArray[num][1] * pow(Double(i)/10.0 - a, Double(5))
            let part6 = polyArray[num][0] * pow(Double(i)/10.0 - a, Double(6))
            let temp = self.frame.size.height/CGFloat(polyArray[num][8])
            
            let total = part0 + part1 + part2 + part3 + part4 + part5 + part6
            
            if i % 4 == 0 {
//                let circle = SKShapeNode(circleOfRadius: 2) // Size of Circle
//                circle.position = CGPoint(x:  -self.frame.size.width/2 + CGFloat(i-1) * (self.frame.size.width/3)/20, y: -self.frame.size.height/8 + CGFloat(total) * temp) //Middle of Screen
//                circle.strokeColor = UIColor.black
//                circle.fillColor = UIColor.black
//                circle.glowWidth = 1.0
//                circle.name = "circle\(i)"
//                self.addChild(circle)
                let path = CGMutablePath()
                path.move(to: CGPoint(x: currentLocation.x, y: -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp))
                let lineshape = SKShapeNode()
                self.addChild(lineshape)
                path.addLine(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/2))
                path.move(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/2))
                
                lineshape.path = path
                lineshape.strokeColor = UIColor.black
                lineshape.lineWidth = 2
                lineshape.zPosition = 2
            }
            
            path1.addLine(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp))
            path1.move(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp))
            currentLocation.x = currentLocation.x + self.frame.size.width/CGFloat(polyArray[num][9])
            
            lineShape1.path = path1
            lineShape1.strokeColor = UIColor.black
            lineShape1.lineWidth = 3
        }
        currentLocation = CGPoint(x: -self.frame.size.width/CGFloat(polyArray[num][10]), y: -self.frame.size.height/CGFloat(polyArray[num][11]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        let a = polyArray[num][7]
        
        if count >= 10 && count <= Int(polyArray[num][12]) * 10{
            if count % 10 == 0{
                let counter = 10 + (count-10)/10
                let part0 = polyArray[num][6] * pow(Double(counter)/10.0 - a, Double(0))
                let part1 = polyArray[num][5] * pow(Double(counter)/10.0 - a, Double(1))
                let part2 = polyArray[num][4] * pow(Double(counter)/10.0 - a, Double(2))
                let part3 = polyArray[num][3] * pow(Double(counter)/10.0 - a, Double(3))
                let part4 = polyArray[num][2] * pow(Double(counter)/10.0 - a, Double(4))
                let part5 = polyArray[num][1] * pow(Double(counter)/10.0 - a, Double(5))
                let part6 = polyArray[num][0] * pow(Double(counter)/10.0 - a, Double(6))
                let temp = self.frame.size.height/CGFloat(polyArray[num][8])
                
                let total = part0 + part1 + part2 + part3 + part4 + part5 + part6
                
                let action = SKAction.move(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp + 10), duration: 0.25)
                heightChange.append(-self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp + 10 - currentLocation.y)
                
                currentLocation = CGPoint(x: currentLocation.x + self.frame.size.width/CGFloat(polyArray[num][9]), y: -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp + 10)
                playerNodeAd6?.run(action)
            }
            count = count + 1
        }
        else {
            
        }
    }
}

// Mark: touch functions
extension AdventureScene6{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "backButton"{
                pause = true
                showAlertBack(withTitle: "Go Back", message: "Do you want to go back to Game Level Scene")
            }
            if nodesArray.first?.name == "pauseButton"{
                //pause all variables about time.
                pause = true
                //                ]timer.invalidate()
                showAlertResume(withTitle: "Resume", message: "Do you want to resume now?")
            }
            if nodesArray.first?.name == "replayButton"{
                pause = true
                showAlertReplay(withTitle: "Replay", message: "Do you want to replay now?")
            }
        }
    }
}



// Alert Action
extension AdventureScene6{
    func showAlertResume(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Resume", style: .cancel) { _ in
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertBack(withTitle title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
            gameLevelScene?.scaleMode = .aspectFill
            self.view?.presentScene(gameLevelScene!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertReplay(withTitle title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let adventureScene6 = AdventureScene6(fileNamed: "AdventureScene6")
            adventureScene6?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene6!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}


