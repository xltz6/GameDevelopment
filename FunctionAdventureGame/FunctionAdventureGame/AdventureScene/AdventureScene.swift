//
//  AdventureScene.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 11/5/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit



class AdventureScene: SKScene {
    // Declare nodes
    var bgNode: SKNode?
    var joystick: SKNode?
    var joystickKnob: SKNode?
    var playerNboat: SKNode?
    var flagNode: SKNode?
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var resumeButtonNode: SKNode?
    var woodNode: SKNode?
    var replayButtonNode: SKNode?
    var questionButtonNode: SKNode?
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var endZoneNodeRight: SKNode?
    var endZoneNodeUp: SKNode?
    var functionLabel = SKLabelNode()
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    var tutorialNode: SKNode?
    var tutorialTitleNode = SKLabelNode()
    var tutorialLabelNode = SKLabelNode()
    
    var path = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineShape = SKShapeNode()
    var circleX = SKShapeNode()
    var circleY = SKShapeNode()

    
    var countdownLabel = SKLabelNode()
    var timeCounterLabel: SKLabelNode!
    
    // varibles:
    var backOrReplay = "back"
    var touchflag = false
    var joystickAction = false
    var knobRadius: CGFloat = 100
    var joystickFrozen = true
    var currentLocation = CGPoint(x:0,y:0)
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    var isPlaying = false
    var pause = false
    var tutorialShow = false
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    
    
    //Sprite Engine
    var previousTimeInterval: TimeInterval = 0
    let playerspeed = 1.4
    let waterspeed = (Double(arc4random_uniform(10)) + 5)
    
    
    //Physics Collision
    let flagCategory: UInt32 = 4
    let playerNboatCategory: UInt32 = 2
    let endZoneCategory1: UInt32 = 1

    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Mark: didMove function
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        playerNboat = childNode(withName: "playerNboat")
        playerNboat?.zPosition = 2
        playerNboat?.position = CGPoint(x: 80 - self.frame.size.width/2, y: 100 - self.frame.size.height/2)
        
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        joystick?.zPosition = 2
        joystick?.position = CGPoint(x: 180 - self.frame.size.width/2, y: 180 - self.frame.size.height/2)
        
        bgNode = self.childNode(withName: "backGround")
        bgNode?.zPosition = -1
        flagNode = self.childNode(withName: "flag")
        flagNode?.zPosition = 1
        let randomXPosition = CGFloat(arc4random_uniform(UInt32(70)))
        flagNode?.position = CGPoint(x: self.frame.size.width/2 - 80 - randomXPosition*4, y: self.frame.size.height/2 - self.frame.size.height/7)
        
        woodNode = self.childNode(withName: "wood")
        woodNode!.position = CGPoint(x: -self.frame.size.width/2 + woodNode!.frame.size.width/2 + self.frame.size.width/20, y: 0)
        woodNode!.zPosition = 3
        
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
        self.addChild(tutorialTitleNode)
        
        tutorialLabelNode.horizontalAlignmentMode = .center
        tutorialLabelNode.verticalAlignmentMode = .center
        tutorialLabelNode.position = CGPoint(x: 0, y: -15)
        tutorialLabelNode.fontName = "Arial"
        tutorialLabelNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1)
        tutorialLabelNode.fontSize = 20
        tutorialLabelNode.text = "   Use the joystick to control player going up and down. Your goal is to go across the river and reach the flag! Failing to get to the correct destination will lose a heart. You have three lives for this game. Remember the river has a speed."
        tutorialLabelNode.numberOfLines = 5
        tutorialLabelNode.preferredMaxLayoutWidth = self.frame.size.width/3
        tutorialLabelNode.zPosition = -6
        tutorialLabelNode.alpha = 0
        self.addChild(tutorialLabelNode)
        
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
        
        endZoneNodeRight = self.childNode(withName: "endZone")
        
        endZoneNodeUp = self.childNode(withName: "ednZone2")
        endZoneNodeUp?.zPosition = 3
        
        
        timeCounterLabel = self.childNode(withName: "timeCounter") as? SKLabelNode
        timeCounterLabel.zPosition = 2
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00.00"
        
        // create lives
        fillHearts(count: 3)
        
        countdownLabel.horizontalAlignmentMode = .center
        countdownLabel.verticalAlignmentMode = .center
        countdownLabel.position = CGPoint(x: 0, y: 0)
        countdownLabel.fontName = "AvenirNext-Bold"
        countdownLabel.fontColor = SKColor.black
        countdownLabel.fontSize = self.frame.size.height / 3
        countdownLabel.zPosition = 4
        self.addChild(countdownLabel)
        countdown(count: 3)

