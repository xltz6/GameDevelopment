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
    var resumeButtonNode: SKNode?
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    
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
    // lineshape for connection between wheel and trigonometric graph
    var path1 = CGMutablePath()
    var lineshape1 = SKShapeNode()
    // lineshape for original graph
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
        waterbg5Node = self.childNode(withName: "waterbg5")
        waterbg5Node?.zPosition = -1
        ferrisWheelNode = self.childNode(withName: "waterWheel")
        ferrisWheelNode!.position = CGPoint(x: -self.frame.size.width/4, y: 0)
        ferrisWheelNode?.zPosition = 1
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
        speedSlideButtonNode!.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height * 3 / 8)
        speedSlideButtonNode?.zPosition = 2
        speedSlideBarNode = self.childNode(withName: "speedSlideBar")
        speedSlideBarNode!.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height * 3 / 8)
        speedSlideBarNode?.zPosition = 1
        
        arrowDirectionNode = self.childNode(withName: "arrowDirection")
        arrowDirectionNode!.position = CGPoint(x: -self.frame.size.width/11, y: -self.frame.size.height * 3 / 8)
        arrowDirectionNode?.zPosition = 2
        
        goButtonNode = self.childNode(withName: "goButton")
        goButtonNode?.setScale(0.8)
        goButtonNode!.position = CGPoint(x: self.frame.size.width/2.7, y: -self.frame.size.height * 3 / 8)
        goButtonNode!.zPosition = 2
        
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
        
        currentLocation = CGPoint(x: -self.frame.size.width/4 + CGFloat(radius),y:0)
        path.move(to: CGPoint(x: currentLocation.x, y: currentLocation.y))
