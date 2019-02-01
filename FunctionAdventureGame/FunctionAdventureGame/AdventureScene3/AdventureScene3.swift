//
//  AdventureScene3.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 1/12/19.
//  Copyright © 2019 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit

class AdventureScene3: SKScene, SKPhysicsContactDelegate {
    var playerNode : SKNode?
    var cloudNode1 : SKNode?
    var cloudNode2 : SKNode?
    var cloudNode3 : SKNode?
    var cloudNode4 : SKNode?
    var joystick: SKNode?
    var joystickKnob: SKNode?
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    var endZoneNode: SKNode?
    var functionLabel = SKLabelNode()
    var questionButtonNode: SKNode?
    var tutorialNode: SKNode?
    var tutorialTitleNode = SKLabelNode()
    var tutorialLabelNode = SKLabelNode()
    var funcEquationNode = SKLabelNode()
    var resumeButtonNode: SKNode?
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    
    //Camera
    var cameraNode: SKCameraNode?
    //Player State
    var playerStateMachine: GKStateMachine!
    
    let timeCounterLabel = SKLabelNode()
//    var timeCounterLabel: SKLabelNode!
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    
    var pause = false
    var joystickFrozen = false
    var joystickAction = false
    var joystickFree = true
    var tutorialShow = false
    
    var backOrReplay = "back"
    var currentNode = 1
    var knobRadius : CGFloat = 50.0
    var playerIsFacingRight = true
    let playerspeed = 4.0
    var previousTimeInterval: TimeInterval = 0
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    let heartContainer = SKSpriteNode()
    
    let flagCategory: UInt32 = 0x1 << 0
    let playerCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    let endZoneCategory: UInt32 = 0x1 << 3
    