//        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        
        functionLabel.horizontalAlignmentMode = .center
        functionLabel.verticalAlignmentMode = .center
        functionLabel.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5 * 2)
        functionLabel.fontName = "Arial"
        functionLabel.fontColor = SKColor.black
        functionLabel.fontSize = 20
        functionLabel.text = "Linear Function"
        functionLabel.zPosition = 6
        self.addChild(functionLabel)
        
        shape.path = UIBezierPath(rect: CGRect(x: -self.frame.size.width/6, y: -self.frame.size.height/6, width: self.frame.size.width/3, height: self.frame.size.height/3)).cgPath
        shape.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5)
//        shape.fillColor = UIColor.red
        shape.alpha = 0.5
        shape.strokeColor = UIColor.black
        shape.lineWidth = 2
        self.addChild(shape)
        
        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        self.addChild(lineShape)
        
        let arrowX = UIBezierPath()
        arrowX.addArrow(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/6 + 40, y: -self.frame.size.height/6 + self.frame.size.height/30 - 20), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor.black
        xCoordinate.lineWidth = 2
        self.addChild(xCoordinate)
        
        let arrowY = UIBezierPath()
        arrowY.addArrow(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/2 - 20, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor.black
        yCoordinate.lineWidth = 2
        self.addChild(yCoordinate)
        
        circleX = SKShapeNode(circleOfRadius: 2) // Size of Circle
        circleX.position = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        circleX.strokeColor = UIColor.red
        circleX.fillColor = UIColor.red
        circleX.glowWidth = 1.0
        self.addChild(circleX)
        
        circleY = SKShapeNode(circleOfRadius: 2) // Size of Circle
        circleY.position = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        circleY.strokeColor = UIColor.red
        circleY.fillColor = UIColor.red
        circleY.glowWidth = 1.0
        self.addChild(circleY)
    }
}



extension UIBezierPath {
    func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
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



// Mark: touch functions
extension AdventureScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // touch the joystickKnob, activate the joystick action
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
        }
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "okButton"{
                if backOrReplay == "back"{
                    pause = false
                    alertNode.zPosition = -5
                    alertLabelNode.zPosition = -6
                    okButtonNode!.zPosition = -6
                    cancelButtonNode!.zPosition = -6
                    let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
                    gameLevelScene?.scaleMode = .aspectFill
                    self.view?.presentScene(gameLevelScene!)
                }
                if backOrReplay == "replay"{
                    pause = false
                    alertNode.zPosition = -5
                    alertLabelNode.zPosition = -6
                    okButtonNode!.zPosition = -6
                    cancelButtonNode!.zPosition = -6
                    let adventureScene = AdventureScene(fileNamed: "AdventureScene")
                    adventureScene?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene!)
                }
            }
            if nodesArray.first?.name == "cancelButton"{
                pause = false
                alertNode.zPosition = -5
                alertLabelNode.zPosition = -6
                okButtonNode!.zPosition = -6
                cancelButtonNode!.zPosition = -6
            }
            
            if nodesArray.first?.name == "backButton"{
                if pause == false {
                    pause = true
    //                showAlertBack(withTitle: "Alert title", message: "Alert message")
                    backOrReplay = "back"
                    alertNode.zPosition = 5
                    alertLabelNode.text = "Do you want to go back to levels?"
                    alertLabelNode.zPosition = 6
                    okButtonNode!.zPosition = 6
                    cancelButtonNode!.zPosition = 6
                }
            }
            if nodesArray.first?.name == "pauseButton"{
                //pause all variables about time.
                if pause == false{
                    pause = true
//                    timer.invalidate()
//                    showAlertResume(withTitle: "Alert", message: "Do you want resume now?")
                    pauseButtonNode?.zPosition = -2
                    resumeButtonNode?.zPosition = 2
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
                }
            }
            if nodesArray.first?.name == "replayButton"{
//                print("replay")
                if pause == false {
                    pause = true
                    backOrReplay = "replay"

                    //                showAlertBack(withTitle: "Alert title", message: "Alert message")
                    alertNode.zPosition = 5
                    alertLabelNode.text = "Do you want to replay this game?"
                    alertLabelNode.zPosition = 6
                    okButtonNode!.zPosition = 6
                    cancelButtonNode!.zPosition = 6
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //determine joystick is a joystick or do nothing. Same to joystickKnob and joystickAction
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        //calculate the distance
        for touch in touches{
            let position = touch.location(in: joystick)
            let length = sqrt(pow(position.x, 2) + pow(position.y, 2))
            let angle = atan2(position.y, position.x)
            
            if(knobRadius > length){
                joystickKnob.position = position
            }
            else{
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when touches ended, get the y coordinate value to move the playerNboat
        for touch in touches{
            let yJoystickCoordinate = touch.location(in: joystick!).y
            let yLimitation = self.frame.size.height - 10
            if yJoystickCoordinate > 0-yLimitation && yJoystickCoordinate < yJoystickCoordinate + yLimitation{
                resetKnobPosition()
            }
        }
    }
}

// Mark Action
extension AdventureScene{
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
            liveNode.position = CGPoint(x: self.frame.size.width/18 - self.frame.size.width/2 + CGFloat(4-live) * liveNode.size.width, y: self.frame.size.height/2 - liveNode.frame.size.height/2 - self.frame.size.width/20)
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
        gameOverScene?.level = 0
        self.view?.presentScene(gameOverScene!)
    }
    
    func invincible(){
        playerNboat?.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){(timer) in
            self.playerNboat?.physicsBody?.categoryBitMask = 2
        }
    }
}


