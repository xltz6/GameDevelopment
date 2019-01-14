//
//  AdventureScene2.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 12/21/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class AdventureScene2: SKScene, SKPhysicsContactDelegate{
//    var mountainLeftNode: SKSpriteNode!
//    var mountainRightNode: SKSpriteNode!
//    var backgroundAdventure2: SKSpriteNode!
//    var characterNode: SKSpriteNode!
    var mountainLeftNode: SKNode?
    var mountainRightNode: SKNode?
    var backgroundAdventure2: SKNode?
    var backgroundAdventure2Node: SKNode?
    var characterNode: SKNode?
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    var directionNode: SKNode?
    var directionButtonNode: SKNode?
    var speedNode: SKNode?
    var speedBarNode: SKNode?
    var speedButtonNode: SKNode?
    var endZoneNode: SKNode?
    
//    var cameraNode: SKCameraNode?
    var timeCounterLabel: SKLabelNode!
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    
    var force = false
    var pause = false
    var isPlaying = false
    var directionChosen = false
    var speedChosen = false
    var previousTimeInterval: TimeInterval = 0
    var previousCharacterNodeX: CGFloat = 0
    var previousCharacterNodeY: CGFloat = 0
    
    var angle: CGFloat = 0
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    
    // Chart
    var path = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineShape = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let characterCategory: UInt32 = 0x1 << 2
    let mountainCategory: UInt32 = 0x1 << 4
    let endZoneCategory: UInt32 = 0x1 << 8
    
    override func didMove(to view: SKView) {
//        self.physicsWorld.contactDelegate = self
//        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        backgroundAdventure2 = childNode(withName: "bgadventure2")
        backgroundAdventure2?.zPosition = 2
        backgroundAdventure2Node = childNode(withName: "bgAd2")
        backgroundAdventure2Node?.zPosition = -1
        
        characterNode = childNode(withName: "character")
        characterNode?.setScale(0.2)
        characterNode?.zPosition = 1
        characterNode?.position = CGPoint(x: 120 + characterNode!.frame.size.width/2 - self.frame.size.width/2, y: 100)
        characterNode?.physicsBody = SKPhysicsBody(rectangleOf: characterNode!.frame.size)
        
        characterNode?.physicsBody?.isDynamic = true
        characterNode?.physicsBody!.affectedByGravity = true

        characterNode?.physicsBody?.categoryBitMask = characterCategory
        characterNode?.physicsBody?.contactTestBitMask = endZoneCategory
        characterNode?.physicsBody?.collisionBitMask = mountainCategory

        previousCharacterNodeX = characterNode!.position.x
        previousCharacterNodeY = characterNode!.position.y
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        mountainLeftNode = childNode(withName: "mountainLeft")
        mountainLeftNode?.setScale(0.6)
        mountainLeftNode?.zPosition = 1
        mountainRightNode = childNode(withName: "mountainRight")
        mountainRightNode?.setScale(0.6)
        mountainRightNode?.zPosition = 1
        
        backgroundAdventure2?.physicsBody = SKPhysicsBody(rectangleOf: backgroundAdventure2!.frame.size)
        
        backgroundAdventure2?.physicsBody?.categoryBitMask = mountainCategory
        backgroundAdventure2?.physicsBody?.contactTestBitMask = characterCategory
        backgroundAdventure2?.physicsBody?.collisionBitMask = characterCategory
        backgroundAdventure2?.physicsBody?.isDynamic = false
        
        mountainLeftNode?.physicsBody = SKPhysicsBody(rectangleOf: mountainLeftNode!.frame.size)
        mountainLeftNode?.physicsBody?.isDynamic = false
        mountainLeftNode?.physicsBody?.categoryBitMask = mountainCategory
        mountainLeftNode?.physicsBody?.contactTestBitMask = characterCategory
        mountainLeftNode?.physicsBody?.collisionBitMask = characterCategory
        mountainRightNode?.physicsBody = SKPhysicsBody(rectangleOf: mountainRightNode!.frame.size)
        mountainRightNode?.physicsBody?.isDynamic = false
        mountainRightNode?.physicsBody?.categoryBitMask = mountainCategory
        mountainRightNode?.physicsBody?.contactTestBitMask = characterCategory
        mountainRightNode?.physicsBody?.collisionBitMask = characterCategory

        angle = CGFloat(Double.random(in: 3.14/18..<3.14/4))
        mountainLeftNode?.zRotation = angle
        mountainRightNode?.zRotation = -angle
//        if mountainLeftNode!.frame.size.height/2 - mountainLeftNode!.frame.size.width/2 * tan(angle) <= 0 {
//            mountainLeftNode!.position = CGPoint(x: mountainLeftNode!.frame.size.width/2 * cos(angle) - self.frame.size.width/2, y: 0)
//        }
//        else{
//            mountainLeftNode!.position = CGPoint(x: mountainLeftNode!.frame.size.width/2 * cos(angle) - self.frame.size.width/2, y: -(mountainLeftNode!.frame.size.height/2 - mountainLeftNode!.frame.size.width/2 * tan(angle)) * cos(angle))
//        }
//        mountainRightNode!.position = CGPoint(x: 50, y: mountainLeftNode!.frame.size.width * sin(angle))
//        characterNode?.position = CGPoint(x: mountainLeftNode!.frame.size.width * cos(angle) - characterNode!.frame.size.width/2 - self.frame.size.width/2, y: mountainLeftNode!.frame.size.width * sin(angle))
        
        
        endZoneNode = self.childNode(withName: "endzone")
        endZoneNode?.physicsBody = SKPhysicsBody(rectangleOf: endZoneNode!.frame.size)
        
        endZoneNode?.physicsBody?.categoryBitMask = endZoneCategory
        endZoneNode?.physicsBody?.contactTestBitMask = characterCategory
        endZoneNode?.physicsBody?.collisionBitMask = characterCategory
        endZoneNode?.physicsBody?.isDynamic = false
        
//        endZoneUpNode = self.childNode(withName: "endzone2")
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        backButtonNode?.zPosition = 2
        pauseButtonNode = self.childNode(withName: "pauseButton")
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        pauseButtonNode?.zPosition = 2
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/12)
        replayButtonNode?.zPosition = 2
        
        directionNode = self.childNode(withName: "direction")
        directionNode?.zPosition = 3
        directionButtonNode = self.childNode(withName: "directionButtonAd2")
        directionButtonNode?.zPosition = 3
        
        speedNode = self.childNode(withName: "speed")
        speedNode?.zPosition = 4
        speedBarNode = self.childNode(withName: "speedBar")
        speedBarNode?.zPosition = 3
        speedButtonNode = self.childNode(withName: "speedButton")
        speedButtonNode?.zPosition = 3
        
        timeCounterLabel = self.childNode(withName: "timeCounter") as? SKLabelNode
        timeCounterLabel.zPosition = 2
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00.00"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // create lives
        fillHearts(count: 3)
        
        let action1 = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration:1.5)
        let action2 = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:1.5)
        let sequence1 = SKAction.sequence([.wait(forDuration: 0.1), action1, action2])
        let repeatAction1 = SKAction.repeatForever(sequence1)
        directionNode!.run(repeatAction1)
        
        let action3 = SKAction.scaleX(to: speedNode!.xScale * 5.6, duration: 1.5)
        let action4 = SKAction.scaleX(to: speedNode!.xScale, duration: 1.5)
        let sequence2 = SKAction.sequence([.wait(forDuration: 0.1), action3, action4])
        let repeatAction2 = SKAction.repeatForever(sequence2)
        speedNode!.run(repeatAction2)
        
        
        shape.path = UIBezierPath(rect: CGRect(x: -self.frame.size.width/6, y: -self.frame.size.height/6, width: self.frame.size.width/3, height: self.frame.size.height/3)).cgPath
        shape.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5)
        //        shape.fillColor = UIColor.red
        shape.alpha = 0.5
        shape.strokeColor = UIColor.black
        shape.lineWidth = 5
        shape.zPosition = 5
        self.addChild(shape)
        
        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        lineShape.zPosition = 5
        self.addChild(lineShape)
        
        let arrowX = UIBezierPath()
        arrowX.addArrow2(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/6 + 40, y: -self.frame.size.height/6 + self.frame.size.height/30 - 20), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor.black
        xCoordinate.lineWidth = 5
        xCoordinate.zPosition = 5
        self.addChild(xCoordinate)
        
        let arrowY = UIBezierPath()
        arrowY.addArrow2(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/2 - 20, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor.black
        yCoordinate.lineWidth = 5
        yCoordinate.zPosition = 5
        self.addChild(yCoordinate)

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
        invincible()
    }

    func dying(){
        //        go to gameoverscene
        //        print("go to gameoverScene")
        let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
        gameOverScene?.scaleMode = .aspectFill
        self.view?.presentScene(gameOverScene!)
    }

    func invincible(){
        characterNode?.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false){(timer) in
            self.characterNode?.physicsBody?.categoryBitMask = self.characterCategory
        }
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
    
    override func update(_ currentTime: TimeInterval) {
        
        if directionChosen == true && speedChosen == true {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            isPlaying = true
        }
        if pause == false && force == false && isPlaying == true {
            let scale = speedNode!.xScale
            print(scale)
            let direction = directionNode!.zRotation
            let x = scale * 300 * cos(direction)
            let y = scale * 300 * sin(direction)
            characterNode?.physicsBody?.applyImpulse(CGVector(dx: x, dy: y))
            force = true
//            cameraNode?.position.y = characterNode!.position.y
        }
        if isPlaying == true{
            path.addLine(to: CGPoint(x: currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3))
            path.move(to: CGPoint(x: currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3))
            currentLocation = CGPoint(x:currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3)
            
            lineShape.path = path
            lineShape.strokeColor = UIColor.black
            lineShape.lineWidth = 5
            
            previousCharacterNodeX = characterNode!.position.x
            previousCharacterNodeY = characterNode!.position.y
        }
    }
}



