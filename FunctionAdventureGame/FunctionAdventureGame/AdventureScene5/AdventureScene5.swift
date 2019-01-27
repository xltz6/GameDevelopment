//
//  AdventureScene5.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 1/23/19.
//  Copyright © 2019 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class AdventureScene5: SKScene, SKPhysicsContactDelegate {
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    var ferrisWheelNode: SKNode?
    var playerNodeAd6: SKNode?
    var slideButtonNode: SKNode?
    var slideBarNode: SKNode?
    var speedSlideButtonNode: SKNode?
    var speedSlideBarNode: SKNode?
    
    var pause = false
    var sizeChosen = false
    var speedChosen = false
    var positionChosen = false
    var sizeSlideAction = false
    var speedSlideAction = false
    var moveAction = false
    var gameSuccess = true
    var rotationSpeed: Double = Double(Double.pi/2)
    var moveSpeed = CGFloat(20)
    var radius: Double = 0
    var rotationAngle: Double = 0
    var previousTimeInterval: TimeInterval = 0
    var tickCount = 0
    var nodeNumber = 0
    
    
    var path = CGMutablePath()
    var lineshape = SKShapeNode()
    var path1 = CGMutablePath()
    var lineshape1 = SKShapeNode()
    var path2 = CGMutablePath()
    var lineshape2 = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    var currentLocation1 = CGPoint(x:0,y:0)
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    //Timer
    let timeCounterLabel = SKLabelNode()
    //    var timeCounterLabel: SKLabelNode!
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    
    let titleLabel = SKLabelNode()
    let sizeLabel = SKLabelNode()
    let speedLabel = SKLabelNode()
    
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
        ferrisWheelNode = self.childNode(withName: "ferrisWheel")
        ferrisWheelNode!.position = CGPoint(x: -self.frame.size.width/4, y: 0)
        ferrisWheelNode?.zPosition = 1
        ferrisWheelNode?.setScale(0.4)
        
        radius = Double(ferrisWheelNode!.frame.size.width*10/24)
        
        playerNodeAd6 = self.childNode(withName: "playerNode")
        playerNodeAd6!.position = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius), y: 0)
        playerNodeAd6?.zPosition = 2
        playerNodeAd6?.setScale(0.2)
        
        slideButtonNode = self.childNode(withName: "sliderButton")
        slideButtonNode!.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
        slideButtonNode?.zPosition = 2
        slideBarNode = self.childNode(withName: "slideBar") 
        slideBarNode!.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
        slideBarNode?.zPosition = 1
        
        speedSlideButtonNode = self.childNode(withName: "speedSliderButton")
        speedSlideButtonNode!.position = CGPoint(x: self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
        speedSlideButtonNode?.zPosition = 2
        speedSlideBarNode = self.childNode(withName: "speedSlideBar")
        speedSlideBarNode!.position = CGPoint(x: self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
        speedSlideBarNode?.zPosition = 1
        
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        backButtonNode?.zPosition = 2
        pauseButtonNode = self.childNode(withName: "pauseButton")
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        pauseButtonNode?.zPosition = 2
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/12)
        replayButtonNode?.zPosition = 2
        
        currentLocation = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius),y:0)
        path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
//        print(currentLocation.x)
        lineshape.zPosition = 3
        lineshape.strokeColor = UIColor.black
        self.addChild(lineshape)
        
//        currentLocation1 = CGPoint(x:0 + CGFloat(radius),y:0)
//        path1.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
        lineshape1.zPosition = 4
        lineshape1.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        self.addChild(lineshape1)
        
        path2.move(to: CGPoint(x: 0, y: 0))
        lineshape2.zPosition = 3
        lineshape2.strokeColor = UIColor.white
        self.addChild(lineshape2)
        
        currentLocation1 = CGPoint(x:0,y:0)
        let radiusR = Double.random(in: radius * 0.4 ... radius * 1.2)
        let tempX = Int.random(in: 10 ... 20)