// Mark: Game Loop
extension AdventureScene{
    // count down function before game begins
    func countdown(count: Int) {
        countdownLabel.text = "\(count)"
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                  SKAction.run(countdownAction)])
        
        self.run(SKAction.sequence([SKAction.repeat(counterDecrement, count: 3),
                                     SKAction.run(endCountdown)]))
        
    }
    
    func countdownAction() {
//        print(countdownLabel.text!)
        var count = Int(countdownLabel.text!)!
        count = count - 1
        countdownLabel.text = "\(count)"
    }
    
    func endCountdown() {
        countdownLabel.text = ""
        joystickFrozen = false
    }

    @objc func updateTimer() {
        
        // Calculate total time since timer started in seconds
//        var currentTime = Date().timeIntervalSinceReferenceDate - startTime
        timerCount += 1
        // Calculate minutes
        let timeString = String(format: "%02d:%02d:%02d", timerCount/3600, (timerCount/60)%60, timerCount%60)
        timeCounterLabel.text = "Time: \(timeString)"
        
    }

    
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        if deltaTime < 0.1{
            let woodmovement = CGVector(dx: (CGFloat)(deltaTime * 8.0 * waterspeed), dy: 0)
            woodNode!.run(SKAction.move(by: woodmovement, duration: 0))
        }
        
        if pause == true{
//            print("stop timer")
            timer.invalidate()
            isPlaying = false
        }
        if pause == false{
            if isPlaying == false{
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            isPlaying = true
        }
        
        guard let joystickKnob = joystickKnob else{ return}
        
        if joystickFrozen == false && pause == false && touchflag == false{
            
            let yPosition = Double(joystickKnob.position.y)
            let displacement = CGVector(dx: (CGFloat)(deltaTime * 8.0 * waterspeed), dy: (CGFloat)(deltaTime * yPosition * playerspeed))
            let move = SKAction.move(by: displacement, duration: 0)
            playerNboat?.run(move)
            
            path.addLine(to: CGPoint(x: currentLocation.x + displacement.dx/3, y: currentLocation.y + displacement.dy/3))
            path.move(to: CGPoint(x: currentLocation.x + displacement.dx/3, y: currentLocation.y + displacement.dy/3))
            
            circleX.run(SKAction.move(to: CGPoint(x: currentLocation.x + displacement.dx/3, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), duration: 0))
            circleY.run(SKAction.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: currentLocation.y + displacement.dy/3), duration: 0))
            
            currentLocation = CGPoint(x:currentLocation.x + displacement.dx/3, y:currentLocation.y + displacement.dy/3)
            
            lineShape.path = path
            lineShape.strokeColor = UIColor.black
            lineShape.lineWidth = 2
        }
    }
}


// Mark: Game collision
extension AdventureScene: SKPhysicsContactDelegate{
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

