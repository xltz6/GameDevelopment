//
//  AdventureScene4.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 1/23/19.
//  Copyright © 2019 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit
import Foundation

class AdventureScene4: SKScene, SKPhysicsContactDelegate {
    //declare all the SKNodes and SKlabels
    var playerAd4Node: SKNode?
    var rockNode: SKNode?
    var cliffNode: SKNode?
    var finishButtonNode: SKNode?
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    var resumeButtonNode: SKNode?
    var questionButtonNode: SKNode?
    var tutorialNode: SKNode?
    var tutorialTitleNode = SKLabelNode()
    var tutorialLabelNode = SKLabelNode()
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    var targetFunctionLabel: SKLabelNode!
    var cameraNode: SKCameraNode?
    var congratulationNode: SKSpriteNode!
    var gotItButtonNode: SKNode?
    
    var pause = false
    var tutorialShow = false
    var pressPlayer = false
    var moved = false
    var success = false
    var finishGame = false
    var interval: CGFloat = 0
    var backOrReplay = "back"
    //Hearts
    var heartsArray: [SKSpriteNode]!
    //Timer
    let timeCounterLabel = SKLabelNode()
    //    var timeCounterLabel: SKLabelNode!
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    
    //path for drawing log function
    //path2 and lineshape 2 for drawing scale
    //path1 for drawing the answer log function after successfully finish
    var path = CGMutablePath()
    let lineshape = SKShapeNode()
    var path2 = CGMutablePath()
    let lineshape2 = SKShapeNode()
    var path1 = CGMutablePath()
    let lineshape1 = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    var a: Double = 2.0
    var b: Double = 3.0
    // target function parameters
    var answerA: Double = 0
    var answerB: Double = 0
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
        // In .sks file, drag a camera node to the scene, name it "cameraNode". Go to Attributes Inspector, for camera, choose cameraNode
        // add cameraNode to the scene here
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
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
        
