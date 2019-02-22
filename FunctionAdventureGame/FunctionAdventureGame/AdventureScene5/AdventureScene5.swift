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
    //declare all the SKNodes and SKlabels
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    var waterbg5Node: SKNode?
    var ferrisWheelNode: SKNode?
    var playerNodeAd6: SKNode?
    var slideButtonNode: SKNode?
    var slideBarNode: SKNode?
    var speedSlideButtonNode: SKNode?
    var speedSlideBarNode: SKNode?
    var arrowDirectionNode: SKNode?
    var goButtonNode: SKNode?
    var questionButtonNode: SKNode?
    var tutorialNode: SKNode?
    var tutorialTitleNode = SKLabelNode()
    var tutorialLabelNode = SKLabelNode()
    var periodScaleLabel1 = SKLabelNode()
    var periodScaleLabel2 = SKLabelNode()
    var resumeButtonNode: SKNode?
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    var congratulationNode: SKSpriteNode!
    var gotItButtonNode: SKNode?
    
    //declare some flag variable
    var pause = false
    var sizeChosen = false
    var speedChosen = false
    var positionChosen = false
    var sizeSlideAction = false
    var speedSlideAction = false
    var moveAction = false
    var directionAction = false
    var gameSuccess = true
    var goPressed = false
    var tutorialShow = false
    var finishGame = false
    var backOrReplay = "back"
    var rotationSpeed: Double = Double(Double.pi/2)
    var moveSpeed = CGFloat(20)
    var radius: Double = 0
    var rotationAngle: Double = 0
    var previousTimeInterval: TimeInterval = 0
    var tickCount = 0
    var nodeNumber = 0
    var initialAngle = Double.pi
    var tempAngle = Double(0)
    var timeToRemain = 0
    
    // lineshape for player draw
    var path = CGMutablePath()
    var lineshape = SKShapeNode()
    // lineshape1 for connection between wheel and trigonometric graph
    var path1 = CGMutablePath()
    var lineshape1 = SKShapeNode()
    // lineshape2 for original graph
    var path2 = CGMutablePath()
    var lineshape2 = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    var currentLocation1 = CGPoint(x:0,y:0)
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    // lineshape for scale
    var path3 = CGMutablePath()
    var lineshape3 = SKShapeNode()
    
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
    let directionLabel = SKLabelNode()
    let formulaLabel = SKLabelNode()
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
        // add background and water wheel to the scene
        waterbg5Node = self.childNode(withName: "waterbg5")
        waterbg5Node?.zPosition = -1
        ferrisWheelNode = self.childNode(withName: "waterWheel")
        ferrisWheelNode!.position = CGPoint(x: -self.frame.size.width/4, y: 0)
        ferrisWheelNode?.zPosition = 1
        radius = Double(ferrisWheelNode!.frame.size.width*10/24)
        
        // congratulationNode only shows when player successfully complete the challenge. Make it zposition -2 first and once player finishes the game, change zposition to 3 to show up on the top.
        congratulationNode = SKSpriteNode(imageNamed: "congratulationSign3")
        congratulationNode.position = CGPoint(x: 0, y: 0)
        congratulationNode.size = CGSize(width: self.frame.size.width/1.5, height: self.frame.size.height/1.5)
        congratulationNode.zPosition = -2
        congratulationNode.alpha = 0
        self.addChild(congratulationNode)
        
        gotItButtonNode = self.childNode(withName: "gotItButton")
        gotItButtonNode!.position = CGPoint(x: 0, y: -congratulationNode!.frame.size.height/3)
        gotItButtonNode!.setScale(2)
        gotItButtonNode!.zPosition = -3
        gotItButtonNode?.alpha = 0
        
        
        playerNodeAd6 = self.childNode(withName: "playerNode")
        playerNodeAd6!.position = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius), y: 0)
        playerNodeAd6?.zPosition = 2
        playerNodeAd6?.setScale(0.2)
        
        // this slider is to control the size of the water wheel
        slideButtonNode = self.childNode(withName: "sliderButton")
        slideButtonNode!.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
        slideButtonNode?.zPosition = 2
        slideBarNode = self.childNode(withName: "slideBar") 
        slideBarNode!.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
        slideBarNode?.zPosition = 1
        
        // this slider is to control the period of the trigonometric function graph
        speedSlideButtonNode = self.childNode(withName: "speedSliderButton")
        speedSlideButtonNode!.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height * 3 / 8)
        speedSlideButtonNode?.zPosition = 2
        speedSlideBarNode = self.childNode(withName: "speedSlideBar")
        speedSlideBarNode!.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height * 3 / 8)
        speedSlideBarNode?.zPosition = 1
        
        // the min period label and the max period label
        periodScaleLabel1.horizontalAlignmentMode = .center
        periodScaleLabel1.verticalAlignmentMode = .center
        periodScaleLabel1.position = CGPoint(x: self.frame.size.width/7 - speedSlideBarNode!.frame.size.width/2, y: -self.frame.size.height/3 - 5)
        periodScaleLabel1.fontName = "Arial"
        periodScaleLabel1.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        periodScaleLabel1.fontSize = 20
        periodScaleLabel1.text = "1π"
        periodScaleLabel1.zPosition = 3
        self.addChild(periodScaleLabel1)
        
        periodScaleLabel2.horizontalAlignmentMode = .center
        periodScaleLabel2.verticalAlignmentMode = .center
        periodScaleLabel2.position = CGPoint(x: self.frame.size.width/7 + speedSlideBarNode!.frame.size.width/2, y: -self.frame.size.height/3 - 5)
        periodScaleLabel2.fontName = "Arial"
        periodScaleLabel2.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        periodScaleLabel2.fontSize = 20
        periodScaleLabel2.text = "2π"
        periodScaleLabel2.zPosition = 3
        self.addChild(periodScaleLabel2)
        
        // this node is the starting position of the function graph (only 4 choices)
        arrowDirectionNode = self.childNode(withName: "arrowDirection")
        arrowDirectionNode!.position = CGPoint(x: -self.frame.size.width/11, y: -self.frame.size.height * 3 / 8)
        arrowDirectionNode?.zPosition = 2
        
        // after choosing the 3 condition, go button is to check the answer
        goButtonNode = self.childNode(withName: "goButton")
        goButtonNode?.setScale(0.8)
        goButtonNode!.position = CGPoint(x: self.frame.size.width/2.7, y: -self.frame.size.height * 3 / 8)
        goButtonNode!.zPosition = 2
        
        // add back, replay, pause/resume question button
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
        
        // add line shapes to the scene and set its starting position
        currentLocation = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius),y:0)
        path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
        lineshape.zPosition = 3
        lineshape.strokeColor = UIColor.black
        self.addChild(lineshape)
        
        lineshape1.zPosition = 1
        lineshape1.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        self.addChild(lineshape1)
        
        path2.move(to: CGPoint(x: 0, y: 0))
        lineshape2.zPosition = 2
        lineshape2.strokeColor = UIColor.white
        self.addChild(lineshape2)
        
        // y = A sin(𝑤x + 𝝋) randomly create the function parameter A (size of the water wheel), parameter 𝑤(period) and parameter 𝝋 (the starting position)
        let radiusR = Double.random(in: radius * 0.4 ... radius * 1.2)
        let tempX = Int.random(in: 10 ... 20)
        let sinFunction = Int.random(in: 1 ... 4)
        initialAngle = Double(sinFunction) * Double.pi/2
        let A = String(format: "%.2f", radiusR/Double(self.frame.size.width) * 5 * Double.pi)
        let w = Double(tempX)/10
        let fi = initialAngle/Double.pi
        
        currentLocation1 = CGPoint(x:0,y: radiusR * sin(initialAngle))
        path2.move(to: CGPoint(x: 0, y: radiusR * sin(initialAngle)))
        for i in 1 ... 5{
            // drawing the 5 dots
            let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
            circle.position = CGPoint(x: 0 + CGFloat(i-1) * self.frame.size.width/CGFloat(tempX), y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + initialAngle))) //Middle of Screen
            circle.strokeColor = UIColor.black
            circle.fillColor = UIColor.black
            circle.glowWidth = 1.0
            circle.name = "circle\(i)"
            circle.zPosition = 1
            self.addChild(circle)
            currentLocation1 = CGPoint(x:0 + CGFloat(i-1) * self.frame.size.width/CGFloat(tempX),y: 0)
            // drawing the trigonometric graph
            if i != 5 {
                for j in 1 ... 20{
                    path2.addLine(to: CGPoint(x: currentLocation1.x + CGFloat(j-1) * self.frame.size.width/CGFloat(tempX)/20, y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + initialAngle + (Double)(j-1) * Double.pi/2/20))))
                    path2.move(to: CGPoint(x: currentLocation1.x + CGFloat(j-1) * self.frame.size.width/CGFloat(tempX)/20, y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + initialAngle + (Double)(j-1) * Double.pi/2/20))))
                    lineshape2.path = path2
                    lineshape2.zPosition = 2
                    lineshape2.strokeColor = UIColor.white
                    lineshape2.lineWidth = 3
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
        timeCounterLabel.text = "Time: 00:00:00"
        self.addChild(timeCounterLabel)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        titleLabel.zPosition = 2
        titleLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        titleLabel.fontSize = 26
        titleLabel.fontName = "Arial"
        titleLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/8)
        titleLabel.text = "Try to make the trigonometric graph as below"
        self.addChild(titleLabel)
        
        // set labels for explanation for slider nodes and arrow node
        sizeLabel.zPosition = 2
        sizeLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        sizeLabel.fontSize = 20
        sizeLabel.numberOfLines = 3
        sizeLabel.preferredMaxLayoutWidth = self.frame.size.width/5
        sizeLabel.fontName = "Arial"
        sizeLabel.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height/3)
        sizeLabel.text = "Set water wheel size"
        self.addChild(sizeLabel)
        
        speedLabel.zPosition = 2
        speedLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        speedLabel.fontSize = 20
        speedLabel.numberOfLines = 3
        speedLabel.preferredMaxLayoutWidth = self.frame.size.width/5
        speedLabel.fontName = "Arial"
        speedLabel.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height/3)
        speedLabel.text = "set period"
        self.addChild(speedLabel)
        
        moveSpeed = 1/1200 * self.frame.size.width + 0.5 * 1/1200 * self.frame.size.width
        
        directionLabel.zPosition = 2
        directionLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        directionLabel.fontSize = 20
        directionLabel.numberOfLines = 3
        directionLabel.preferredMaxLayoutWidth = self.frame.size.width/5
        directionLabel.fontName = "Arial"
        directionLabel.position = CGPoint(x: -self.frame.size.width/11, y: -self.frame.size.height/3)
        directionLabel.text = "Set starting position"
        self.addChild(directionLabel)
        
        formulaLabel.zPosition = 2
        formulaLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        formulaLabel.fontSize = 30
        formulaLabel.fontName = "Arial"
        formulaLabel.position = CGPoint(x: self.frame.size.width/5, y: self.frame.size.height/2 - self.frame.size.width/6)
        formulaLabel.text = "y = A sin(𝑤x + 𝝋) = \(A) sin(\(w)x + \(fi)π)"
        self.addChild(formulaLabel)
        
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
        tutorialTitleNode.position = CGPoint(x: 0, y: self.frame.size.height/6+4)
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
        tutorialLabelNode.text = "Your challenge is to reproduce the graph showing on the right screen. \nRed button controls the Amplitude of the graph, arrow button decides where the graph begins (phase shift), and the green button change the period of the graph. After changing the size of the water wheel, the start position and the periodic time of the graph, click go button to make the trigonometric graph."
        tutorialLabelNode.numberOfLines = 5
        tutorialLabelNode.preferredMaxLayoutWidth = self.frame.size.width/3
        tutorialLabelNode.zPosition = -6
        tutorialLabelNode.alpha = 0
        self.addChild(tutorialLabelNode)
        
        alertNode = SKShapeNode(rectOf: CGSize(width: self.frame.size.width/4, height: self.frame.size.height/6), cornerRadius: 20)
        alertNode.zPosition = -6
        alertNode.position = CGPoint(x: 0, y: self.frame.size.height/25)
        alertNode.fillColor = UIColor(red:0.60, green:0.78, blue:0.20, alpha:1.0)
        alertNode.alpha = 0
        self.addChild(alertNode)
        
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
        self.addChild(alertLabelNode)
        // alertNode pop up window has two buttons, ok button and cancel buttton
        okButtonNode = self.childNode(withName: "okButton")
        okButtonNode!.position = CGPoint(x: self.frame.size.width/16, y: self.frame.size.height/25 - okButtonNode!.frame.size.height*3/4)
        okButtonNode?.zPosition = -6
        okButtonNode?.alpha = 0
        
        cancelButtonNode = self.childNode(withName: "cancelButton")
        cancelButtonNode!.position = CGPoint(x: -self.frame.size.width/16, y: self.frame.size.height/25 - cancelButtonNode!.frame.size.height*3/4)
        cancelButtonNode?.zPosition = -6
        cancelButtonNode?.alpha = 0
        
        
        //Y axis
        let arrowY = UIBezierPath()
        arrowY.addArrow5(start: CGPoint(x: 0, y: -self.frame.size.height/4), end: CGPoint(x: 0, y: self.frame.size.height/4), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        yCoordinate.lineWidth = 3
        yCoordinate.zPosition = 1
        self.addChild(yCoordinate)
        //X axis
        let arrowX = UIBezierPath()
        arrowX.addArrow5(start: CGPoint(x: 0, y: 0), end: CGPoint(x: self.frame.size.width*7/16, y: 0), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        xCoordinate.lineWidth = 3
        xCoordinate.zPosition = 1
        self.addChild(xCoordinate)
        
        // draw scale on trigonometric graph
        path3.move(to: CGPoint(x: self.frame.size.width/10, y: 0))
        self.addChild(lineshape3)
        for i in 1 ... 4{
            path3.addLine(to: CGPoint(x: self.frame.size.width/10 * CGFloat(i), y: CGFloat(10)))
            path3.move(to: CGPoint(x: self.frame.size.width/10 * CGFloat(i+1), y: 0))
            lineshape3.path = path3
            lineshape3.zPosition = 2
            lineshape3.strokeColor = UIColor.black
            lineshape3.lineWidth = 2
            let label = SKLabelNode() // Size of Circle
            label.position = CGPoint(x: self.frame.size.width/10 * CGFloat(i), y: -CGFloat(20)) //Middle of Screen
            label.fontColor = UIColor.black
            label.fontSize = 15
            if i%2 == 0 {
                label.text = "\(i/2)π"
            }
            else{
                
                label.text = "\(Double(i/2) + 0.5)π"
            }
            self.addChild(label)
        }
    }
    
    @objc func updateTimer() {
        
        // Calculate total time since timer started in seconds
        //        var currentTime = Date().timeIntervalSinceReferenceDate - startTime
        if pause == false && finishGame == false{
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
        
        //SpriteKit tries to run(update) the game at 60 frames per 1 second. So each frame is about 0.01667 seconds
        // For drawing the graph, according to rotation speed, it takes 240 frames to finish 2pi
        
        // once user press the go button, it begins to draw the trigonometric graph
        if goPressed == true{
            
            // when frames greater than 240 which means that it finishes drawing the trigonometric graph, check 5 dots with the target function. If within 20, success, otherwise, lose heart
            if tickCount > 240{
                ferrisWheelNode?.alpha = 0
                playerNodeAd6!.alpha = 0
                for i in 1 ... 5 {
                    let positionX1 = (self.childNode(withName: "circle\(i)") as! SKShapeNode).position.x
                    let positionX2 = (self.childNode(withName: "node\(i)") as! SKShapeNode).position.x
                    let positionY1 = (self.childNode(withName: "circle\(i)") as! SKShapeNode).position.y
                    let positionY2 = (self.childNode(withName: "node\(i)") as! SKShapeNode).position.y
                    // calculate the abs distance of 5 dots that user draws between the 5 dots of target function
                    if abs(Double(positionX1 - positionX2)) > 20 || abs(Double(positionY1 - positionY2)) > 20 {
                        gameSuccess = false
                    }
                }
                
                if gameSuccess == true {
                    // successfully finishes the game
                    path1 = CGMutablePath()
                    lineshape1.path = path1
                    if timeToRemain == 0{
                        // play appauld music and flashes the graph
                        run(Sound.applaud.action)
                        (self.childNode(withName: "circle\(1)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "node\(1)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "circle\(2)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "node\(2)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "circle\(3)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "node\(3)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "circle\(4)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "node\(4)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "circle\(5)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        (self.childNode(withName: "node\(5)") as! SKShapeNode).run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        
                        lineshape.run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        lineshape2.run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 8))
                        
                    }
                    // after flashing, showing the congratulation pop up window
                    timeToRemain = timeToRemain + 1
                    if timeToRemain == 200 {
                        let data = applicationDelegate.levelRecordDictionary["level5"] as! NSDictionary
                        var gameData = data as! Dictionary<String, Int>
                        
                        // update highest star for level 5
                        if self.heartsArray.count > gameData["highestStar"]! {
                            gameData["highestStar"] = self.heartsArray.count
                        }
                        // update time counter for level 5
                        if self.timerCount < gameData["timeCount"]! {
                            gameData["timeCount"] = self.timerCount
                        }
                        // update badge, set 1 for obtain the badge
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
                        // if finish game within 20 sec, get expert badge
                        if self.timerCount <= 20 {
                            gameData["expertBadge"] = 1
                            let expertBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "expertBadge"))
                            expertBadgeNode.setScale(0.8)
                            expertBadgeNode.position = CGPoint(x: congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
                            expertBadgeNode.name = "badge2"
                            expertBadgeNode.zPosition = 4
                            addChild(expertBadgeNode)
                        }
                        
                        applicationDelegate.levelRecordDictionary.setValue(gameData, forKey: "level5")
                        
                        finishGame = true
                        congratulationNode.texture = SKTexture(imageNamed: "congratulationSign\(self.heartsArray.count)")
                        congratulationNode?.zPosition = 3
                        congratulationNode?.alpha = 1
                        gotItButtonNode?.zPosition = 4
                        gotItButtonNode?.alpha = 1
                    }
                }
                else{
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
                    ferrisWheelNode!.position = CGPoint(x: -self.frame.size.width/4, y: 0)
                    ferrisWheelNode?.setScale(1)
                    ferrisWheelNode?.alpha = 1
                    ferrisWheelNode?.zRotation = 0
                    arrowDirectionNode?.zRotation = 0
                    radius = Double(ferrisWheelNode!.frame.size.width*10/24)
                    playerNodeAd6!.position = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius), y: 0)
                    playerNodeAd6!.setScale(0.2)
                    playerNodeAd6!.alpha = 1
                    currentLocation = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius),y:0)
                    path = CGMutablePath()
                    path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
                    lineshape.path = path
                    sizeSlideAction = false
                    speedSlideAction = false
                    moveAction = false
                    gameSuccess = true
                    goPressed = false
                    slideButtonNode!.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height * 3 / 8)
                    speedSlideButtonNode!.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height * 3 / 8)
                    for i in 1 ... 5 {
                        if let child = self.childNode(withName: "node\(i)") as? SKShapeNode {
                            child.removeFromParent()
                        }
                    }
                    rotationAngle = 0
                    tempAngle = 0
                    nodeNumber = 0
                    tickCount = 0
                    path1 = CGMutablePath()
                    lineshape1.path = path1
                }
                return
            }
            //drawing the 5 dots of the trigonometric graph, name it node1, node2...node5
            if tickCount % 60 == 0 {
                nodeNumber = nodeNumber + 1
//                print(tickCount)
//                print(nodeNumber)
                let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
                circle.position = CGPoint(x: currentLocation.x, y: CGFloat(radius * sin(rotationAngle)))
                circle.strokeColor = UIColor.red
                circle.fillColor = UIColor.red
                circle.glowWidth = 1.0
                circle.name = "node\(nodeNumber)"
                circle.zPosition = 2
                self.addChild(circle)
            }
            
            // make water wheel rotate with rotation speed pi/2
            let rotation = SKAction.rotate(byAngle: (CGFloat)(rotationSpeed * deltaTime), duration: 0)
            ferrisWheelNode?.run(rotation)
            rotationAngle = rotationAngle + rotationSpeed * deltaTime
           
            // this is the x displacement for drawing the trigonometric graph
            let displacement = CGVector(dx: moveSpeed, dy: 0)