        if (firstBody.categoryBitMask & endZoneCategory1) != 0 && (secondBody.categoryBitMask & playerNboatCategory) != 0{
            playerTouchUp(playerNboatNode: firstBody.node!, endZoneNodeUp: secondBody.node!)
        }
        if (firstBody.categoryBitMask & playerNboatCategory) != 0 && (secondBody.categoryBitMask & flagCategory) != 0{
            playerTouchFlag(playerNboat: firstBody.node!, flagNode: secondBody.node!)
        }
    }
    
    func playerTouchUp(playerNboatNode: SKNode, endZoneNodeUp: SKNode) {
        let loss = SKAction.move(to: CGPoint(x: 80 - self.frame.size.width/2, y: 100 - self.frame.size.height/2), duration: 0.0)
        playerNboat!.run(loss)
        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        woodNode!.position = CGPoint(x: -self.frame.size.width/2 + woodNode!.frame.size.width/2 + self.frame.size.width/20, y: 0)
        loseHeart()
        countdown(count: 3)
    }
    
    func playerTouchFlag(playerNboat: SKNode, flagNode: SKNode){
        touchflag = true
        run(Sound.applaud.action)
        lineShape.run(SKAction.repeat(.sequence([
            .fadeAlpha(to: 0.2, duration: 0.05),
            .wait(forDuration: 0.1),
            .fadeAlpha(to: 1.0, duration: 0.05),
            .wait(forDuration: 0.1),
            ]), count: 6))
        
        //update the plist file
        var number = applicationDelegate.levelRecordDictionary["level1"] as! [Int]
        print(number[1])
        if self.heartsArray.count > number[0] {
            number[0] = self.heartsArray.count
        }
        if self.timerCount < number[1] {
            number[1] = self.timerCount
        }
        print(self.timerCount)
        print(number)
        applicationDelegate.levelRecordDictionary.setValue(number, forKey: "level1")
        delay(1.8){
            let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
            gameSuccessScene?.scaleMode = .aspectFill
            gameSuccessScene!.performanceLevel = self.heartsArray.count
            gameSuccessScene!.level = 0
            self.view?.presentScene(gameSuccessScene!)
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

// Alert Action
extension AdventureScene{
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
        
        let vc = self.scene?.view?.window?.rootViewController
        vc?.show(alertController, sender: nil)
        if vc?.presentingViewController == nil {
            print("hello")
        }
        if vc!.presentedViewController == nil {
            print("could present")
            vc!.present(alertController, animated: true, completion: nil)
        }
        else{
            print("there is a view controller")
        }
//        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertReplay(withTitle title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.pause = false
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
            let adventureScene = AdventureScene(fileNamed: "AdventureScene")
            adventureScene?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
//    func showAlertTutorial(withTitle title: String, message: String){
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        alertController.view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height/2)
//
////        alertController.view.tintColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.4)
//
//        let messageMutableString = NSMutableAttributedString(string: message, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 20.0)!])
//        let titleMutableString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 26.0)!])
////        messageMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
////                                          value: UIColor.orange,
////                                          range: NSRange(location: 0, length: message.characters.count));
//
//        alertController.setValue(messageMutableString, forKey: "attributedMessage")
//        alertController.setValue(titleMutableString, forKey: "attributedTitle");
//
////        alertController.preferredContentSize = CGSize(width: self.frame.size.width/2, height: self.frame.size.height/2)
//
//
//
//        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
//            self.pause = false
//        }
//        alertController.addAction(okAction)
//
//        view?.window?.rootViewController?.present(alertController, animated: true)
//    }
}

//protocol Alertable { }
//extension Alertable where Self: SKScene {
//
//    func showAlertResume(withTitle title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "Resume", style: .cancel) { _ in
//            pause = false
//        }
//        alertController.addAction(okAction)
//
//        view?.window?.rootViewController?.present(alertController, animated: true)
//    }
//
//    func showAlertBack(withTitle title: String, message: String) {
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            pause = false
//        }
//        alertController.addAction(cancelAction)
//
//        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
//
//            let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
//            gameLevelScene?.scaleMode = .aspectFill
//            self.view?.presentScene(gameLevelScene!)
//        }
//        alertController.addAction(okAction)
//
//        view?.window?.rootViewController?.present(alertController, animated: true)
//    }
//
//    func showAlertReplay(withTitle title: String, message: String){
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            pause = false
//        }
//        alertController.addAction(cancelAction)
//
//        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
//
//            let adventureScene = AdventureScene(fileNamed: "AdventureScene")
//            adventureScene?.scaleMode = .aspectFill
//            self.view?.presentScene(adventureScene!)
//        }
//        alertController.addAction(okAction)
//
//        view?.window?.rootViewController?.present(alertController, animated: true)
//    }
//}
