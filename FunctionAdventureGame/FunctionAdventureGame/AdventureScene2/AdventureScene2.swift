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
    // declare SKNodes and SKLabel
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
    var functionLabel = SKLabelNode()
    var questionButtonNode: SKNode?
    var tutorialNode: SKNode?
    var tutorialTitleNode = SKLabelNode()
    var tutorialLabelNode = SKLabelNode()
    var resumeButtonNode: SKNode?
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    var congratulationNode: SKSpriteNode!
    var gotItButtonNode: SKNode?
    
    // time counter variables
    var timeCounterLabel: SKLabelNode!
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    
    // force flag is to give character a force according to the direction and the speed player chooses
    var force = false
    var pause = false
    var isPlaying = false
    var isDrawing = true
    // flag to check if user selects the direction and the speed
    var directionChosen = false
    var speedChosen = false
    var tutorialShow = false
    var finishGame = false
    var backOrReplay = "back"
    var previousTimeInterval: TimeInterval = 0
    var previousCharacterNodeX: CGFloat = 0
    var previousCharacterNodeY: CGFloat = 0
    
    var angle: CGFloat = 0
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    
    // line shape for drawing quadratic function
    var path = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineShape = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    var circleX = SKShapeNode()
    var circleY = SKShapeNode()
    //draw success landing area
    var path1 = CGMutablePath()
    let lineshape1 = SKShapeNode()
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let characterCategory: UInt32 = 0x1 << 2
    let mountainCategory: UInt32 = 0x1 << 4
    let endZoneCategory: UInt32 = 0x1 << 8
    
    override func didMove(to view: SKView) {
        //ground background
        backgroundAdventure2 = childNode(withName: "bgadventure2")
        backgroundAdventure2?.zPosition = 1
        //sky background
        backgroundAdventure2Node = childNode(withName: "bgAd2")
        backgroundAdventure2Node?.zPosition = -2
        
        characterNode = childNode(withName: "character")
        characterNode?.setScale(0.2)
        characterNode?.zPosition = 0
        characterNode?.position = CGPoint(x: 120 + characterNode!.frame.size.width/2 - self.frame.size.width/2, y: 100)
        
        //set physic body of player (categoryBitMask 2)
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
        mountainLeftNode?.zPosition = 0
        mountainRightNode = childNode(withName: "mountainRight")
        mountainRightNode?.setScale(0.6)
        mountainRightNode?.zPosition = 0
        
        //set physics body of ground background (categoryBitMask 4)
        backgroundAdventure2?.physicsBody = SKPhysicsBody(rectangleOf: backgroundAdventure2!.frame.size)
        backgroundAdventure2?.physicsBody?.categoryBitMask = mountainCategory
        backgroundAdventure2?.physicsBody?.contactTestBitMask = characterCategory
        backgroundAdventure2?.physicsBody?.collisionBitMask = characterCategory
        backgroundAdventure2?.physicsBody?.isDynamic = false
        
        //set physics body of left and right mountain (categoryBitMask 4)
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

        //randomly initialize mountain slope angle
        angle = CGFloat(Double.random(in: 3.14/18..<3.14/5))
        mountainLeftNode?.zRotation = angle
        mountainRightNode?.zRotation = -angle

        //set right side edge of the screen as end zone and create physics body with categoryBitMask 8
        endZoneNode = self.childNode(withName: "endzone")
        endZoneNode?.physicsBody = SKPhysicsBody(rectangleOf: endZoneNode!.frame.size)
        endZoneNode?.physicsBody?.categoryBitMask = endZoneCategory
        endZoneNode?.physicsBody?.contactTestBitMask = characterCategory
        endZoneNode?.physicsBody?.collisionBitMask = characterCategory
        endZoneNode?.physicsBody?.isDynamic = false
        
        congratulationNode = SKSpriteNode(imageNamed: "congratulationSign3")
        congratulationNode.position = CGPoint(x: 0, y: 0)
        congratulationNode.size = CGSize(width: self.frame.size.width/1.5, height: self.frame.size.height/1.5)
        congratulationNode.zPosition = -5
        self.addChild(congratulationNode)
        
        gotItButtonNode = self.childNode(withName: "gotItButton")
        gotItButtonNode!.position = CGPoint(x: 0, y: -congratulationNode!.frame.size.height/3)
        gotItButtonNode!.setScale(2)
        gotItButtonNode!.zPosition = -3
        
        
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
        
        // when player clicks the question node, an popup window comes out. Some instructions will list on there
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
        tutorialLabelNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.6)
        tutorialLabelNode.fontSize = 20
        tutorialLabelNode.text = "Your challenge is to control the player to jump across the river and land within the safe area in red line. \nChoose the moving direction and speed by clicking two buttons. Drop into water and jump too far away will lose a heart."
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
        // alertNode pop up window has two buttons, ok button and cancel buttton
        okButtonNode = self.childNode(withName: "okButton")
        okButtonNode!.position = CGPoint(x: self.frame.size.width/16, y: self.frame.size.height/25 - okButtonNode!.frame.size.height*3/4)
        okButtonNode?.zPosition = -6
        
        cancelButtonNode = self.childNode(withName: "cancelButton")
        cancelButtonNode!.position = CGPoint(x: -self.frame.size.width/16, y: self.frame.size.height/25 - cancelButtonNode!.frame.size.height*3/4)
        cancelButtonNode?.zPosition = -6
        
        directionNode = self.childNode(withName: "direction")
        directionNode?.zPosition = 2
        directionButtonNode = self.childNode(withName: "directionButtonAd2")
        directionButtonNode?.zPosition = 2
        
        speedNode = self.childNode(withName: "speed")
        speedNode?.zPosition = 3
        speedBarNode = self.childNode(withName: "speedBar")
        speedBarNode?.zPosition = 2
        speedButtonNode = self.childNode(withName: "speedButton")
        speedButtonNode?.zPosition = 2
        
        timeCounterLabel = self.childNode(withName: "timeCounter") as? SKLabelNode
        timeCounterLabel.zPosition = 2
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00.00"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // create lives
        fillHearts(count: 3)
        
        // add action for direction node
        let action1 = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration:1.5)
        let action2 = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:1.5)
        let sequence1 = SKAction.sequence([.wait(forDuration: 0.1), action1, action2])
        let repeatAction1 = SKAction.repeatForever(sequence1)
        directionNode!.run(repeatAction1)
        
        // add action for speed node
        let action3 = SKAction.scaleX(to: speedNode!.xScale * 5.6, duration: 1.5)
        let action4 = SKAction.scaleX(to: speedNode!.xScale, duration: 1.5)
        let sequence2 = SKAction.sequence([.wait(forDuration: 0.1), action3, action4])
        let repeatAction2 = SKAction.repeatForever(sequence2)
        speedNode!.run(repeatAction2)
        
        
        functionLabel.horizontalAlignmentMode = .center
        functionLabel.verticalAlignmentMode = .center
        functionLabel.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5 * 2)
        functionLabel.fontName = "AvenirNext"
        functionLabel.fontColor = SKColor.black
        functionLabel.fontSize = 20
        functionLabel.text = "Quadratic Function"
        functionLabel.zPosition = 2
        self.addChild(functionLabel)
        
        shape.path = UIBezierPath(rect: CGRect(x: -self.frame.size.width/6, y: -self.frame.size.height/6, width: self.frame.size.width/3, height: self.frame.size.height/3)).cgPath
        shape.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5)
        shape.alpha = 0.5
        shape.strokeColor = UIColor.black
        shape.lineWidth = 2
        shape.zPosition = 2
        self.addChild(shape)
        
        // initial position of the function graph [0,0]
        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        lineShape.zPosition = 2
        self.addChild(lineShape)
        
        let arrowX = UIBezierPath()
        arrowX.addArrow2(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/6 + 40, y: -self.frame.size.height/6 + self.frame.size.height/30 - 20), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor.black
        xCoordinate.lineWidth = 2
        xCoordinate.zPosition = 2
        self.addChild(xCoordinate)
        
        let arrowY = UIBezierPath()
        arrowY.addArrow2(start: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), end: CGPoint(x: self.frame.size.width/2 - 20, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor.black
        yCoordinate.lineWidth = 2
        yCoordinate.zPosition = 2
        self.addChild(yCoordinate)

        circleX = SKShapeNode(circleOfRadius: 2) // Size of Circle
        circleX.position = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        circleX.strokeColor = UIColor.red
        circleX.fillColor = UIColor.red
        circleX.glowWidth = 1.0
        circleX.zPosition = 2
        self.addChild(circleX)
        
        circleY = SKShapeNode(circleOfRadius: 2) // Size of Circle
        circleY.position = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        circleY.strokeColor = UIColor.red
        circleY.fillColor = UIColor.red
        circleY.glowWidth = 1.0
        circleY.zPosition = 2
        self.addChild(circleY)
        
        // using lineshape1 to represent safe area
        let checkpoint = mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2 * sin(angle) - mountainRightNode!.frame.size.width/2 * cos(angle)
        path1.move(to: CGPoint(x: checkpoint, y: 0))
        self.addChild(lineshape1)
        
        path1.addLine(to: CGPoint(x: mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2/sin(90-angle) + self.frame.size.width/8, y: 0))
        lineshape1.path = path1
        lineshape1.strokeColor = UIColor.red
        lineshape1.lineWidth = 5
        lineshape1.zPosition = 2
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
        //every time lose heart, call invincible function to remove physic effect of character for 1 sec
        invincible()
    }

    func dying(){
        //        go to gameoverscene
        //        print("go to gameoverScene")
        let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
        gameOverScene?.scaleMode = .aspectFill
        gameOverScene!.level = 2
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
        if pause == false && finishGame == false{
            timerCount += 1
            // Calculate minutes
            let timeString = String(format: "%02d:%02d:%02d", timerCount/3600, (timerCount/60)%60, timerCount%60)
            timeCounterLabel.text = "Time: \(timeString)"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // if player has chosen direction and speed, add gravity to character
        if directionChosen == true && speedChosen == true {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            isPlaying = true
            isDrawing = true
        }
        
        if pause == false && force == false && isPlaying == true {
            // give character an impulse according to the chosen direction and speed
            // once adding this impulse, set force to true, avoid to add impulse twice
            let scale = speedNode!.xScale
            print(scale)
            let direction = directionNode!.zRotation
            let x = scale * 300 * cos(direction)
            let y = scale * 300 * sin(direction)
            characterNode?.physicsBody?.applyImpulse(CGVector(dx: x, dy: y))
            force = true
        }
        // draw quadratic function
        if isPlaying == true && isDrawing == true{
            path.addLine(to: CGPoint(x: currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3))
            path.move(to: CGPoint(x: currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3))
            
            circleX.run(SKAction.move(to: CGPoint(x: currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: 20 + self.frame.size.height/30 - self.frame.size.height/2), duration: 0))
            circleY.run(SKAction.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3), duration: 0))
            
            currentLocation = CGPoint(x:currentLocation.x + (characterNode!.position.x - previousCharacterNodeX)/3, y: currentLocation.y + (characterNode!.position.y - previousCharacterNodeY)/3)
            
            lineShape.path = path
            lineShape.strokeColor = UIColor.black
            lineShape.lineWidth = 2
            
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
        // collision detection for player touches the mountain
        if (firstBody.categoryBitMask & characterCategory) != 0 && (secondBody.categoryBitMask & mountainCategory) != 0{
            if isDrawing == true{
                playerTouchMountain(characterNode: firstBody.node!, backgroundAdventure2: secondBody.node!)
            }
            
        }
        // collision detection for player touches the right edge of the screen
        if (firstBody.categoryBitMask & characterCategory) != 0 && (secondBody.categoryBitMask & endZoneCategory) != 0{
            if isDrawing == true{
                playerTouchEndZone(characterNode: firstBody.node!, endZoneNode: secondBody.node!)
            }
        }
    }
    
    func playerTouchMountain(characterNode: SKNode, backgroundAdventure2: SKNode) {
        if isPlaying == true && isDrawing == true{
            // character lands within the safe area, success
            if characterNode.position.x > mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2 * sin(angle) - mountainRightNode!.frame.size.width/2 * cos(angle) && characterNode.position.x <= mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2/sin(90-angle) + self.frame.size.width/8 {
                //reset direction, speed, isDrawing flag
                directionChosen = false
                speedChosen = false
                finishGame = true
                isDrawing = false
                print("success")
                // play applaud sound
                run(Sound.applaud.action)
                // the graph of quadratic functions flashes
                lineShape.run(SKAction.repeat(.sequence([
                    .fadeAlpha(to: 0.2, duration: 0.05),
                    .wait(forDuration: 0.1),
                    .fadeAlpha(to: 1.0, duration: 0.05),
                    .wait(forDuration: 0.1),
                    ]), count: 6))
                
                let data = applicationDelegate.levelRecordDictionary["level2"] as! NSDictionary
                var gameData = data as! Dictionary<String, Int>
                
                // update highest star for level 2
                if self.heartsArray.count > gameData["highestStar"]! {
                    gameData["highestStar"] = self.heartsArray.count
                }
                // update time counter for level 2
                if self.timerCount < gameData["timeCount"]! {
                    gameData["timeCount"] = self.timerCount
                }
                // update badge, set 1 for obtain the badge
                // show the badge on congratulation pop up window if acchieves
                if self.heartsArray.count == 1 {
                    gameData["beginnerBadge"] = 1
                    let beginnerBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "beginnerBadge"))
                    beginnerBadgeNode.setScale(0.8)
                    beginnerBadgeNode.position = CGPoint(x: -congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
                    beginnerBadgeNode.name = "badge1"
                    beginnerBadgeNode.zPosition = 5
                    addChild(beginnerBadgeNode)
                }
                if self.heartsArray.count == 2 {
                    gameData["competentBadge"] = 1
                    let competentBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "competentBadge"))
                    competentBadgeNode.setScale(0.8)
                    competentBadgeNode.position = CGPoint(x: -congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
                    competentBadgeNode.name = "badge1"
                    competentBadgeNode.zPosition = 5
                    addChild(competentBadgeNode)
                }
                if self.heartsArray.count == 3 {
                    gameData["proficientBadge"] = 1
                    let proficientBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "proficientBadge"))
                    proficientBadgeNode.setScale(0.8)
                    proficientBadgeNode.position = CGPoint(x: -congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
                    proficientBadgeNode.name = "badge1"
                    proficientBadgeNode.zPosition = 5
                    addChild(proficientBadgeNode)
                }
                if self.timerCount <= 5 {
                    gameData["expertBadge"] = 1
                    let expertBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "expertBadge"))
                    expertBadgeNode.setScale(0.8)
                    expertBadgeNode.position = CGPoint(x: congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
                    expertBadgeNode.name = "badge2"
                    expertBadgeNode.zPosition = 5
                    addChild(expertBadgeNode)
                }
                
                applicationDelegate.levelRecordDictionary.setValue(gameData, forKey: "level2")
                // show congratulation node and got it button
                congratulationNode.texture = SKTexture(imageNamed: "congratulationSign\(self.heartsArray.count)")
                congratulationNode?.zPosition = 4
                gotItButtonNode?.zPosition = 5
            }
            
            //when player lands out of the safe area, lose heart
            if characterNode.position.x < mountainRightNode!.position.x - mountainRightNode!.frame.size.height/2 || characterNode.position.x > mountainRightNode!.position.x + mountainRightNode!.frame.size.height/2/sin(90-angle) + self.frame.size.width/8 {
                
                //reset direction, speed, isDrawing flag
                directionChosen = false
                speedChosen = false
                isDrawing = false
                
                //lose heart and add flashing effect to remind player
                loseHeart()
                for i in 0 ..< heartsArray.count{
                    let heartNode = self.heartsArray[i]
                    heartNode.run(SKAction.repeat(.sequence([
                        .fadeAlpha(to: 0.2, duration: 0.05),
                        .wait(forDuration: 0.1),
                        .fadeAlpha(to: 1.0, duration: 0.05),
                        .wait(forDuration: 0.1),
                        ]), count: 3))
                }
                // delay 1.5 sec to reset all variables to initial value
                delay(1.5){
                    self.force = false
                    self.isPlaying = false

                    let loss = SKAction.move(to: CGPoint(x: 100 + characterNode.frame.size.width/2 - self.frame.size.width/2, y: 100), duration: 0.0)
                    let rotation = SKAction.rotate(toAngle: self.angle, duration: 0.0)
                    self.characterNode!.run(SKAction.sequence([loss, rotation]))

                    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                    self.characterNode!.physicsBody?.velocity =  CGVector()
                    self.characterNode!.physicsBody?.angularVelocity = 0
                    self.characterNode!.zRotation = self.angle

                    self.previousCharacterNodeX = 100 + characterNode.frame.size.width/2 - self.frame.size.width/2
                    self.previousCharacterNodeY = 100
                    self.path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
                    self.currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)

                    self.directionNode?.zRotation = 0
                    self.speedNode?.xScale = 0.323

                    let action1 = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration:1.5)
                    let action2 = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:1.5)
                    let sequence1 = SKAction.sequence([.wait(forDuration: 0.1), action1, action2])
                    let repeatAction1 = SKAction.repeatForever(sequence1)
                    self.directionNode!.run(repeatAction1)

                    let action3 = SKAction.scaleX(to: self.speedNode!.xScale * 5.6, duration: 1.5)
                    let action4 = SKAction.scaleX(to: self.speedNode!.xScale, duration: 1.5)
                    let sequence2 = SKAction.sequence([.wait(forDuration: 0.1), action3, action4])
                    let repeatAction2 = SKAction.repeatForever(sequence2)
                    self.speedNode!.run(repeatAction2)
                }
            }
        }
    }

    // when player touches the right side of the screen, lose heart
    func playerTouchEndZone(characterNode: SKNode, endZoneNode: SKNode){
        if isDrawing == true{
            if characterNode.position.y > characterNode.frame.size.height/2{
                
                directionChosen = false
                speedChosen = false
                isDrawing = false
                
                loseHeart()
                for i in 0 ..< heartsArray.count{
                    let heartNode = self.heartsArray[i]
                    heartNode.run(SKAction.repeat(.sequence([
                        .fadeAlpha(to: 0.2, duration: 0.05),
                        .wait(forDuration: 0.1),
                        .fadeAlpha(to: 1.0, duration: 0.05),
                        .wait(forDuration: 0.1),
                        ]), count: 3))
                }

                delay(1.5){
                    self.force = false
                    self.isPlaying = false

                    let loss = SKAction.move(to: CGPoint(x: 100 + characterNode.frame.size.width/2 - self.frame.size.width/2, y: 100), duration: 0.0)
                    let rotation = SKAction.rotate(toAngle: self.angle, duration: 0.0)
                    self.characterNode!.run(SKAction.sequence([loss, rotation]))

                    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                    self.characterNode!.physicsBody?.velocity =  CGVector()
                    self.characterNode!.physicsBody?.angularVelocity = 0
                    self.characterNode!.zRotation = self.angle

                    self.previousCharacterNodeX = 100 + characterNode.frame.size.width/2 - self.frame.size.width/2
                    self.previousCharacterNodeY = 100
                    self.path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
                    self.currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)

                    self.directionNode?.zRotation = 0
                    self.speedNode?.xScale = 0.323

                    let action1 = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration:1.5)
                    let action2 = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:1.5)
                    let sequence1 = SKAction.sequence([.wait(forDuration: 0.1), action1, action2])
                    let repeatAction1 = SKAction.repeatForever(sequence1)
                    self.directionNode!.run(repeatAction1)

                    let action3 = SKAction.scaleX(to: self.speedNode!.xScale * 5.6, duration: 1.5)
                    let action4 = SKAction.scaleX(to: self.speedNode!.xScale, duration: 1.5)
                    let sequence2 = SKAction.sequence([.wait(forDuration: 0.1), action3, action4])
                    let repeatAction2 = SKAction.repeatForever(sequence2)
                    self.speedNode!.run(repeatAction2)
                }
            }
        }
    }
    
    // delay function to execute after certain time
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