//        print(tempX)
//        print(self.frame.size.width)
        for i in 1 ... 5{
            let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
            circle.position = CGPoint(x: 0 + CGFloat(i-1) * self.frame.size.width/CGFloat(tempX), y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2))) //Middle of Screen
            circle.strokeColor = UIColor.black
            circle.fillColor = UIColor.black
            circle.glowWidth = 1.0
            circle.name = "circle\(i)"
            self.addChild(circle)
            currentLocation1 = CGPoint(x:0 + CGFloat(i-1) * self.frame.size.width/CGFloat(tempX),y: 0)
            if i != 5 {
                for j in 1 ... 20{
                    path2.addLine(to: CGPoint(x: currentLocation1.x + CGFloat(j-1) * self.frame.size.width/CGFloat(tempX)/20, y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + (Double)(j-1) * Double.pi/2/20))))
                    path2.move(to: CGPoint(x: currentLocation1.x + CGFloat(j-1) * self.frame.size.width/CGFloat(tempX)/20, y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + (Double)(j-1) * Double.pi/2/20))))
                    lineshape2.path = path2
                    lineshape2.zPosition = 3
                    lineshape2.strokeColor = UIColor.white
                }
            }
        }

        fillHearts(count: 3)
        
        timeCounterLabel.zPosition = 2
        //        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        timeCounterLabel.fontSize = 32
        timeCounterLabel.fontName = "AvenirNext-Bold"
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00.00"
        self.addChild(timeCounterLabel)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        titleLabel.zPosition = 2
        titleLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        titleLabel.fontSize = 26
        titleLabel.fontName = "Arial"
        titleLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/8)
        titleLabel.text = "Try to make the trigonometric graph as below"
        self.addChild(titleLabel)
        
        sizeLabel.zPosition = 2
        sizeLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        sizeLabel.fontSize = 20
        sizeLabel.numberOfLines = 3
        sizeLabel.preferredMaxLayoutWidth = self.frame.size.width/4
        sizeLabel.fontName = "Arial"
        sizeLabel.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height/3)
        sizeLabel.text = "Drag and move the slide button to change the size of the ferris wheel"
        self.addChild(sizeLabel)
        
        speedLabel.zPosition = 2
        speedLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        speedLabel.fontSize = 20
        speedLabel.numberOfLines = 3
        speedLabel.preferredMaxLayoutWidth = self.frame.size.width/4
        speedLabel.fontName = "Arial"
        speedLabel.position = CGPoint(x: self.frame.size.width/3, y: -self.frame.size.height/3)
        speedLabel.text = "Drag and move the slide button to change the moving speed of the ferris wheel "
        self.addChild(speedLabel)
    }
    
    @objc func updateTimer() {
        
        // Calculate total time since timer started in seconds
        //        var currentTime = Date().timeIntervalSinceReferenceDate - startTime
        if pause == false{
            timerCount += 1
            // Calculate minutes
            let timeString = String(format: "%02d:%02d:%02d", timerCount/3600, (timerCount/60)%60, timerCount%60)
            timeCounterLabel.text = "Time: \(timeString)"
        }
    }
    
    func fillHearts(count: Int){
        heartsArray = [SKSpriteNode]()
        for live in 1 ... count{
            let liveNode = SKSpriteNode(imageNamed: "heart")
            liveNode.position = CGPoint(x: self.frame.size.width/18 - self.frame.size.width/2 + CGFloat(4-live) * liveNode.size.width, y: self.frame.size.height/2 - liveNode.frame.size.height/2 - self.frame.size.width/20)
            liveNode.zPosition = 5
            liveNode.setScale(1.5)
            self.addChild(liveNode)
            heartsArray.append(liveNode)
        }
    }
    
    func loseHeart(){
        
        if self.heartsArray.count > 0{
            //            print(self.heartsArray.count)
            let heartNode = self.heartsArray.first
            heartNode!.removeFromParent()
            self.heartsArray.removeFirst()
            
            run(Sound.jump.action)
        }
        if self.heartsArray.count == 0{
            dying()
        }
        
    }
    
    func dying(){
        //        go to gameoverscene
        //        print("go to gameoverScene")
        let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
        gameOverScene?.scaleMode = .aspectFill
        gameOverScene!.level = 5
        self.view?.presentScene(gameOverScene!)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        path1 = CGMutablePath()
        
        if pause == true {return}
        //240 ticks to finish 2pi
        if sizeChosen == true && speedChosen == true && positionChosen == true{
            
            if rotationAngle >= 2 * Double.pi + rotationSpeed * deltaTime{
                ferrisWheelNode?.alpha = 0
                playerNodeAd6!.alpha = 0
                for i in 1 ... 5 {
                    let positionX1 = (self.childNode(withName: "circle\(i)") as! SKShapeNode).position.x
                    let positionX2 = (self.childNode(withName: "node\(i)") as! SKShapeNode).position.x
                    let positionY1 = (self.childNode(withName: "circle\(i)") as! SKShapeNode).position.y
                    let positionY2 = (self.childNode(withName: "node\(i)") as! SKShapeNode).position.y
//                    print(positionX1 - positionX2)
//                    print(positionY1 - positionY2)
                    if abs(Double(positionX1 - positionX2)) > 10 || abs(Double(positionY1 - positionY2)) > 10 {
                        gameSuccess = false
                        
                    }
                }
                
                if gameSuccess == true {
                    var number = applicationDelegate.levelRecordDictionary["level5"] as! [Int]
                    //                        print(number[1])
                    if self.heartsArray.count > number[0] {
                        number[0] = self.heartsArray.count
                    }
                    if self.timerCount < number[1] {
                        number[1] = self.timerCount
                    }
                    applicationDelegate.levelRecordDictionary.setValue(number, forKey: "level5")
                    
                    let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
                    gameSuccessScene?.scaleMode = .aspectFill
                    gameSuccessScene!.performanceLevel = self.heartsArray.count
                    gameSuccessScene!.level = 5
                    self.view?.presentScene(gameSuccessScene!)
                }
                else{
                    loseHeart()
                    ferrisWheelNode!.position = CGPoint(x: -self.frame.size.width/4, y: 0)
                    ferrisWheelNode?.setScale(0.4)
                    ferrisWheelNode?.alpha = 1
                    ferrisWheelNode?.zRotation = 0
                    radius = Double(ferrisWheelNode!.frame.size.width*10/24)
                    playerNodeAd6!.position = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius), y: 0)
                    playerNodeAd6!.setScale(0.2)
                    playerNodeAd6!.alpha = 1
                    currentLocation = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius),y:0)
                    path = CGMutablePath()
                    path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
                    lineshape.path = path
                    sizeChosen = false
                    speedChosen = false
                    positionChosen = false
                    sizeSlideAction = false
                    speedSlideAction = false
                    moveAction = false
                    gameSuccess = true
                    slideButtonNode!.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
                    speedSlideButtonNode!.position = CGPoint(x: self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
                    for i in 1 ... 5 {
                        if let child = self.childNode(withName: "node\(i)") as? SKShapeNode {
                            child.removeFromParent()
                        }
                    }
                    rotationAngle = 0
                    nodeNumber = 0
                    tickCount = 0
                }
                return
            }
            
            if tickCount % 60 == 0 {
                nodeNumber = nodeNumber + 1
                print(tickCount)
                print(nodeNumber)
                let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
                circle.position = CGPoint(x: currentLocation.x, y: CGFloat(radius * sin(rotationAngle))) //Middle of Screen
                circle.strokeColor = UIColor.red
                circle.fillColor = UIColor.red
                circle.glowWidth = 1.0
                circle.name = "node\(nodeNumber)"
                self.addChild(circle)
            }
            let rotation = SKAction.rotate(byAngle: (CGFloat)(rotationSpeed * deltaTime), duration: 0)
            ferrisWheelNode?.run(rotation)
            rotationAngle = rotationAngle + rotationSpeed * deltaTime
            