        finishButtonNode = self.childNode(withName: "finishButton")
        finishButtonNode?.position = CGPoint(x: self.frame.size.width/3, y: -self.frame.size.height/2.8)
        finishButtonNode?.zPosition = 4
        
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        backButtonNode?.zPosition = 4
        pauseButtonNode = self.childNode(withName: "pauseButton")
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/30 - (pauseButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        pauseButtonNode?.zPosition = 2
        
        resumeButtonNode = self.childNode(withName: "resumeButton")
        resumeButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/30 - (resumeButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (resumeButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        resumeButtonNode?.zPosition = -3
        
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/3 - (replayButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        replayButtonNode?.zPosition = 2
        
        // add 3 hearts to game scene
        fillHearts(count: 3)
        
        timeCounterLabel.zPosition = 2
        timeCounterLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        timeCounterLabel.fontSize = 32
        timeCounterLabel.fontName = "AvenirNext-Bold"
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00:00"
        self.addChild(timeCounterLabel)
        
        // start timer by calling the updateTimer function
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        questionButtonNode = self.childNode(withName: "questionButton")
        questionButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (questionButtonNode?.frame.size.height)!/2 - self.frame.size.width/11)
        questionButtonNode?.zPosition = 4
        
        // when player clicks the question node, an popup window comes out. Some instructions will list on there
        tutorialNode = self.childNode(withName: "tutorialbg")
        tutorialNode!.zPosition = -5
        tutorialNode!.alpha = 0
        tutorialNode!.position = CGPoint(x: 0, y: 0)
        
        tutorialTitleNode.horizontalAlignmentMode = .center
        tutorialTitleNode.verticalAlignmentMode = .center
        tutorialTitleNode.position = CGPoint(x: 0, y: self.frame.size.height/8)
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
        tutorialLabelNode.text = "Your challenge is to use the spring board to jump and fly over the cliff, only when you reproduce the target function could start the spring board. \nDrag the Character, move up or down to change the shape of the springboard to match the target function shows below time label. Click Finish button to check your answer."
        tutorialLabelNode.numberOfLines = 5
        tutorialLabelNode.preferredMaxLayoutWidth = self.frame.size.width/3
        tutorialLabelNode.zPosition = -6
        tutorialLabelNode.alpha = 0
        self.addChild(tutorialLabelNode)
        
        // alertNode is a pop up alert when player click backButton and replayButton.
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
        arrowY.addArrow4(start: CGPoint(x: -self.frame.size.width/8, y: -self.frame.size.height/2), end: CGPoint(x: -self.frame.size.width/8, y: self.frame.size.height/2 - 40), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        yCoordinate.lineWidth = 3
        yCoordinate.zPosition = 2
        self.addChild(yCoordinate)
        //X axis
        let arrowX = UIBezierPath()
        arrowX.addArrow4(start: CGPoint(x: -self.frame.width/2, y: -self.frame.height/4), end: CGPoint(x: self.frame.width/2 - 40, y: -self.frame.height/4), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        xCoordinate.lineWidth = 3
        xCoordinate.zPosition = 2
        self.addChild(xCoordinate)
        
        path.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * interval, y: -self.frame.size.height/4 - 3 * interval))
        
        lineshape.zPosition = 2
        lineshape.strokeColor = UIColor.black
        self.addChild(lineshape)
        self.addChild(lineshape2)
        
        //draw  log function 
        //start from -1/5width, -1/4height, end at width 9/20, 3/8height
        // xScale: 0.5-20 , yScale: 0 - 15
        //Interval: 13/400width
        
        interval = self.frame.size.width*13/400
        
        // randomly create target log function parameter a and b
        var aTemp:Int = 0
        var bTemp:Int = 0
        aTemp = Int.random(in: 2 ... 4)
        if aTemp == 2 {
            bTemp = Int.random(in: 1 ... 3)
        }
        if aTemp == 3 {
            bTemp = Int.random(in: 2 ... 5)
        }
        if aTemp == 4 {
            bTemp = Int.random(in: 2 ... 6)
        }
        answerA = Double(aTemp)
        answerB = Double(bTemp)
        
        targetFunctionLabel = self.childNode(withName: "targetFunction") as? SKLabelNode
        targetFunctionLabel.zPosition = 4
        targetFunctionLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/11 - 5)
        // if parameter b is 1, then don't show 1 in equaiton such as y = log2 x
        if bTemp == 1 {
            // Using NSMutableAttributedString to achieve superscript and subscript in function equation
            targetFunctionLabel.text = "Y = log\(Int(answerA))X"
            let textString = targetFunctionLabel.text!
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: textString, attributes: [.font: UIFont(name: "Gill Sans", size:30)!])
            // add attributes for subscript, using .baselineOffset negative to move characters a little bit down as subscript
            attString.addAttributes([.font:UIFont(name: "Gill Sans", size:20)!,.baselineOffset: -6], range: NSRange(location: 7,length:1))
            targetFunctionLabel.attributedText = attString
        }
        else{
            targetFunctionLabel.text = "Y = \(Int(answerB))log\(Int(answerA))X"
            let textString = targetFunctionLabel.text!
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: textString, attributes: [.font: UIFont(name: "Gill Sans", size:30)!])
            attString.addAttributes([.font:UIFont(name: "Gill Sans", size:20)!,.baselineOffset: -6], range: NSRange(location: 8,length:1))
            targetFunctionLabel.attributedText = attString
        }
        