    // Chart
    var path = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineShape = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func didMove(to view: SKView) {
        self.view!.isMultipleTouchEnabled = true
        
        let a = Double.random(in: 1.6 ... 3)
        print(a)
        
        playerNode = childNode(withName: "player")
        playerNode?.zPosition = 2
        
//        playerNode?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerNode!.frame.size.width, height: playerNode!.frame.size.height * 0.4))
        playerNode?.physicsBody = SKPhysicsBody(rectangleOf: playerNode!.frame.size, center: CGPoint(x: 0, y: playerNode!.frame.size.height * 0.3))
        
        playerNode?.physicsBody?.isDynamic = true
        playerNode?.physicsBody!.affectedByGravity = true
        
        playerNode?.physicsBody?.categoryBitMask = playerCategory
        playerNode?.physicsBody?.contactTestBitMask = endZoneCategory
        playerNode?.physicsBody?.collisionBitMask = groundCategory
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
        
        
        let groundTexture = SKTexture(imageNamed: "ground")
        for i in 1...10  {
            // Create box with defined texture
            let groundNode = SKSpriteNode(texture: groundTexture)
            groundNode.size = CGSize(width: 90, height: 25)
            // Set position of box dynamically
            groundNode.position = CGPoint(x: 120 + self.frame.size.width/18 - self.frame.size.width/2 + CGFloat((i - 1) * 190), y: 150 + self.frame.size.height/6 - self.frame.size.height/2 + CGFloat(pow(a, Double(i - 5)) * 80))
//            groundNode.physicsBody = SKPhysicsBody(rectangleOf: groundNode.frame.size)
//            groundNode.physicsBody?.isDynamic = false
//
//            groundNode.physicsBody?.categoryBitMask = groundCategory
//            groundNode.physicsBody?.contactTestBitMask = playerCategory
//            groundNode.physicsBody?.collisionBitMask = playerCategory
            groundNode.alpha = 0
        
            // Name for easier use (may need to change if you have multiple rows generated)
            groundNode.name = "groundNode\(i)"
            // Add box to scene
            addChild(groundNode)
            
            if i == 10 {
                let destinationNode = SKSpriteNode(texture: SKTexture(imageNamed: "flag"))
                destinationNode.setScale(0.036)
                destinationNode.physicsBody = SKPhysicsBody(rectangleOf: destinationNode.frame.size)
                destinationNode.position = CGPoint(x: groundNode.position.x, y: groundNode.position.y + groundNode.frame.size.height/2 + destinationNode.frame.size.height/2)
                destinationNode.physicsBody?.isDynamic = false
                destinationNode.physicsBody?.categoryBitMask = flagCategory
                destinationNode.physicsBody?.contactTestBitMask = playerCategory
                destinationNode.physicsBody?.collisionBitMask = playerCategory
                addChild(destinationNode)
            }
            
            
            let endzoneNode = SKSpriteNode()
            endzoneNode.size = CGSize(width: 180, height: 25)
            // Set position of box dynamically
            endzoneNode.position = CGPoint(x: groundNode.position.x + groundNode.frame.size.width/2, y: groundNode.position.y - self.frame.size.height/2)
            endzoneNode.physicsBody = SKPhysicsBody(rectangleOf: endzoneNode.frame.size)
            endzoneNode.physicsBody?.isDynamic = false
            
            endzoneNode.physicsBody?.categoryBitMask = endZoneCategory
            endzoneNode.physicsBody?.contactTestBitMask = playerCategory
            endzoneNode.physicsBody?.collisionBitMask = playerCategory
            
            // Name for easier use (may need to change if you have multiple rows generated)
            endzoneNode.name = "ground"+String(i)
            // Add box to scene
            addChild(endzoneNode)
        }
        
        playerNode?.position = CGPoint(x: self.childNode(withName: "groundNode1")!.position.x, y: self.childNode(withName: "groundNode1")!.position.y + playerNode!.frame.size.height)
        
        
        self.childNode(withName: "groundNode1")!.alpha = 1
        
        self.childNode(withName: "groundNode1")!.physicsBody = SKPhysicsBody(rectangleOf: self.childNode(withName: "groundNode1")!.frame.size)
        self.childNode(withName: "groundNode1")!.physicsBody?.isDynamic = false
        
        self.childNode(withName: "groundNode1")!.physicsBody?.categoryBitMask = groundCategory
        self.childNode(withName: "groundNode1")!.physicsBody?.contactTestBitMask = playerCategory
        self.childNode(withName: "groundNode1")!.physicsBody?.collisionBitMask = playerCategory
        
        
        self.childNode(withName: "groundNode2")!.alpha = 1
        
        self.childNode(withName: "groundNode2")!.physicsBody = SKPhysicsBody(rectangleOf: self.childNode(withName: "groundNode2")!.frame.size)
        self.childNode(withName: "groundNode2")!.physicsBody?.isDynamic = false
        
        self.childNode(withName: "groundNode2")!.physicsBody?.categoryBitMask = groundCategory
        self.childNode(withName: "groundNode2")!.physicsBody?.contactTestBitMask = playerCategory
        self.childNode(withName: "groundNode2")!.physicsBody?.collisionBitMask = playerCategory
        
        endZoneNode = self.childNode(withName: "endzone")
        
        cloudNode1 = childNode(withName: "cloud")
        cloudNode2 = childNode(withName: "cloud")
        cloudNode3 = childNode(withName: "cloud")
        cloudNode4 = childNode(withName: "cloud")
        
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        joystick?.zPosition = 3
        joystick?.position = CGPoint(x: self.frame.size.width/10 - self.frame.size.width/2, y: self.frame.size.height/6 - self.frame.size.height/2)
        
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        backButtonNode?.zPosition = 2
        pauseButtonNode = self.childNode(withName: "pauseButton")
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/30 - (pauseButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        pauseButtonNode?.zPosition = 2
        
        resumeButtonNode = self.childNode(withName: "resumeButton")
        resumeButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/30 - (resumeButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (resumeButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        resumeButtonNode?.zPosition = -3
        
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/3 - (replayButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        replayButtonNode?.zPosition = 2
        
        questionButtonNode = self.childNode(withName: "questionButton")
        questionButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (questionButtonNode?.frame.size.height)!/2 - self.frame.size.width/11)
        questionButtonNode?.zPosition = 2

        tutorialNode = self.childNode(withName: "tutorialbg")
        tutorialNode!.zPosition = -5
        tutorialNode!.alpha = 0
        tutorialNode!.position = CGPoint(x: 0, y: 0)

        tutorialTitleNode.horizontalAlignmentMode = .center
        tutorialTitleNode.verticalAlignmentMode = .center
        tutorialTitleNode.position = CGPoint(x: 0, y: self.frame.size.height/8-10)
        tutorialTitleNode.fontName = "Arial"
        tutorialTitleNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.6)
        tutorialTitleNode.fontSize = 26
        tutorialTitleNode.text = "How to Play!"
        tutorialTitleNode.zPosition = -6
        tutorialTitleNode.alpha = 0
        cameraNode?.addChild(tutorialTitleNode)

        tutorialLabelNode.horizontalAlignmentMode = .center
        tutorialLabelNode.verticalAlignmentMode = .center
        tutorialLabelNode.position = CGPoint(x: 0, y: -15)
        tutorialLabelNode.fontName = "Arial"
        tutorialLabelNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.6)
        tutorialLabelNode.fontSize = 20
        tutorialLabelNode.text = "   Choose the moving direction and speed by clicking two buttons. Your goal is to jump across the river and reach the the other side of the mountain! Drop into water and jump too far away will lose a heart. You could try three times for this game."
        tutorialLabelNode.numberOfLines = 5
        tutorialLabelNode.preferredMaxLayoutWidth = self.frame.size.width/3
        tutorialLabelNode.zPosition = -6
        tutorialLabelNode.alpha = 0
        cameraNode?.addChild(tutorialLabelNode)
        
        alertNode = SKShapeNode(rectOf: CGSize(width: self.frame.size.width/4, height: self.frame.size.height/6), cornerRadius: 20)
        alertNode.zPosition = -6
        alertNode.position = CGPoint(x: 0, y: self.frame.size.height/25)
        alertNode.fillColor = UIColor(red:0.60, green:0.78, blue:0.20, alpha:1.0)
        alertNode.alpha = 0
        cameraNode!.addChild(alertNode)
        
        alertLabelNode.horizontalAlignmentMode = .center
        alertLabelNode.verticalAlignmentMode = .center
        alertLabelNode.position = CGPoint(x: 0, y: self.frame.size.height/15)
        alertLabelNode.fontName = "Arial"
        alertLabelNode.fontColor = UIColor.black
        alertLabelNode.fontSize = 20
        alertLabelNode.text = "Do you want to go back to levels?"
        alertLabelNode.numberOfLines = 5
        alertLabelNode.alpha = 0
        alertLabelNode.preferredMaxLayoutWidth = self.frame.size.width/4.5
        alertLabelNode.zPosition = -6
        cameraNode!.addChild(alertLabelNode)
        
        okButtonNode = self.childNode(withName: "okButton")
        okButtonNode!.position = CGPoint(x: self.frame.size.width/16, y: self.frame.size.height/25 - okButtonNode!.frame.size.height*3/4)
        okButtonNode?.zPosition = -6
        okButtonNode?.alpha = 0
        
        cancelButtonNode = self.childNode(withName: "cancelButton")
        cancelButtonNode!.position = CGPoint(x: -self.frame.size.width/16, y: self.frame.size.height/25 - cancelButtonNode!.frame.size.height*3/4)
        cancelButtonNode?.zPosition = -6
        cancelButtonNode?.alpha = 0
        
//        timeCounterLabel = self.childNode(withName: "timeCounter") as? SKLabelNode
        timeCounterLabel.zPosition = 2
//        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        timeCounterLabel.fontSize = 32
        timeCounterLabel.fontName = "AvenirNext-Bold"
        timeCounterLabel.position = CGPoint(x: cameraNode!.position.x, y: cameraNode!.position.y + self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00.00"
        cameraNode?.addChild(timeCounterLabel)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        playerStateMachine = GKStateMachine(states: [
            JumpingState(playerNode: playerNode!),
            WalkingState(playerNode: playerNode!),
            IdleState(playerNode: playerNode!),
            LandingState(playerNode: playerNode!),
            StunnedState(playerNode: playerNode!)
            ])
        playerStateMachine.enter(IdleState.self)
        
        fillHearts(count: 3)
        
        
        functionLabel.horizontalAlignmentMode = .center
        functionLabel.verticalAlignmentMode = .center
        functionLabel.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5 * 2)
        functionLabel.fontName = "AvenirNext"
        functionLabel.fontColor = SKColor.black
        functionLabel.fontSize = 20
        functionLabel.text = "Exponential Function"
        functionLabel.zPosition = 6
        cameraNode!.addChild(functionLabel)
        
        funcEquationNode.horizontalAlignmentMode = .center
        funcEquationNode.verticalAlignmentMode = .center
        funcEquationNode.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/6 * 2)
        funcEquationNode.fontName = "Arial"
        funcEquationNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.6)
        funcEquationNode.fontSize = 26
        let stringA = String(format: "%.2f", a)
        funcEquationNode.text = "y = \(stringA)^x"
        funcEquationNode.zPosition = 6
        cameraNode!.addChild(funcEquationNode)
        
        
        //draw border
        shape.path = UIBezierPath(rect: CGRect(x: -self.frame.size.width/6, y: -self.frame.size.height/6, width: self.frame.size.width/3, height: self.frame.size.height/3)).cgPath
        shape.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5)
        shape.alpha = 0.5
        shape.strokeColor = UIColor.black
        shape.lineWidth = 2
        shape.zPosition = 5
        cameraNode!.addChild(shape)
        
        
        
        //Y axis
        let arrowY = UIBezierPath()
        arrowY.addArrow3(start: CGPoint(x: (self.frame.size.width/3 - 80)/9*4 + self.frame.size.width/6 + 50, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: (self.frame.size.width/3 - 80)/9*4 + self.frame.size.width/6 + 50, y: -self.frame.size.height/6 + self.frame.size.height/30 - 40), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor.black
        yCoordinate.lineWidth = 2
        yCoordinate.zPosition = 5
        cameraNode!.addChild(yCoordinate)
        //X axis
        let arrowX = UIBezierPath()
        arrowX.addArrow3(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/2 - 20, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor.black
        xCoordinate.lineWidth = 2
        xCoordinate.zPosition = 5
        cameraNode!.addChild(xCoordinate)
        
        let temp = (self.frame.size.height/3 - 40) / CGFloat(pow(3, Double(5)))
        
        path.move(to: CGPoint(x: self.frame.size.width/6 + 50, y: 20 + self.frame.size.height/30 - self.frame.size.height/2 + CGFloat(pow(a, Double(1-5))) * temp))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 50, y: 20 + self.frame.size.height/30 - self.frame.size.height/2 + CGFloat(pow(a, Double(1-5))) * temp)
        lineShape.zPosition = 5
        lineShape.strokeColor = UIColor.black
        cameraNode!.addChild(lineShape)
        
        
//        currentLocation.x = self.frame.size.width/6 + 50
//        currentLocation.y = 20 + self.frame.size.height/30 - self.frame.size.height/2 + CGFloat(pow(a, Double(1-5))) * temp
        
        let deltaX = (self.frame.size.width/3 - 80)/9
        let deltaY = 20 + self.frame.size.height/30 - self.frame.size.height/2
        // draw dots
        for i in 1 ... 10 {
            var circle = SKShapeNode(circleOfRadius: 5) // Size of Circle
            circle.position = CGPoint(x: self.frame.size.width/6 + 50 + CGFloat(i-1) * (self.frame.size.width/3 - 80)/9, y: 20 + self.frame.size.height/30 - self.frame.size.height/2 + CGFloat(pow(a, Double(i-5))) * temp)  //Middle of Screen
            circle.strokeColor = UIColor.black
            circle.fillColor = UIColor.black
            circle.glowWidth = 1.0
            circle.name = "circle\(i)"
            cameraNode!.addChild(circle)
            
            if i != 10{
                for j in 1 ... 10{
                    path.addLine(to: CGPoint(x: currentLocation.x + CGFloat(deltaX/10), y: deltaY + CGFloat(pow(a, (Double(i-5) + Double(j) * 0.1))) * temp))
                    path.move(to: CGPoint(x: currentLocation.x + CGFloat(deltaX/10), y: deltaY + CGFloat(pow(a, (Double(i-5) + Double(j) * 0.1))) * temp))
                    currentLocation.x = currentLocation.x + CGFloat(deltaX/10)
                    
                    lineShape.path = path
                    lineShape.strokeColor = UIColor.black
                    lineShape.lineWidth = 3
                    
                }
            }
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
}


// Mark: touch functions
extension AdventureScene3{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if joystickFree == true {
                if let joystickKnob = joystickKnob {
                    joystickFree = false
                    let location = touch.location(in: joystick!)
                    joystickAction = joystickKnob.frame.contains(location)
                }
            }
            let location = touch.location(in: self)
            if !(joystick?.contains(location))! {
//                playerStateMachine.enter(JumpingState.self)
                if pause == false {
                    let textures = SKTexture(imageNamed: "jump")
                    let action = {SKAction.animate(with: [textures], timePerFrame: 0.1)}()
                    playerNode!.run(action)
                    playerNode!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    playerNode!.physicsBody?.angularVelocity = 0
                    playerNode!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
                }
            }
        }
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "okButton"{
                if backOrReplay == "back"{
                    pause = false
                    alertNode.zPosition = -5
                    alertNode.alpha = 0
                    alertLabelNode.zPosition = -6
                    alertLabelNode.alpha = 0
                    okButtonNode!.zPosition = -6
                    cancelButtonNode!.zPosition = -6
                    okButtonNode!.alpha = 0
                    cancelButtonNode!.alpha = 0
                    let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
                    gameLevelScene?.scaleMode = .aspectFill
                    self.view?.presentScene(gameLevelScene!)
                }
                if backOrReplay == "replay"{
                    pause = false
                    alertNode.zPosition = -5
                    alertNode.alpha = 0
                    alertLabelNode.zPosition = -6
                    alertLabelNode.alpha = 0
                    okButtonNode!.zPosition = -6
                    cancelButtonNode!.zPosition = -6
                    okButtonNode!.alpha = 0
                    cancelButtonNode!.alpha = 0
                    let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
                    adventureScene3?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene3!)
                }
            }
            
            if nodesArray.first?.name == "cancelButton"{
                pause = false
                alertNode.zPosition = -5
                alertNode.alpha = 0
                alertLabelNode.zPosition = -6
                alertLabelNode.alpha = 0
                okButtonNode!.zPosition = -6
                cancelButtonNode!.zPosition = -6
                okButtonNode!.alpha = 0
                cancelButtonNode!.alpha = 0
            }
        
            if nodesArray.first?.name == "backButton"{
                if pause == false {
                    pause = true
                    //                showAlertBack(withTitle: "Alert title", message: "Alert message")
                    backOrReplay = "back"
                    alertNode.zPosition = 5
                    alertNode.alpha = 1
                    alertLabelNode.text = "Do you want to go back to levels?"
                    alertLabelNode.zPosition = 6
                    alertLabelNode.alpha = 1
                    okButtonNode!.zPosition = 6
                    cancelButtonNode!.zPosition = 6
                    okButtonNode!.alpha = 1
                    cancelButtonNode!.alpha = 1
                }
            }
            if nodesArray.first?.name == "pauseButton"{
                if pause == false{
                    pause = true
                    pauseButtonNode?.zPosition = -2
                    pauseButtonNode!.alpha = 0
                    resumeButtonNode?.zPosition = 2
                    resumeButtonNode!.alpha = 0
                    resumeButtonNode?.run(SKAction.repeatForever(.sequence([
                        .fadeAlpha(to: 0.2, duration: 0.05),
                        .wait(forDuration: 0.2),
                        .fadeAlpha(to: 1.0, duration: 0.05),
                        .wait(forDuration: 0.2),
                        ])))
                }
            }
            if nodesArray.first?.name == "resumeButton"{
                //pause all variables about time.
                if pause == true{
                    pause = false
                    //                    timer.invalidate()
                    //                    showAlertResume(withTitle: "Alert", message: "Do you want resume now?")
                    pauseButtonNode?.zPosition = 2
                    resumeButtonNode?.zPosition = -2
                    resumeButtonNode?.removeAllActions()
                    pauseButtonNode!.alpha = 1
                    resumeButtonNode!.alpha = 0
                }
            }
            if nodesArray.first?.name == "replayButton"{
                if pause == false {
                    pause = true
                    backOrReplay = "replay"
                    
                    //                showAlertBack(withTitle: "Alert title", message: "Alert message")
                    alertNode.zPosition = 5
                    alertNode.alpha = 1
                    alertLabelNode.text = "Do you want to replay this game?"
                    alertLabelNode.zPosition = 6
                    alertLabelNode.alpha = 1
                    okButtonNode!.zPosition = 6
                    cancelButtonNode!.zPosition = 6
                    okButtonNode!.alpha = 1
                    cancelButtonNode!.alpha = 1
                }
            }
            if nodesArray.first?.name == "questionButton"{

                if tutorialShow == false {
                    //show tutorial
                    if pause == true {return}
                    pause = true
                    tutorialShow = true
                    tutorialNode?.zPosition = 5
                    tutorialTitleNode.zPosition = 6
                    tutorialLabelNode.zPosition = 6
                    tutorialNode?.alpha = 1
                    tutorialTitleNode.alpha = 1
                    tutorialLabelNode.alpha = 1

                }
                else{
                    if tutorialShow == true {
                        tutorialShow = false
                        pause = false
                        //hiden tutorial
                        tutorialNode?.zPosition = -5
                        tutorialTitleNode.zPosition = -6
                        tutorialLabelNode.zPosition = -6
                        tutorialNode?.alpha = 0
                        tutorialTitleNode.alpha = 0
                        tutorialLabelNode.alpha = 0
                    }
                }
            }
        }
    }
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        // Distance
        for touch in touches {
            if joystickFree == false{
                let position = touch.location(in: joystick)
                let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
                let angle = atan2(position.y, position.x)
                
                if knobRadius > length {
                    joystickKnob.position = position
                } else {
                    joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
                }
            }
        }
    }
    
    // Touch End
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimiit: CGFloat = 200.0
            if xJoystickCoordinate > -xLimiit && xJoystickCoordinate < xLimiit{
                resetKnobPosition()
                joystickFree = true
            }
        }
    }
}