//            print(sin(rotationAngle))
            let displacement = CGVector(dx: moveSpeed, dy: 0)
            let move = SKAction.move(by: displacement, duration: 0)
            ferrisWheelNode!.run(move)
            
            let movement = SKAction.move(to: CGPoint(x: currentLocation.x + displacement.dx + CGFloat(radius * (cos(rotationAngle) - 1)), y: CGFloat(radius * sin(rotationAngle))), duration: 0)
            playerNodeAd6?.run(movement)
            
            path.addLine(to: CGPoint(x: currentLocation.x + displacement.dx, y: CGFloat(radius * sin(rotationAngle))))
            path.move(to: CGPoint(x: currentLocation.x + displacement.dx, y: CGFloat(radius * sin(rotationAngle))))
            currentLocation = CGPoint(x:currentLocation.x + displacement.dx, y:currentLocation.y + displacement.dy)
            
            lineshape.path = path
            lineshape.strokeColor = UIColor.black
            lineshape.lineWidth = 3
            lineshape.zPosition = 3
            
            path1.move(to: CGPoint(x: currentLocation.x, y: CGFloat(radius * sin(rotationAngle))))
            path1.addLine(to: CGPoint(x: currentLocation.x + CGFloat(radius * (cos(rotationAngle) - 1)), y: CGFloat(radius * sin(rotationAngle))))
            lineshape1.path = path1
            lineshape1.zPosition = 4
            lineshape1.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
            lineshape1.lineWidth = 3
            lineshape1.zPosition = 4
            
            tickCount = tickCount + 1
        }
    }
}