// Mark: touch functions
extension AdventureScene2{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "directionButtonAd2"{
                // every time player choose the direction, stop the action on direction node and set direction flag to ture
                directionNode!.removeAllActions()
                directionChosen = true
            }
            
            if nodesArray.first?.name == "speedButton"{
                // every time player choose the speed, stop the action on speed node and set speed flag to ture
                speedNode!.removeAllActions()
                speedChosen = true
            }
            
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
                    let adventureScene2 = AdventureScene2(fileNamed: "AdventureScene2")
                    adventureScene2?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene2!)
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
                if pause == false && finishGame == false{
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
                if pause == true && finishGame == false{
                    pause = false
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
                    alertNode.zPosition = 5
                    alertLabelNode.text = "Do you want to replay this game?"
                    alertLabelNode.zPosition = 6
                    okButtonNode!.zPosition = 6
                    cancelButtonNode!.zPosition = 6
                }
            }
            if nodesArray.first?.name == "questionButton"{
                if finishGame == true {return}
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
            
            if nodesArray.first?.name == "gotItButton"{
                congratulationNode!.zPosition = -3
                gotItButtonNode?.zPosition = -3
                (self.childNode(withName: "badge1") as! SKSpriteNode).removeFromParent()
                if self.timerCount <= 5{
                    (self.childNode(withName: "badge2") as! SKSpriteNode).removeFromParent()
                }
            }
        }
    }
}


// functions for drawing the arrow
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