//            let movement = SKAction.move(to: CGPoint(x: currentLocation.x + displacement.dx + CGFloat(radius * (cos(rotationAngle) - 1)), y: CGFloat(radius * sin(rotationAngle))), duration: 0)
            
            // playerNode rotate along with water wheel
            let movement = SKAction.move(to: CGPoint(x: ferrisWheelNode!.position.x + CGFloat(radius * cos(rotationAngle)), y: CGFloat(radius * sin(rotationAngle))), duration: 0)
            playerNodeAd6?.run(movement)
            
            // adding the line frame by frame
            path.addLine(to: CGPoint(x: currentLocation.x + displacement.dx, y: CGFloat(radius * sin(rotationAngle))))
            path.move(to: CGPoint(x: currentLocation.x + displacement.dx, y: CGFloat(radius * sin(rotationAngle))))
            currentLocation = CGPoint(x:currentLocation.x + displacement.dx, y:currentLocation.y + displacement.dy)
            
            lineshape.path = path
            lineshape.strokeColor = UIColor.black
            lineshape.lineWidth = 3
            lineshape.zPosition = 3
            
            path1.move(to: CGPoint(x: currentLocation.x, y: CGFloat(radius * sin(rotationAngle))))
//            path1.addLine(to: CGPoint(x: currentLocation.x + CGFloat(radius * (cos(rotationAngle) - 1)), y: CGFloat(radius * sin(rotationAngle))))
            path1.addLine(to: CGPoint(x: ferrisWheelNode!.position.x + CGFloat(radius * cos(rotationAngle)), y: CGFloat(radius * sin(rotationAngle))))
            lineshape1.path = path1
            lineshape1.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
            lineshape1.lineWidth = 3
            lineshape1.zPosition = 1
            
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
            }
            if self.atPoint(location) == self.speedSlideButtonNode {
                speedSlideAction = true  //make this true so it will only move when you touch it.
            }
        }
        
        // touch the arrow node to change its direction counterclockwise by 90 degree, also change the starting position for playerNode
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "arrowDirection"{
                tempAngle = tempAngle + Double.pi/2
                let action = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0)
                arrowDirectionNode?.run(action)
                ferrisWheelNode?.run(action)
                let movement = SKAction.move(to: CGPoint(x: ferrisWheelNode!.position.x + CGFloat(radius * cos(tempAngle)), y: CGFloat(radius * sin(tempAngle))), duration: 0)
                playerNodeAd6?.run(movement)
                rotationAngle = tempAngle
            }
            // click go button to set goPressed flag to true and start drawing lines in update function
            if nodesArray.first?.name == "goButton"{
                currentLocation = CGPoint(x: 0, y:CGFloat(radius * sin(tempAngle)))
                path.move(to: CGPoint(x: 0, y:CGFloat(radius * sin(tempAngle))))
                goPressed = true
            }
            
            // buttons that helps user to pause, replay, go back
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
                    let adventureScene5 = AdventureScene5(fileNamed: "AdventureScene5")
                    adventureScene5?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene5!)
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
                congratulationNode?.alpha = 0
                gotItButtonNode?.alpha = 0
                congratulationNode?.zPosition = -2
                gotItButtonNode?.zPosition = -3
                (self.childNode(withName: "badge1") as! SKSpriteNode).removeFromParent()
                if self.timerCount <= 20{
                    (self.childNode(withName: "badge2") as! SKSpriteNode).removeFromParent()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sizeSlideAction == false && speedSlideAction == false { return }
        // if user is moving the size slider, change the scale of the water wheel
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
                let scale = 0.5 + (slideButtonNode!.position.x - (slideBarNode!.position.x - slideBarNode!.frame.size.width/2))/slideBarNode!.frame.size.width * 1
                ferrisWheelNode!.setScale(scale)
                playerNodeAd6!.setScale(0.2*scale)
                radius = Double(ferrisWheelNode!.frame.size.width*10/24)
                playerNodeAd6!.position = CGPoint(x: ferrisWheelNode!.position.x + CGFloat(radius * cos(tempAngle)), y: CGFloat(radius * sin(tempAngle)))
            }
        }
            
        // if user is moving the period slider, change the moving speed of the water wheel
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when touches end, set sizeSlideAction and speedSlideAction to false
        for touch in touches{
            if sizeSlideAction {
                sizeSlideAction = false
            }
            
            if speedSlideAction{
                speedSlideAction = false
            }
        }
    }
}


extension UIBezierPath {
    func addArrow5(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
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