//        print(currentLocation.x)
        lineshape.zPosition = 4
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
            let circle = SKShapeNode(circleOfRadius: 3) // Size of Circle
            circle.position = CGPoint(x: 0 + CGFloat(i-1) * self.frame.size.width/CGFloat(tempX), y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + initialAngle))) //Middle of Screen
            circle.strokeColor = UIColor.black
            circle.fillColor = UIColor.black
            circle.glowWidth = 1.0
            circle.name = "circle\(i)"
            self.addChild(circle)
            currentLocation1 = CGPoint(x:0 + CGFloat(i-1) * self.frame.size.width/CGFloat(tempX),y: 0)
            if i != 5 {
                for j in 1 ... 20{
                    path2.addLine(to: CGPoint(x: currentLocation1.x + CGFloat(j-1) * self.frame.size.width/CGFloat(tempX)/20, y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + initialAngle + (Double)(j-1) * Double.pi/2/20))))
                    path2.move(to: CGPoint(x: currentLocation1.x + CGFloat(j-1) * self.frame.size.width/CGFloat(tempX)/20, y: (CGFloat)(0 + radiusR * sin((Double)(i-1) * Double.pi/2 + initialAngle + (Double)(j-1) * Double.pi/2/20))))
                    lineshape2.path = path2
                    lineshape2.zPosition = 3
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
        sizeLabel.preferredMaxLayoutWidth = self.frame.size.width/5
        sizeLabel.fontName = "Arial"
        sizeLabel.position = CGPoint(x: -self.frame.size.width/3, y: -self.frame.size.height/3)
        sizeLabel.text = "Change the size of the water wheel"
        self.addChild(sizeLabel)
        
        speedLabel.zPosition = 2
        speedLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        speedLabel.fontSize = 20
        speedLabel.numberOfLines = 3
        speedLabel.preferredMaxLayoutWidth = self.frame.size.width/5
        speedLabel.fontName = "Arial"
        speedLabel.position = CGPoint(x: self.frame.size.width/7, y: -self.frame.size.height/3)
        speedLabel.text = "change the width of the graph (𝑤 in trigonometric formula)"
        self.addChild(speedLabel)
        
        moveSpeed = 1/1200 * self.frame.size.width + 0.5 * 1/1200 * self.frame.size.width
        
        directionLabel.zPosition = 2
        directionLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        directionLabel.fontSize = 20
        directionLabel.numberOfLines = 3
        directionLabel.preferredMaxLayoutWidth = self.frame.size.width/5
        directionLabel.fontName = "Arial"
        directionLabel.position = CGPoint(x: -self.frame.size.width/11, y: -self.frame.size.height/3)
        directionLabel.text = "Click to change start angle"
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
        tutorialLabelNode.text = "   Choose the moving direction and speed by clicking two buttons. Your goal is to jump across the river and reach the the other side of the mountain! Drop into water and jump too far away will lose a heart. You could try three times for this game."
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
        yCoordinate.zPosition = 4
        self.addChild(yCoordinate)
        //X axis
        let arrowX = UIBezierPath()
        arrowX.addArrow5(start: CGPoint(x: 0, y: 0), end: CGPoint(x: self.frame.size.width*7/16, y: 0), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        xCoordinate.lineWidth = 3
        xCoordinate.zPosition = 4
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
        if goPressed == true{
            
//            if rotationAngle >= 2 * Double.pi + rotationSpeed * deltaTime{
            if tickCount > 240{
                ferrisWheelNode?.alpha = 0
                playerNodeAd6!.alpha = 0
                for i in 1 ... 5 {
                    let positionX1 = (self.childNode(withName: "circle\(i)") as! SKShapeNode).position.x
                    let positionX2 = (self.childNode(withName: "node\(i)") as! SKShapeNode).position.x
                    let positionY1 = (self.childNode(withName: "circle\(i)") as! SKShapeNode).position.y
                    let positionY2 = (self.childNode(withName: "node\(i)") as! SKShapeNode).position.y
//                    print(positionX1 - positionX2)
//                    print(positionY1 - positionY2)
                    if abs(Double(positionX1 - positionX2)) > 15 || abs(Double(positionY1 - positionY2)) > 15 {
                        gameSuccess = false
                    }
                }
                
                if gameSuccess == true {
                    path1 = CGMutablePath()
                    lineshape1.path = path1
                    if timeToRemain == 0{
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
                    timeToRemain = timeToRemain + 1
                    if timeToRemain > 200 {
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
                }
                else{
                    loseHeart()
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
//            let move = SKAction.move(by: displacement, duration: 0)
//            ferrisWheelNode!.run(move)
            
//            let movement = SKAction.move(to: CGPoint(x: currentLocation.x + displacement.dx + CGFloat(radius * (cos(rotationAngle) - 1)), y: CGFloat(radius * sin(rotationAngle))), duration: 0)
            let movement = SKAction.move(to: CGPoint(x: ferrisWheelNode!.position.x + CGFloat(radius * cos(rotationAngle)), y: CGFloat(radius * sin(rotationAngle))), duration: 0)
            playerNodeAd6?.run(movement)
            
            path.addLine(to: CGPoint(x: currentLocation.x + displacement.dx, y: CGFloat(radius * sin(rotationAngle))))
            path.move(to: CGPoint(x: currentLocation.x + displacement.dx, y: CGFloat(radius * sin(rotationAngle))))
            currentLocation = CGPoint(x:currentLocation.x + displacement.dx, y:currentLocation.y + displacement.dy)
            
            lineshape.path = path
            lineshape.strokeColor = UIColor.black
            lineshape.lineWidth = 3
            lineshape.zPosition = 4
            
            path1.move(to: CGPoint(x: currentLocation.x, y: CGFloat(radius * sin(rotationAngle))))
//            path1.addLine(to: CGPoint(x: currentLocation.x + CGFloat(radius * (cos(rotationAngle) - 1)), y: CGFloat(radius * sin(rotationAngle))))
            path1.addLine(to: CGPoint(x: ferrisWheelNode!.position.x + CGFloat(radius * cos(rotationAngle)), y: CGFloat(radius * sin(rotationAngle))))
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
            }
            if self.atPoint(location) == self.speedSlideButtonNode {
                speedSlideAction = true  //make this true so it will only move when you touch it.
            }
        }
        
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
            if nodesArray.first?.name == "goButton"{
                currentLocation = CGPoint(x: 0, y:CGFloat(radius * sin(tempAngle)))
                path.move(to: CGPoint(x: 0, y:CGFloat(radius * sin(tempAngle))))
                goPressed = true
            }
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sizeSlideAction == false && speedSlideAction == false { return }
        
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



// Alert Action
extension AdventureScene5{
    func showAlertPlaying(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
        }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
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