        //drawing the log function
        for i in 50 ... 1700 {
            // start from 0.5, for every 0.01, draw lines to confuct a log function graph
            let y = CGFloat(b * logC(val: Double(i)/100.0, forBase: a))
            path.addLine(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y: -self.frame.size.height/4 + y * interval))
            path.move(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y: -self.frame.size.height/4 + y * interval))
            
            // draw a red dot when x = 1, y = 0
            if i == 100{
                let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
                circle.position = CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y: -self.frame.size.height/4 + y * interval) //Middle of Screen
                circle.strokeColor = UIColor.red
                circle.fillColor = UIColor.red
                circle.zPosition = 3
                circle.glowWidth = 1.0
                self.addChild(circle)
            }
            
            //draw xScale, for every interval = 1 show the scale
            if i%100 == 0{
                let scaleNumber = i/100
                path2.move(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y: -self.frame.size.height/4))
                path2.addLine(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y:  -self.frame.size.height/4 + 13 * interval))
                lineshape2.path = path2
                lineshape2.strokeColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha: 0.2)
                lineshape2.zPosition = 2
                lineshape2.lineWidth = 2
                let scaleLabel = SKLabelNode()
                scaleLabel.position = CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y:  -self.frame.size.height/4 - 20)
                scaleLabel.text = "\(scaleNumber)"
                scaleLabel.fontSize = 20
                scaleLabel.fontName = "Arial-Bold"
                scaleLabel.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha: 1)
                scaleLabel.name = "xScale\(i/100)"
                scaleLabel.zPosition = 2
                self.addChild(scaleLabel)
            }
            
            //draw yScale
            if i%100 == 0 && i <= 1300{
                let scaleNumber = i/100
                path2.move(to: CGPoint(x: -self.frame.size.width/8 , y:  -self.frame.size.height/4 + CGFloat(Double(i)/100.0) * interval))
                path2.addLine(to: CGPoint(x: -self.frame.size.width/8 + 17 * interval, y:  -self.frame.size.height/4 + CGFloat(Double(i)/100.0) * interval))
                lineshape2.path = path2
                lineshape2.strokeColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha: 0.2)
                lineshape2.zPosition = 2
                lineshape2.lineWidth = 2
                let scaleLabel = SKLabelNode()
                scaleLabel.position = CGPoint(x: -self.frame.size.width/8 - 15, y:  -self.frame.size.height/4 + CGFloat(Double(i)/100.0) * interval - 10)
                scaleLabel.text = "\(scaleNumber)"
                scaleLabel.fontSize = 20
                scaleLabel.fontName = "Arial-Bold"
                scaleLabel.fontColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha: 1)
                scaleLabel.name = "yScale\(i/100)"
                scaleLabel.zPosition = 2
                self.addChild(scaleLabel)
            }
            
            lineshape.path = path
            // brown color makes it looks more like a spring Board
            lineshape.strokeColor = UIColor(red:0.53, green:0.37, blue:0.18, alpha:1.0)
            // line width 20, make the line thicker to look more like a spring board
            lineshape.lineWidth = 20
            lineshape.zPosition = 2
        }
        
        // set the position for player node, rock and cliff node
        let xPosition = -self.frame.size.width/8 + CGFloat(17) * interval
        let Y = CGFloat(3.0 * logC(val: 17.0, forBase: 2.0))
        playerAd4Node = self.childNode(withName: "playerAd4")
        playerAd4Node?.position = CGPoint(x: xPosition - (playerAd4Node?.frame.size.width)!/2, y: -self.frame.size.height/4 + Y * interval + (playerAd4Node?.frame.size.height)!/2)
        playerAd4Node?.zPosition = 3
        
        rockNode = self.childNode(withName: "rock")
        rockNode!.position = CGPoint(x: -self.frame.size.width/8 + interval + rockNode!.frame.size.width/2 - 5, y: -self.frame.size.height/2 + rockNode!.frame.size.height/2 + 2 * interval)
        rockNode?.zPosition = 1
        
        cliffNode = self.childNode(withName: "cliff")
        cliffNode!.position = CGPoint(x: -self.frame.size.width/8-cliffNode!.frame.size.width/2 + interval - 5, y: -self.frame.size.height/2 + cliffNode!.frame.size.height/2 + 2 * interval)
        cliffNode?.zPosition = -1
        
        path.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * interval, y: -self.frame.size.height/4 - 3 * interval))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if success == true && finishGame == false{
            let xPosition = -self.frame.size.width/8 + CGFloat(17) * interval
            let Y = CGFloat(answerB * logC(val: 17.0, forBase: answerA))
            
            // cameraNode is changing position when PlayerNode flies out from the spring Board
            cameraNode!.position.x = playerAd4Node!.position.x - (xPosition - (playerAd4Node?.frame.size.width)!/2)
            cameraNode!.position.y = playerAd4Node!.position.y - (-self.frame.size.height/4 + Y * interval + (playerAd4Node?.frame.size.height)!/2)
        }
        
        // pressPlayer is true when user moves the playerNode
        if pressPlayer == true && pause == false{
            path.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * interval, y: -self.frame.size.height/4 - 3 * interval))
            // update log function (redraw the graph) when user move the playerNode up and down
            for i in 5 ... 170 {
                // a is changing when user moves the playerNode
                var y = CGFloat(b * logC(val: Double(i)/10.0, forBase: a))
                if moved == true{
                    y = CGFloat(answerB * logC(val: Double(i)/10.0, forBase: a))
                }
                
                path.addLine(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/10.0) * interval, y: -self.frame.size.height/4 + y * interval))
                path.move(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/10.0) * interval, y: -self.frame.size.height/4 + y * interval))
                
                if i == 10{
                    let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
                    circle.position = CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/10.0) * interval, y: -self.frame.size.height/4 + y * interval) //Middle of Screen
                    circle.strokeColor = UIColor.red
                    circle.fillColor = UIColor.red
                    circle.zPosition = 3
                    circle.glowWidth = 1.0
                    self.addChild(circle)
                }
                
                lineshape.path = path
                // brown color makes it looks more like a spring Board
                lineshape.strokeColor = UIColor(red:0.53, green:0.37, blue:0.18, alpha:1.0)
                // line width 20, make the line thicker to look more like a spring board
                lineshape.lineWidth = 20
                lineshape.zPosition = 2
            }
            
            path.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * interval, y: -self.frame.size.height/4 - 3 * interval))
        }
    }
    
    // function for log function calculation
    func logC(val: Double, forBase base: Double) -> Double {
        return log(val)/log(base)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
//            let location = touch.location(in: self)
//            if self.atPoint(location) == self.playerAd4Node {
//                pressPlayer = true  //make this true so it will only move when you touch it.
//            }
            if playerAd4Node!.contains(touch.location(in: self)) {
                pressPlayer = true //make this true so playerNode will only be moved when you touch it.
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
                    let adventureScene4 = AdventureScene4(fileNamed: "AdventureScene4")
                    adventureScene4?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene4!)
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
                // makes it deactive when finishes the game
                if finishGame == true {return}
                if tutorialShow == false {
                    //show tutorial
                    // makes it deactive when pauses the game
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
                // make congratulation pop up window, button and badges disappear
                congratulationNode?.alpha = 0
                gotItButtonNode?.alpha = 0
                congratulationNode?.zPosition = -2
                gotItButtonNode?.zPosition = -3
                (self.childNode(withName: "badge1") as! SKSpriteNode).removeFromParent()
                if self.timerCount <= 20{
                    (self.childNode(withName: "badge2") as! SKSpriteNode).removeFromParent()
                }
            }
            
            if nodesArray.first?.name == "finishButton"{
                // click finish button, check your log function, if your answer is close to the target log function, then you success, otherwise lose heart
                if pause == false{
//                    print(abs(a - answerA))
                    // check parameter a with answerA(target function parameter), less than 0.1, success
                    if moved == true && abs(a - answerA) < 0.1 {
                        //success and draw log graph
                        run(Sound.applaud.action)
                        path1.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * interval, y: -self.frame.size.height/4 - 3 * interval))
                        self.addChild(lineshape1)
                        
                        for i in 50 ... 1700 {
                            let y = CGFloat(answerB * logC(val: Double(i)/100.0, forBase: answerA))
                            path1.addLine(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y: -self.frame.size.height/4 + y * interval))
                            path1.move(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * interval, y: -self.frame.size.height/4 + y * interval))
                            
                            
                            lineshape1.path = path
                            lineshape1.strokeColor = UIColor.black
                            lineshape1.lineWidth = 3
                            lineshape1.zPosition = 3
                        }
                        
                        success = true
                        // give playerNode a physics body, an impulse and let it affect by gravity, so that playerNode could fly away which looks like the spring board effect
                        playerAd4Node!.physicsBody = SKPhysicsBody(rectangleOf: playerAd4Node!.frame.size)
                        
                        playerAd4Node?.physicsBody?.isDynamic = true
                        playerAd4Node?.physicsBody!.affectedByGravity = true
                        
                        playerAd4Node!.physicsBody?.applyImpulse(CGVector(dx: -80, dy: 60))
                        
                        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
                        self.physicsWorld.contactDelegate = self
                        
                        // let playerNode fly for 1 sec and then remove the physics world and current velocity.
                        // change cameraNode position to its orginal position(0,0), finishes the game
                        delay(1){
                            self.finishGame = true
                            self.playerAd4Node?.physicsBody?.isDynamic = false
                            self.playerAd4Node?.physicsBody!.affectedByGravity = false
                            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                            self.physicsWorld.contactDelegate = self
                            
                            self.playerAd4Node!.physicsBody?.velocity =  CGVector()
                            self.playerAd4Node!.physicsBody?.angularVelocity = 0
                            
                            self.cameraNode!.position = CGPoint(x: 0, y: 0)
                            
                            let data = self.applicationDelegate.levelRecordDictionary["level4"] as! NSDictionary
                            var gameData = data as! Dictionary<String, Int>
                            
                            // update highest star for level 4
                            if self.heartsArray.count > gameData["highestStar"]! {
                                gameData["highestStar"] = self.heartsArray.count
                            }
                            // update time counter for level 4
                            if self.timerCount < gameData["timeCount"]! {
                                gameData["timeCount"] = self.timerCount
                            }
                            // update badge, set 1 for obtain the badge
                            if self.heartsArray.count == 1 {
                                gameData["beginnerBadge"] = 1
                                let beginnerBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "beginnerBadge"))
                                beginnerBadgeNode.setScale(0.8)
                                beginnerBadgeNode.position = CGPoint(x: -self.congratulationNode!.frame.size.width/3, y: -self.congratulationNode!.frame.size.height/3)
                                beginnerBadgeNode.name = "badge1"
                                beginnerBadgeNode.zPosition = 4
                                self.addChild(beginnerBadgeNode)
                            }
                            if self.heartsArray.count == 2 {
                                gameData["competentBadge"] = 1
                                let competentBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "competentBadge"))
                                competentBadgeNode.setScale(0.8)
                                competentBadgeNode.position = CGPoint(x: -self.congratulationNode!.frame.size.width/3, y: -self.congratulationNode!.frame.size.height/3)
                                competentBadgeNode.name = "badge1"
                                competentBadgeNode.zPosition = 4
                                self.addChild(competentBadgeNode)
                            }
                            if self.heartsArray.count == 3 {
                                gameData["proficientBadge"] = 1
                                let proficientBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "proficientBadge"))
                                proficientBadgeNode.setScale(0.8)
                                proficientBadgeNode.position = CGPoint(x: -self.congratulationNode!.frame.size.width/3, y: -self.congratulationNode!.frame.size.height/3)
                                proficientBadgeNode.name = "badge1"
                                proficientBadgeNode.zPosition = 4
                                self.addChild(proficientBadgeNode)
                            }
                            if self.timerCount <= 20 {
                                gameData["expertBadge"] = 1
                                let expertBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "expertBadge"))
                                expertBadgeNode.setScale(0.8)
                                expertBadgeNode.position = CGPoint(x: self.congratulationNode!.frame.size.width/3, y: -self.congratulationNode!.frame.size.height/3)
                                expertBadgeNode.name = "badge2"
                                expertBadgeNode.zPosition = 4
                                self.addChild(expertBadgeNode)
                            }
                            
                            self.applicationDelegate.levelRecordDictionary.setValue(gameData, forKey: "level4")
                            
                            // shows the congratulation pop up window
                            self.congratulationNode.texture = SKTexture(imageNamed: "congratulationSign\(self.heartsArray.count)")
                            self.congratulationNode?.zPosition = 3
                            self.congratulationNode?.alpha = 1
                            self.gotItButtonNode?.zPosition = 4
                            self.gotItButtonNode?.alpha = 1
                            
                            
