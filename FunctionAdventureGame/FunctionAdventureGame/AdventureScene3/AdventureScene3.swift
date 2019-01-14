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
//    var groundNode1 : SKNode?
//    var groundNode2 : SKNode?
//    var groundNode3 : SKNode?
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
    
    var knobRadius : CGFloat = 50.0
    var playerIsFacingRight = true
    let playerspeed = 4.0
    var previousTimeInterval: TimeInterval = 0
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    let heartContainer = SKSpriteNode()
    
    let playerCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    let endZoneCategory: UInt32 = 0x1 << 3
    
    override func didMove(to view: SKView) {
        self.view!.isMultipleTouchEnabled = true
        
        playerNode = childNode(withName: "player")
        playerNode?.zPosition = 2
        playerNode?.position = CGPoint(x: 120 + self.frame.size.width/18 - self.frame.size.width/2, y: 150 + self.frame.size.height/6 - self.frame.size.height/2 + playerNode!.frame.size.height/2)
        playerNode?.physicsBody = SKPhysicsBody(rectangleOf: playerNode!.frame.size)
        
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
            groundNode.position = CGPoint(x: 120 + self.frame.size.width/18 - self.frame.size.width/2 + CGFloat((i - 1) * 170), y: 150 + self.frame.size.height/6 - self.frame.size.height/2 + CGFloat((i - 1) * 170))
            groundNode.physicsBody = SKPhysicsBody(rectangleOf: groundNode.frame.size)
            groundNode.physicsBody?.isDynamic = false
            
            groundNode.physicsBody?.categoryBitMask = groundCategory
            groundNode.physicsBody?.contactTestBitMask = playerCategory
            groundNode.physicsBody?.collisionBitMask = playerCategory
            
            // Name for easier use (may need to change if you have multiple rows generated)
            groundNode.name = "ground"+String(i)
            // Add box to scene
            addChild(groundNode)
        }
        
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
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        pauseButtonNode?.zPosition = 2
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/25, y: self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/12)
        replayButtonNode?.zPosition = 2
        
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
//        for index in 1...3 {
//            cameraNode?.addChild(heartsArray[index])
//        }
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
                    print("press joystick")
                    joystickFree = false
                    let location = touch.location(in: joystick!)
                    joystickAction = joystickKnob.frame.contains(location)
                }
            }
            let location = touch.location(in: self)
            if !(joystick?.contains(location))! {
                print("touch")
//                playerStateMachine.enter(JumpingState.self)
                let textures = SKTexture(imageNamed: "jump")
                let action = {SKAction.animate(with: [textures], timePerFrame: 0.1)}()
                playerNode!.run(action)
                playerNode!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
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
                //                ]timer.invalidate()
                showAlertResume(withTitle: "Resume", message: "Do you want to resume now?")
            }
            if nodesArray.first?.name == "replayButton"{
                pause = true
                showAlertReplay(withTitle: "Replay", message: "Do you want to replay now?")
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
                print("move joystick!!!!!!!!!!!!!")
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
                print("Free joystick~~~~~~~~~~~~~")
            }
        }
    }
}


//Game Loop
extension AdventureScene3{
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
//        rewardIsNotTouched = true
        
        //camera
        cameraNode!.position.x = playerNode!.position.x - (120 + self.frame.size.width/18 - self.frame.size.width/2)
        cameraNode!.position.y = playerNode!.position.y - (150 + self.frame.size.height/6 - self.frame.size.height/2 + playerNode!.frame.size.height/2)
        joystick?.position.y = cameraNode!.position.y + self.frame.size.height/6 - self.frame.size.height/2
        joystick?.position.x = cameraNode!.position.x + (self.frame.size.width/10 - self.frame.size.width/2)
        backButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/25 - self.frame.size.width/2
        backButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25
        pauseButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/2 - self.frame.size.width/25
        pauseButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/25
        replayButtonNode?.position.x = cameraNode!.position.x + self.frame.size.width/2 - self.frame.size.width/25
        replayButtonNode?.position.y = cameraNode!.position.y + self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/12
        heartsArray[0].position.x = cameraNode!.position.x +  self.frame.size.width/18 - self.frame.size.width/2 + CGFloat(4-1) * heartsArray[0].size.width
        heartsArray[0].position.y = cameraNode!.position.y + self.frame.size.height/2 - heartsArray[0].frame.size.height/2 - self.frame.size.width/20
        heartsArray[1].position.x = cameraNode!.position.x +  self.frame.size.width/18 - self.frame.size.width/2 + CGFloat(4-2) * heartsArray[0].size.width
        heartsArray[1].position.y = cameraNode!.position.y + self.frame.size.height/2 - heartsArray[0].frame.size.height/2 - self.frame.size.width/20
        heartsArray[2].position.x = cameraNode!.position.x +  self.frame.size.width/18 - self.frame.size.width/2 + CGFloat(4-3) * heartsArray[0].size.width
        heartsArray[2].position.y = cameraNode!.position.y + self.frame.size.height/2 - heartsArray[0].frame.size.height/2 - self.frame.size.width/20

        guard let joystickKnob = joystickKnob else{ return }
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
        
        //background parallax
//        let parallax1 = SKAction.moveTo(x: (player!.position.x)/(-10), duration: 0.0)
//        mountains1?.run(parallax1)
//        mountains3?.run(parallax1)
//        let parallax2 = SKAction.moveTo(x: (player!.position.x)/(-20), duration: 0.0)
//        mountains2?.run(parallax2)
//        mountains4?.run(parallax2)
//        let parallax3 = SKAction.moveTo(x: (player!.position.x)/(-40), duration: 0.0)
//        mountains5?.run(parallax3)
//        let parallax4 = SKAction.moveTo(x: cameraNode!.position.x, duration: 0.0)
//        moon?.run(parallax4)
//        stars?.run(parallax4)
    }
}


//mark: collision
extension AdventureScene3{
    struct Collision {
        enum Masks: Int {
            case nothing, player, ground, endzone
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
            //            let die = SKAction.move(to: CGPoint(x: -300, y: -100), duration: 0.0)
            //            player?.run(die)
//            print("dead")
//            loseHeart()
//            isHit = true
//            playerStateMachine.enter(StunnedState.self)
        }
        
        if collision.matches(first: .player, second: .ground){
            playerStateMachine.enter(LandingState.self)
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
            
//            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {(timer) in
//                self.joystickFrozen = false
//            }
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
            
            let adventureScene3 = AdventureScene3(fileNamed: "AdventureScene3")
            adventureScene3?.scaleMode = .aspectFill
            self.view?.presentScene(adventureScene3!)
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}