//Game Loop
extension AdventureScene3{
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        //camera
        cameraNode!.position.x = playerNode!.position.x - (120 + self.frame.size.width/18 - self.frame.size.width/2)
        cameraNode!.position.y = playerNode!.position.y - (150 + self.frame.size.height/6 - self.frame.size.height/2 + playerNode!.frame.size.height/2)
        joystick?.position.y = cameraNode!.position.y + self.frame.size.height/6 - self.frame.size.height/2
        joystick?.position.x = cameraNode!.position.x + (self.frame.size.width/10 - self.frame.size.width/2)
        backButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/25 - self.frame.size.width/2
        backButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25
    
        pauseButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/2 - self.frame.size.width/30 - (pauseButtonNode?.frame.size.width)!/2
        pauseButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/30
        resumeButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/2 - self.frame.size.width/30 - (resumeButtonNode?.frame.size.width)!/2
        resumeButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (resumeButtonNode?.frame.size.height)!/2 - self.frame.size.width/30
        replayButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/3 - (replayButtonNode?.frame.size.width)!/2
        replayButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/30
        questionButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/25 - self.frame.size.width/2
        questionButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (questionButtonNode?.frame.size.height)!/2 - self.frame.size.width/11
        tutorialNode!.position.x = cameraNode!.position.x
        tutorialNode!.position.y = cameraNode!.position.y
        okButtonNode!.position.x = cameraNode!.position.x + self.frame.size.width/16
        okButtonNode!.position.y = cameraNode!.position.y + self.frame.size.height/25 - okButtonNode!.frame.size.height*3/4
        cancelButtonNode!.position.x = cameraNode!.position.x - self.frame.size.width/16
        cancelButtonNode!.position.y  = cameraNode!.position.y + self.frame.size.height/25 - cancelButtonNode!.frame.size.height*3/4
        