extension AdventureScene2{
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            secondBody = contact.bodyA
            firstBody = contact.bodyB
        }
        
        if (firstBody.categoryBitMask & characterCategory) != 0 && (secondBody.categoryBitMask & mountainCategory) != 0{
            playerTouchMountain(characterNode: firstBody.node!, backgroundAdventure2: secondBody.node!)
        }
        if (firstBody.categoryBitMask & characterCategory) != 0 && (secondBody.categoryBitMask & endZoneCategory) != 0{
            playerTouchEndZone(characterNode: firstBody.node!, endZoneNode: secondBody.node!)
        }
    }
    
    func playerTouchMountain(characterNode: SKNode, backgroundAdventure2: SKNode) {
//        let loss = SKAction.move(to: CGPoint(x: 80 - self.frame.size.width/2, y: 100 - self.frame.size.height/2), duration: 0.0)
//        playerNboat!.run(loss)
//        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 - self.frame.size.height/2))
//        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 - self.frame.size.height/2)
        
        if isPlaying == true {
            if characterNode.position.x < mountainRightNode!.position.x - mountainRightNode!.frame.size.height/2 || characterNode.position.x > mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2/sin(90-angle) + self.frame.size.width/9 {
                
                loseHeart()
                
                directionChosen = false
                speedChosen = false
                force = false
                isPlaying = false
                
                let loss = SKAction.move(to: CGPoint(x: 100 + characterNode.frame.size.width/2 - self.frame.size.width/2, y: 100), duration: 0.0)
                characterNode.run(SKAction.sequence([.wait(forDuration: 1.5), loss]))
            
                self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                characterNode.physicsBody?.velocity =  CGVector()
                characterNode.physicsBody?.angularVelocity = 0
                characterNode.zRotation = angle
                
                previousCharacterNodeX = 100 + characterNode.frame.size.width/2 - self.frame.size.width/2
                previousCharacterNodeY = 100
                path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
                currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
                
                directionNode?.zRotation = 0
                speedNode?.xScale = 0.323
                
                let action1 = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration:1.5)
                let action2 = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:1.5)
                let sequence1 = SKAction.sequence([.wait(forDuration: 0.1), action1, action2])
                let repeatAction1 = SKAction.repeatForever(sequence1)
                directionNode!.run(repeatAction1)
                
                let action3 = SKAction.scaleX(to: speedNode!.xScale * 5.6, duration: 1.5)
                let action4 = SKAction.scaleX(to: speedNode!.xScale, duration: 1.5)
                let sequence2 = SKAction.sequence([.wait(forDuration: 0.1), action3, action4])
                let repeatAction2 = SKAction.repeatForever(sequence2)
                speedNode!.run(repeatAction2)
            }
            if characterNode.position.x > mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2/sin(90-angle) && characterNode.position.x <= mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2/sin(90-angle) + self.frame.size.width/9 {
                print("success")
                var number = applicationDelegate.levelRecordDictionary["level2"] as! [Int]
                print(number[1])
                if self.heartsArray.count > number[0] {
                    number[0] = self.heartsArray.count
                }
                if self.timerCount < number[1] {
                    number[1] = self.timerCount
                }
//                print(self.timerCount)
//                print(number)
                applicationDelegate.levelRecordDictionary.setValue(number, forKey: "level2")
                
                let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
                gameSuccessScene?.scaleMode = .aspectFill
                gameSuccessScene!.performanceLevel = self.heartsArray.count
                gameSuccessScene!.level = 2
                self.view?.presentScene(gameSuccessScene!)
            }
        }
    }
    
    
    func playerTouchEndZone(characterNode: SKNode, endZoneNode: SKNode){
        
        if characterNode.position.y > characterNode.frame.size.height/2{
            
            loseHeart()
            
            directionChosen = false
            speedChosen = false
            force = false
            isPlaying = false
            let loss = SKAction.move(to: CGPoint(x: 100 + characterNode.frame.size.width/2 - self.frame.size.width/2, y: 100), duration: 0.0)
            characterNode.run(SKAction.sequence([.wait(forDuration: 3), loss]))
            

            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            characterNode.physicsBody?.velocity =  CGVector()
            characterNode.physicsBody?.angularVelocity = 0
            characterNode.zRotation = angle
            
            previousCharacterNodeX = 100 + characterNode.frame.size.width/2 - self.frame.size.width/2
            previousCharacterNodeY = 100
            path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
            currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
            
            directionNode?.zRotation = 0
            speedNode?.xScale = 0.323
            
            let action1 = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration:1.5)
            let action2 = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:1.5)
            let sequence1 = SKAction.sequence([.wait(forDuration: 0.1), action1, action2])
            let repeatAction1 = SKAction.repeatForever(sequence1)
            directionNode!.run(repeatAction1)
            
            let action3 = SKAction.scaleX(to: speedNode!.xScale * 5.6, duration: 1.5)
            let action4 = SKAction.scaleX(to: speedNode!.xScale, duration: 1.5)
            let sequence2 = SKAction.sequence([.wait(forDuration: 0.1), action3, action4])
            let repeatAction2 = SKAction.repeatForever(sequence2)
            speedNode!.run(repeatAction2)
        }
    }
}

// Mark: touch functions
extension AdventureScene2{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "directionButtonAd2"{
                directionNode!.removeAllActions()
                directionChosen = true
            }
            
            if nodesArray.first?.name == "speedButton"{
                speedNode!.removeAllActions()
                speedChosen = true
            }
            
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
extension AdventureScene2{
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
            
            let adventureScene2 = AdventureScene2(fileNamed: "AdventureScene2")
            adventureScene2?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene2!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}


extension UIBezierPath {
    func addArrow2(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        self.move(to: start)
        self.addLine(to: end)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        
        self.addLine(to: arrowLine1)
        self.move(to: end)
        self.addLine(to: arrowLine2)
    }
}