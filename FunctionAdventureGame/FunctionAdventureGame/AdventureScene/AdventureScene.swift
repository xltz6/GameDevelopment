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
    // Declare SKNode and SKLabel
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
    var congratulationNode: SKSpriteNode!
    var gotItButtonNode: SKNode?
//    var gameOverNode: SKSpriteNode!
//    var backToLevelButtonNode: SKNode?
//    var replayLevelButtonNode: SKNode?
    
    // shape to draw the right cornor rectangle
    // path and lineShape used to draw linear function in right corner rectangle
    // circleX and circleY record the current x, y value
    var path = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineShape = SKShapeNode()
    var circleX = SKShapeNode()
    var circleY = SKShapeNode()

    //time system
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
    var finishGame = false
    
    //Hearts
    var heartsArray: [SKSpriteNode]!
    
    
    //Sprite Engine
    var previousTimeInterval: TimeInterval = 0
    // player speed unit speed (controlled by joystick)
    let playerspeed = 1.4
    // randomly set water speed
    let waterspeed = (Double(arc4random_uniform(10)) + 5)
    
    
    //Physics Collision: used for later collision detect
    let flagCategory: UInt32 = 4
    let playerNboatCategory: UInt32 = 2
    let endZoneCategory1: UInt32 = 1

    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Mark: didMove function
    override func didMove(to view: SKView) {
        // initialize the game scene, similar to viewDidLoad
        
        // The contactDelegate property is called when two physics bodies come in contact with each other. set the contactDelegate property on the physicsWorld
        self.physicsWorld.contactDelegate = self
        
        //connect to the playerNboat node in .sks file, set its position and zposition
        playerNboat = childNode(withName: "playerNboat")
        playerNboat?.zPosition = 2
        playerNboat?.position = CGPoint(x: 80 - self.frame.size.width/2, y: 100 - self.frame.size.height/2)
        
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        joystick?.zPosition = 2
        joystick?.position = CGPoint(x: 180 - self.frame.size.width/2, y: 180 - self.frame.size.height/2)
        
        bgNode = self.childNode(withName: "backGround")
        bgNode?.zPosition = -1
        
        //set flag position randomly
        flagNode = self.childNode(withName: "flag")
        flagNode?.zPosition = 1
        let randomXPosition = CGFloat(arc4random_uniform(UInt32(70)))
        flagNode?.position = CGPoint(x: self.frame.size.width/2 - 80 - randomXPosition*4, y: self.frame.size.height/2 - self.frame.size.height/7)
        
        // woodNode is used to let player know the water speed, in order to help them to play the game
        woodNode = self.childNode(withName: "wood")
        woodNode!.position = CGPoint(x: -self.frame.size.width/2 + woodNode!.frame.size.width/2 + self.frame.size.width/20, y: 0)
        woodNode!.zPosition = 2
        
        // congratulationNode only shows when player successfully complete the challenge. Make it zposition -5 first and once player finishes the game, change zposition to 5 to show up on the top.
        congratulationNode = SKSpriteNode(imageNamed: "congratulationSign1")
        congratulationNode.position = CGPoint(x: 0, y: 0)
        congratulationNode.size = CGSize(width: self.frame.size.width/1.5, height: self.frame.size.height/1.5)
        congratulationNode.zPosition = -5
        self.addChild(congratulationNode)
        
        // click gotItButton to close the congratulation pop up window
        gotItButtonNode = self.childNode(withName: "gotItButton")
        gotItButtonNode!.setScale(2)
        gotItButtonNode!.position = CGPoint(x: 0, y: -congratulationNode!.frame.size.height/3)
        gotItButtonNode!.zPosition = -3
        
//        gameOverNode = SKSpriteNode(imageNamed: "gameOver")
//        gameOverNode.position = CGPoint(x: 0, y: 0)
//        gameOverNode.size = CGSize(width: self.frame.size.width/1.5, height: self.frame.size.height/1.5)
//        gameOverNode.zPosition = -5
//        self.addChild(gameOverNode)
//
//        backToLevelButtonNode = self.childNode(withName: "backToLevel")
//        backToLevelButtonNode!.setScale(2)
//        backToLevelButtonNode!.position = CGPoint(x: -gameOverNode!.frame.size.width/4, y: -gameOverNode!.frame.size.height/4)
//        backToLevelButtonNode!.zPosition = -3
//
//        replayLevelButtonNode = self.childNode(withName: "replayLevel")
//        replayLevelButtonNode!.setScale(2)
//        replayLevelButtonNode!.position = CGPoint(x: gameOverNode!.frame.size.width/4, y: -gameOverNode!.frame.size.height/4)
//        replayLevelButtonNode!.zPosition = -3
        
        
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
        tutorialLabelNode.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1)
        tutorialLabelNode.fontSize = 20
        tutorialLabelNode.text = "Your challenge is to go across the river and get the flag. Remember river has speed! \nUse the joystick to control player going up and down. Your trajectory should be a straight line! Failing to get to the correct destination will lose a heart."
        tutorialLabelNode.numberOfLines = 5
        tutorialLabelNode.preferredMaxLayoutWidth = self.frame.size.width/3
        tutorialLabelNode.zPosition = -6
        tutorialLabelNode.alpha = 0
        self.addChild(tutorialLabelNode)
        
        // alertNode is a pop up alert when player click backButton and replayButton.
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
        
        
        // endZoneNodeRight and endZoneNodeUp are build for detect collision. if player touches the right edge or upside of the screen, lose one heart
        endZoneNodeRight = self.childNode(withName: "endZone")
        endZoneNodeUp = self.childNode(withName: "ednZone2")
        endZoneNodeUp?.zPosition = 3
        
        //record time used for playing this level
        timeCounterLabel = self.childNode(withName: "timeCounter") as? SKLabelNode
        timeCounterLabel.zPosition = 2
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00:00"
        
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

        // start timer and begin the game(isPlaying = true)
        // updateTimer function:  count time
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        
        functionLabel.horizontalAlignmentMode = .center
        functionLabel.verticalAlignmentMode = .center
        functionLabel.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5 * 2)
        functionLabel.fontName = "Arial"
        functionLabel.fontColor = SKColor.black
        functionLabel.fontSize = 20
        functionLabel.text = "Linear Function"
        functionLabel.zPosition = 2
        self.addChild(functionLabel)
        
        // create right corner rectangle
        shape.path = UIBezierPath(rect: CGRect(x: -self.frame.size.width/6, y: -self.frame.size.height/6, width: self.frame.size.width/3, height: self.frame.size.height/3)).cgPath
        shape.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/6, y: -self.frame.size.height/2 + self.frame.size.height/5)
        shape.alpha = 0.5
        shape.zPosition = 2
        shape.strokeColor = UIColor.black
        shape.lineWidth = 2
        self.addChild(shape)
        
        // starting point for drawing the line
        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        self.addChild(lineShape)
        
        // draw x, y coordinate
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
        
        // draw current x, y position
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