        for index in 0 ..< heartsArray.count{
            heartsArray[index].position.x = cameraNode!.position.x +  self.frame.size.width/8 - self.frame.size.width/2 + CGFloat(index) * heartsArray[0].size.width
            heartsArray[index].position.y = cameraNode!.position.y + self.frame.size.height/2 - heartsArray[0].frame.size.height/2 - self.frame.size.width/20
        }

        guard let joystickKnob = joystickKnob else{ return }
        
        if joystickFrozen == false && pause == false {
            let xPosition = Double(joystickKnob.position.x)
            
            let positivePosition = xPosition < 0 ? -xPosition : xPosition
            if floor(positivePosition) != 0 {
                playerStateMachine.enter(WalkingState.self)
            }
            else{
                playerStateMachine.enter(IdleState.self)
            }
            
            let displacement = CGVector(dx: deltaTime * xPosition * playerspeed, dy: 0)
            let move = SKAction.move(by: displacement, duration: 0)
            //        player?.run(move)
            let faceAction: SKAction!
            let movingRight = xPosition > 0
            let movingLeft = xPosition < 0
            if movingLeft && playerIsFacingRight{
                playerIsFacingRight = false
                let faceMovement = SKAction.scaleX(to: -0.2, duration: 0.0)
                faceAction = SKAction.sequence([move, faceMovement])
            }
            else if movingRight && !playerIsFacingRight{
                playerIsFacingRight = true
                let faceMovement = SKAction.scaleX(to: 0.2, duration: 0.0)
                faceAction = SKAction.sequence([move, faceMovement])
            }
            else{
                faceAction = move
            }
            playerNode?.run(faceAction)
        }
    }
}