// Mark: touch functions
extension AdventureScene5{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.slideButtonNode {
                sizeSlideAction = true  //make this true so it will only move when you touch it.
                if sizeChosen == true{
                    sizeSlideAction = false
                }
            }
            if self.atPoint(location) == self.speedSlideButtonNode {
                speedSlideAction = true  //make this true so it will only move when you touch it.
                if speedChosen == true{
                    speedSlideAction = false
                }
            }
            if self.atPoint(location) == self.ferrisWheelNode {
                moveAction = true  //make this true so it will only move when you touch it.
//                if speedChosen == true{
//                    speedSlideAction = false
//                }
            }
        }
        
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
                showAlertResume(withTitle: "Resume", message: "Do you want to resume now?")
            }
            if nodesArray.first?.name == "replayButton"{
                pause = true
                showAlertReplay(withTitle: "Replay", message: "Do you want to replay now?")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sizeSlideAction == false && speedSlideAction == false && moveAction == false { return }
        
        if sizeSlideAction {
            for touch in touches{
                let position = touch.location(in: self)
                if position.x > slideBarNode!.position.x + slideBarNode!.frame.size.width/2 {
                    slideButtonNode!.position = CGPoint(x: slideBarNode!.position.x + slideBarNode!.frame.size.width/2, y: -self.frame.size.height * 3 / 8)
                }
                else if position.x < slideBarNode!.position.x - slideBarNode!.frame.size.width/2 {
                    slideButtonNode!.position = CGPoint(x: slideBarNode!.position.x - slideBarNode!.frame.size.width/2, y: -self.frame.size.height * 3 / 8)
                }
                else{
                    slideButtonNode!.position = CGPoint(x: position.x, y: -self.frame.size.height * 3 / 8)
                }
                let scale = 0.2 + (slideButtonNode!.position.x - (slideBarNode!.position.x - slideBarNode!.frame.size.width/2))/slideBarNode!.frame.size.width * 0.4
                ferrisWheelNode!.setScale(scale)
                playerNodeAd6!.setScale(0.5*scale)
                radius = Double(ferrisWheelNode!.frame.size.width*10/24)
                playerNodeAd6!.position = CGPoint(x: (ferrisWheelNode?.position.x)! + CGFloat(radius), y: 0)
                currentLocation = CGPoint(x: (ferrisWheelNode?.position.x)! + CGFloat(radius),y:0)
                path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
            }
        }
            
        
        if speedSlideAction {
            for touch in touches{
                let position = touch.location(in: self)
                if position.x > speedSlideBarNode!.position.x + speedSlideBarNode!.frame.size.width/2 {
                    speedSlideButtonNode!.position = CGPoint(x: speedSlideBarNode!.position.x + speedSlideBarNode!.frame.size.width/2, y: -self.frame.size.height * 3 / 8)
                }
                else if position.x < speedSlideBarNode!.position.x - speedSlideBarNode!.frame.size.width/2 {
                    speedSlideButtonNode!.position = CGPoint(x: speedSlideBarNode!.position.x - speedSlideBarNode!.frame.size.width/2, y: -self.frame.size.height * 3 / 8)
                }
                else{
                    speedSlideButtonNode!.position = CGPoint(x: position.x, y: -self.frame.size.height * 3 / 8)
                }
                moveSpeed = 1/1200 * self.frame.size.width + (speedSlideButtonNode!.position.x - (speedSlideBarNode!.position.x - speedSlideBarNode!.frame.size.width/2))/speedSlideBarNode!.frame.size.width * 1/1200 * self.frame.size.width
            }
        }
        
        if moveAction {
            for touch in touches{
                let position = touch.location(in: self)
                ferrisWheelNode!.position = CGPoint(x: position.x, y: 0)
                playerNodeAd6!.position = CGPoint(x: (ferrisWheelNode?.position.x)! + CGFloat(radius), y: 0)
                currentLocation = CGPoint(x: (ferrisWheelNode?.position.x)! + CGFloat(radius),y:0)
                path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if sizeSlideAction {
                sizeChosen = true
            }
            sizeSlideAction = false
            if speedSlideAction{
                speedChosen = true
            }
            speedSlideAction = false
            if moveAction{
                positionChosen = true
            }
            moveAction = false
        }
    }
}



// Alert Action
extension AdventureScene5{
    func showAlertResume(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Resume", style: .cancel) { _ in
            self.pause = false
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertBack(withTitle title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.pause = false
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
            self.pause = false
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let adventureScene5 = AdventureScene5(fileNamed: "AdventureScene5")
            adventureScene5?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene5!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}