//used for draw arrow for x, y coordinate
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
// touchesBegan: is the first contact between your finger(s) and the screen,
// touchesMoved: is when you swipe your finger on the screen
// touchesEnded: is the moment when you remove your finger from the screen
extension AdventureScene{
    //Detect screen touch: one or more new touches occurred in a view or window.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //multiple touches(for touch and move)
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
            // single touch for touchable buttons
            if nodesArray.first?.name == "okButton"{
                // if backOrReplay tag is "back", tells player clicks the back button
                if backOrReplay == "back"{
                    // after touching, resume the game, make alertNode disappear, go back to level scene
                    pause = false
                    alertNode.zPosition = -5
                    alertLabelNode.zPosition = -6
                    okButtonNode!.zPosition = -6
                    cancelButtonNode!.zPosition = -6
                    let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
                    gameLevelScene?.scaleMode = .aspectFill
                    self.view?.presentScene(gameLevelScene!)
                }
                // if backOrReplay tag is "replay", tells player clicks the replay button
                if backOrReplay == "replay"{
                    // after touching, resume the game, make alertNode disappear, restart this level game
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
                // click cancel, nothing happens, resume game
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
                // if player finishes the game, it is not allowed to pause the game. After pause the game, resume button shows and keeps flashing to tell player that you need to resume game first.
                if pause == false && finishGame == false{
                    pause = true
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
                if pause == true && finishGame == false{
                    pause = false
                    pauseButtonNode?.zPosition = 2
                    resumeButtonNode?.zPosition = -2
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
            //player could click questionButton to show instruction of playing game, and click again to make it disappeared
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
                // click gotItButton, the congratulationNode, gotItButtonNode, badges disappear. replayButton, backButton keep flashing to remind player to make decision
                congratulationNode!.zPosition = -3
                gotItButtonNode?.zPosition = -3
                (self.childNode(withName: "badge1") as! SKSpriteNode).removeFromParent()
                if self.timerCount <= 20{
                    (self.childNode(withName: "badge2") as! SKSpriteNode).removeFromParent()
                }
            }
            
//            if nodesArray.first?.name == "replayLevel"{
//                finishGame = false
//                let adventureScene = AdventureScene(fileNamed: "AdventureScene")
//                adventureScene?.scaleMode = .aspectFill
//                self.view?.presentScene(adventureScene!)
//            }
//
//            if nodesArray.first?.name == "backToLevel"{
//                let gameLevelScene = GameLevelScene(fileNamed: "GameLevelScene")
//                gameLevelScene?.scaleMode = .aspectFill
//                self.view?.presentScene(gameLevelScene!)
//            }
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
    // reset joystick knob to its initial point once player release the knob
    func resetKnobPosition(){
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    
    //add hearts
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
    
    //lose one heart when player fails
    func loseHeart(){
        // frozen the joystick for 3 sec and remove one heart from heartsArray
        joystickFrozen = true
        if self.heartsArray.count > 0{
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
        //every time lose heart, call invincible function to remove physic effect of playerNboat for 3 sec
        invincible()
    }
    
    func dying(){
//        game over when lose all three hearts
//        finishGame = true
//        gameOverNode?.zPosition = 3
//        backToLevelButtonNode?.zPosition = 4
//        replayLevelButtonNode?.zPosition = 4
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
        timerCount += 1
        // Calculate minutes
        let timeString = String(format: "%02d:%02d:%02d", timerCount/3600, (timerCount/60)%60, timerCount%60)
        timeCounterLabel.text = "Time: \(timeString)"
        
    }

    
    // update function : Tells your app to perform any app-specific logic to update your scene.
    override func update(_ currentTime: TimeInterval) {
        //the delta time is the time elapsed between two frame updates.
        //SpriteKit tries to run(update) the game at 60 frames per 1 second. So each frame is about 0.01667 seconds
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        // let the wood floats on the river to reflect the river speed
        if deltaTime < 0.1{
            let woodmovement = CGVector(dx: (CGFloat)(deltaTime * 8.0 * waterspeed), dy: 0)
            woodNode!.run(SKAction.move(by: woodmovement, duration: 0))
        }
        
        // stop timer if game is paused
        if pause == true || finishGame == true{
            timer.invalidate()
            isPlaying = false
        }
        
        // start timer when isPlaying is false
        if pause == false{
            if isPlaying == false{
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            isPlaying = true
        }
        
        guard let joystickKnob = joystickKnob else{ return}
        
        
        if joystickFrozen == false && pause == false && touchflag == false{
            // move playerNboat according to the joystickKnob's Yposition.
            // update function will update playerNboat's position with respect to the timeframe * waterspeed(x coordinate) and timeframe * joystickKnob(y coordinate)
            let yPosition = Double(joystickKnob.position.y)
            let displacement = CGVector(dx: (CGFloat)(deltaTime * 8.0 * waterspeed), dy: (CGFloat)(deltaTime * yPosition * playerspeed))
            let move = SKAction.move(by: displacement, duration: 0)
            playerNboat?.run(move)
            
            // draw linear function
            // addLine function: draw the line from the starting point to the current position
            path.addLine(to: CGPoint(x: currentLocation.x + displacement.dx/3, y: currentLocation.y + displacement.dy/3))
            // update the starting point: move the line starting point to current position
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
    //didBegin function: Called when two bodies first contact each other.
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
        //check the categoryBitMask, if playerNboat touches the river bank or the right side of the screen, lose heart
        if (firstBody.categoryBitMask & endZoneCategory1) != 0 && (secondBody.categoryBitMask & playerNboatCategory) != 0{
            playerTouchUp(playerNboatNode: firstBody.node!, endZoneNodeUp: secondBody.node!)
        }
        //check the categoryBitMask, if playerNboat touches the flag, success
        if (firstBody.categoryBitMask & playerNboatCategory) != 0 && (secondBody.categoryBitMask & flagCategory) != 0{
            playerTouchFlag(playerNboat: firstBody.node!, flagNode: secondBody.node!)
        }
    }
    
    func playerTouchUp(playerNboatNode: SKNode, endZoneNodeUp: SKNode) {
        //lose heart, reset game
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
        
        let loss = SKAction.move(to: CGPoint(x: 80 - self.frame.size.width/2, y: 100 - self.frame.size.height/2), duration: 0.0)
        playerNboat!.run(loss)
        path.move(to: CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2))
        currentLocation = CGPoint(x: self.frame.size.width/6 + 40, y: 20 + self.frame.size.height/30 - self.frame.size.height/2)
        woodNode!.position = CGPoint(x: -self.frame.size.width/2 + woodNode!.frame.size.width/2 + self.frame.size.width/20, y: 0)
        
        
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
        let data = applicationDelegate.levelRecordDictionary["level1"] as! NSDictionary
        var gameData = data as! Dictionary<String, Int>

        // update highest star for level 1
        if self.heartsArray.count > gameData["highestStar"]! {
            gameData["highestStar"] = self.heartsArray.count
        }
        // update time counter for level 1
        if self.timerCount < gameData["timeCount"]! {
            gameData["timeCount"] = self.timerCount
        }
        // update badge, set 1 for obtain the badge, and show badge on the congratulation pop up window
        if self.heartsArray.count == 1 {
            gameData["beginnerBadge"] = 1
            let beginnerBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "beginnerBadge"))
            beginnerBadgeNode.setScale(0.8)
            beginnerBadgeNode.position = CGPoint(x: -congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
            beginnerBadgeNode.name = "badge1"
            beginnerBadgeNode.zPosition = 4
            addChild(beginnerBadgeNode)
        }
        if self.heartsArray.count == 2 {
            gameData["competentBadge"] = 1
            let competentBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "competentBadge"))
            competentBadgeNode.setScale(0.8)
            competentBadgeNode.position = CGPoint(x: -congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
            competentBadgeNode.name = "badge1"
            competentBadgeNode.zPosition = 4
            addChild(competentBadgeNode)
        }
        if self.heartsArray.count == 3 {
            gameData["proficientBadge"] = 1
            let proficientBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "proficientBadge"))
            proficientBadgeNode.setScale(0.8)
            proficientBadgeNode.position = CGPoint(x: -congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
            proficientBadgeNode.name = "badge1"
            proficientBadgeNode.zPosition = 4
            addChild(proficientBadgeNode)
        }
        if self.timerCount <= 20 {
            gameData["expertBadge"] = 1
            let expertBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "expertBadge"))
            expertBadgeNode.setScale(0.8)
            expertBadgeNode.position = CGPoint(x: congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
            expertBadgeNode.name = "badge2"
            expertBadgeNode.zPosition = 4
            addChild(expertBadgeNode)
        }
        
        applicationDelegate.levelRecordDictionary.setValue(gameData, forKey: "level1")
        // show congratulation pop up window and the button
        finishGame = true
        congratulationNode.texture = SKTexture(imageNamed: "congratulationSign\(self.heartsArray.count)")
        congratulationNode?.zPosition = 3
        gotItButtonNode?.zPosition = 4
        
        // change gameSuccessScene from a game scene to a pop up window
//        delay(1.8){
//            let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
//            gameSuccessScene?.scaleMode = .aspectFill
//            gameSuccessScene!.performanceLevel = self.heartsArray.count
//            gameSuccessScene!.level = 0
//            self.view?.presentScene(gameSuccessScene!)
//        }
    }
    
    // delay function to execute after certain time
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