//mark: collision
extension AdventureScene3{
    struct Collision {
        enum Masks: Int {
            case flag, player, ground, endzone
            var bitmask: UInt32{
                return 1 << self.rawValue
            }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches(first: Masks, second: Masks) -> Bool{
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
                (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        if collision.matches(first: .player, second: .endzone){
            loseHeart()
            let die = SKAction.move(to: CGPoint(x:120 + self.frame.size.width/18 - self.frame.size.width/2, y: 150 + self.frame.size.height/6 - self.frame.size.height/2 + playerNode!.frame.size.height/2), duration: 0.0)
            playerNode!.run(die)
            let rotateAction = SKAction.rotate(byAngle: CGFloat(-playerNode!.zRotation), duration: 0.0)
            playerNode!.run(rotateAction)
            playerNode!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            playerNode!.physicsBody?.angularVelocity = 0
            
//            isHit = true
            playerStateMachine.enter(StunnedState.self)
            
            for i in 1 ... 10{
                (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).strokeColor = UIColor.black
                (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).fillColor = UIColor.black
            }
        }
        
        if collision.matches(first: .player, second: .ground){
            playerStateMachine.enter(LandingState.self)
            
            if let currentGroundNode = contact.bodyA.node as? SKSpriteNode {                let nodeName = currentGroundNode.name!
                if nodeName == "player" {
                    let currentNodeName = contact.bodyB.node!.name!
//                    print(currentNodeName )
                    let number = Int(currentNodeName.suffix(1))!
                    
                    for i in 1 ... 10{
                        if i <= number{
                            (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).strokeColor = UIColor.red
                            (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).fillColor = UIColor.red
                            (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 3))
                        }
                        else{
                            (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).strokeColor = UIColor.black
                            (cameraNode?.childNode(withName: "circle\(i)") as! SKShapeNode).fillColor = UIColor.black
                        }
                    }
                    
//                    print(number)
                    if number != 10 {
                        let nextNodeName = "groundNode\(number+1)"
                        self.childNode(withName: nextNodeName)!.alpha = 1
                        self.childNode(withName: nextNodeName)!.physicsBody = SKPhysicsBody(rectangleOf: self.childNode(withName: nextNodeName)!.frame.size)
                        self.childNode(withName: nextNodeName)!.physicsBody?.isDynamic = false

                        self.childNode(withName: nextNodeName)!.physicsBody?.categoryBitMask = groundCategory
                        self.childNode(withName: nextNodeName)!.physicsBody?.contactTestBitMask = playerCategory
                        self.childNode(withName: nextNodeName)!.physicsBody?.collisionBitMask = playerCategory
                    }
                }
            }
            else if let currentGroundNode = contact.bodyB.node as? SKSpriteNode {                let nodeName = currentGroundNode.name!
                if nodeName == "player" {
                    let currentNodeName = contact.bodyB.node!.name!
//                    print(currentNodeName)
                    let number = Int(currentNodeName.suffix(10))
//                    print(number)
                    if number != 10 {
                        let nextNodeName = "groundNode\(number!+1)"
                        self.childNode(withName: nextNodeName)!.alpha = 1
                        self.childNode(withName: nextNodeName)!.physicsBody = SKPhysicsBody(rectangleOf: self.childNode(withName: nextNodeName)!.frame.size)
                        self.childNode(withName: nextNodeName)!.physicsBody?.isDynamic = false
                        
                        self.childNode(withName: nextNodeName)!.physicsBody?.categoryBitMask = groundCategory
                        self.childNode(withName: nextNodeName)!.physicsBody?.contactTestBitMask = playerCategory
                        self.childNode(withName: nextNodeName)!.physicsBody?.collisionBitMask = playerCategory
                    }
                }
            }
        }
        
        if collision.matches(first: .player, second: .flag){
            var number = applicationDelegate.levelRecordDictionary["level3"] as! [Int]
            if self.heartsArray.count > number[0] {
                number[0] = self.heartsArray.count
            }
            if self.timerCount < number[1] {
                number[1] = self.timerCount
            }
            applicationDelegate.levelRecordDictionary.setValue(number, forKey: "level3")
            
            let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
            gameSuccessScene?.scaleMode = .aspectFill
            gameSuccessScene!.performanceLevel = self.heartsArray.count
            gameSuccessScene!.level = 3
            self.view?.presentScene(gameSuccessScene!)
        }
    }
}


// Mark Action
extension AdventureScene3{
    func resetKnobPosition(){
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    
    func fillHearts(count: Int){
        heartsArray = [SKSpriteNode]()
        for live in 1 ... count{
            let liveNode = SKSpriteNode(imageNamed: "heart")
            liveNode.position = CGPoint(x: self.frame.size.width/8 - self.frame.size.width/2 + CGFloat(live) * liveNode.size.width, y: self.frame.size.height/2 - liveNode.frame.size.height/2 - self.frame.size.width/20)
            liveNode.zPosition = 5
            liveNode.setScale(1.5)
            self.addChild(liveNode)
            heartsArray.append(liveNode)
        }
    }
    
    
    func loseHeart(){
        joystickFrozen = true
        if self.heartsArray.count > 0{
            //            print(self.heartsArray.count)
            let heartNode = self.heartsArray.first
            heartNode!.removeFromParent()
            self.heartsArray.removeFirst()
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {(timer) in
                self.joystickFrozen = false
            }
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
        gameOverScene!.level = 3
        self.view?.presentScene(gameOverScene!)
    }
    
    func invincible(){
        
    }
}


// Alert Action
extension AdventureScene3{
    func showAlertResume(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Resume", style: .cancel) { _ in
            self.pause = false
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertBack(withTitle title: String, message: String) {
        print("show back alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        print("here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.pause = false
            print("cancel button")
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
            
            let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
            adventureScene3?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene3!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}


extension UIBezierPath {
    func addArrow3(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
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