//                            let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
//                            gameSuccessScene?.scaleMode = .aspectFill
//                            gameSuccessScene!.performanceLevel = self.heartsArray.count
//                            gameSuccessScene!.level = 4
//                            self.view?.presentScene(gameSuccessScene!)
                        }
                    }
                    // if your log function is not the target log function, lose a heart
                    else{
                        //lose heart and reset the game
                        loseHeart()
                        a = 2.0
                        b = 3.0
                        moved = false
                        // flashes the rest of the hearts and the wrong log function to let user know that you lose a heart
                        for i in 0 ..< heartsArray.count{
                            let heartNode = self.heartsArray[i]
                            heartNode.run(SKAction.repeat(.sequence([
                                .fadeAlpha(to: 0.2, duration: 0.05),
                                .wait(forDuration: 0.1),
                                .fadeAlpha(to: 1.0, duration: 0.05),
                                .wait(forDuration: 0.1),
                                ]), count: 3))
                        }
                        lineshape.run(SKAction.repeat(.sequence([
                            .fadeAlpha(to: 0.2, duration: 0.05),
                            .wait(forDuration: 0.1),
                            .fadeAlpha(to: 1.0, duration: 0.05),
                            .wait(forDuration: 0.1),
                            ]), count: 3))
                        
                        // redraw the log function after 1 sec
                        delay(1.0){
                            self.path = CGMutablePath()
                            (self.lineshape).path = self.path
                            self.path.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * self.interval, y: -self.frame.size.height/4 - 3 * self.interval))
                            for i in 50 ... 1700 {
                                let y = CGFloat(3.0 * self.logC(val: Double(i)/100.0, forBase: 2.0))
                                self.path.addLine(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * self.interval, y: -self.frame.size.height/4 + y * self.interval))
                                self.path.move(to: CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * self.interval, y: -self.frame.size.height/4 + y * self.interval))
                                
                                if i == 100{
                                    let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
                                    circle.position = CGPoint(x: -self.frame.size.width/8 + CGFloat(Double(i)/100.0) * self.interval, y: -self.frame.size.height/4 + y * self.interval) //Middle of Screen
                                    circle.strokeColor = UIColor.red
                                    circle.fillColor = UIColor.red
                                    circle.zPosition = 3
                                    circle.glowWidth = 1.0
                                    self.addChild(circle)
                                }
                                (self.lineshape).path = self.path
                                self.lineshape.strokeColor = UIColor(red:0.53, green:0.37, blue:0.18, alpha:1.0)
                                self.lineshape.lineWidth = 20
                                self.lineshape.zPosition = 2
                            }
                            
                            // reposition the playerNode
                            let xPosition = -self.frame.size.width/8 + CGFloat(17) * self.interval
                            let Y = CGFloat(3.0 * self.logC(val: 17.0, forBase: 2.0))
                            self.playerAd4Node = self.childNode(withName: "playerAd4")
                            self.playerAd4Node?.position = CGPoint(x: xPosition - (self.playerAd4Node?.frame.size.width)!/2, y: -self.frame.size.height/4 + Y * self.interval + (self.playerAd4Node?.frame.size.height)!/2)
                            self.playerAd4Node?.zPosition = 3
                            self.path.move(to: CGPoint(x: -self.frame.size.width/8 + 0.5 * self.interval, y: -self.frame.size.height/4 - 3 * self.interval))
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when user touches the playerNode, it allows to move the playerNode
        if pressPlayer == true && pause == false{
            for touch in touches{
                // it only allows to move  up and down , so playerNode's xposition does not change
                // playerNode could only be moved in range of 4-13 (yscale)
                let position = touch.location(in: self)
                let xPosition = -self.frame.size.width/8 + CGFloat(17) * interval
                if position.y > -self.frame.size.height/4 + 13 * interval + playerAd4Node!.frame.size.height/2 {
                    playerAd4Node!.position = CGPoint(x: xPosition - playerAd4Node!.frame.size.width/2, y: -self.frame.size.height/4 + 13 * interval + playerAd4Node!.frame.size.height/2)
                }
                else if position.y < -self.frame.size.height/4 + 4 * interval + playerAd4Node!.frame.size.height/2 {
                    playerAd4Node!.position = CGPoint(x: xPosition - playerAd4Node!.frame.size.width/2, y: -self.frame.size.height/4 + 4 * interval + playerAd4Node!.frame.size.height/2)
                }
                else {
                    playerAd4Node!.position = CGPoint(x: xPosition - playerAd4Node!.frame.size.width/2, y: position.y)
                }
            }
            
            // calculate the log function y
            let functionY = Double((playerAd4Node!.position.y - playerAd4Node!.frame.size.height/2 + self.frame.size.height/4)/interval)
            
            // according to the y, recalculate the parameter a
            // in update function, according this changing a variable , draw the log function
            let y = 1/functionY*answerB
            a = pow(17.0, y)
            
            if a != 2.0 {
                moved = true
            }
            path = CGMutablePath()
            lineshape.path = path
            print(a)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when touches end, set presPlayer flag to false
        if pressPlayer {
            delay(0.02){
                self.pressPlayer = false
            }
        }
    }
    
    // delay function to execute after certain time
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}


extension UIBezierPath {
    func addArrow4(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
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
