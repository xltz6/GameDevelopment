//
//  AdventureScene6.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 1/20/19.
//  Copyright © 2019 Xuan Liu. All rights reserved.
//

import UIKit
import GameplayKit
import Foundation

class AdventureScene6: SKScene, SKPhysicsContactDelegate {
    // declare all the SKNodes and SKLabels here
    var bgNodeAd6: SKNode?
    var playerNodeAd6: SKNode?
    var backButtonNode: SKNode?
    var pauseButtonNode: SKNode?
    var replayButtonNode: SKNode?
    var questionButtonNode: SKNode?
    var tutorialNode: SKNode?
    var tutorialTitleNode = SKLabelNode()
    var tutorialLabelNode = SKLabelNode()
    var resumeButtonNode: SKNode?
    var okButtonNode: SKNode?
    var cancelButtonNode: SKNode?
    var alertLabelNode = SKLabelNode()
    var alertNode = SKShapeNode()
    var xButtonNode: SKNode?
    var xp1ButtonNode: SKNode?
    var xp2ButtonNode: SKNode?
    var xp3ButtonNode: SKNode?
    var xn1ButtonNode: SKNode?
    var xn2ButtonNode: SKNode?
    var xn3ButtonNode: SKNode?
    var xn4ButtonNode: SKNode?
    var clearButtonNode: SKNode?
    var checkButtonNode: SKNode?
    var formulaLabelNode: SKLabelNode!
    var polyFormulaLabel: SKLabelNode!
    var congratulationNode: SKSpriteNode!
    var gotItButtonNode: SKNode?
    var finishGame = false
    
    var tutorialShow = false
    var success = false
    var finishAnimation = false
    var backOrReplay = "back"
    var playerAttempt: [String: Int] = [:]
    // hard coded the polynomial functions
    var polyFunctions = [["x": 1, "x-1": 1, "x-2": 1], ["x-1": 1, "x-2": 1, "x-3": 1, "x-4": 1], ["x": 1, "x+2": 1, "x-3": 2], ["x": 2, "x-1": 1, "x+2": 1], ["x": 3, "x-4": 1], ["x": 1, "x+2": 2, "x+1": 1, "x-1": 1], ["x": 2, "x-1": 1, "x+2": 1, "x+3": 1], ["x-1": 1, "x-2": 1, "x-3": 1, "x+1": 1, "x+2": 1], ["x": 2, "x-2": 2, "x+2": 1], ["x-1": 3, "x+2": 2], ["x": 1, "x+2": 1, "x+1": 1, "x-3": 1, "x-2": 1, "x-1": 1], ["x": 2, "x+2": 2, "x-3": 2], ["x": 2, "x+2": 2, "x-3": 1, "x-2": 1]]
    
    // Chart
    // lineshape for drawing the straight line
    // lineshape1 for drawing the polynomial graph
    // lineshape2 for drawing the scale
    var path = CGMutablePath()
    var path1 = CGMutablePath()
    var path2 = CGMutablePath()
    let shape = SKShapeNode()
    let xCoordinate = SKShapeNode()
    let yCoordinate = SKShapeNode()
    let lineshape = SKShapeNode()
    let lineShape1 = SKShapeNode()
    let lineShape2 = SKShapeNode()
    var currentLocation = CGPoint(x:0,y:0)
    
    //x³ - 3x^2 + 2x   x(x-1)(x-2)       X3
    //x^4-10x^3+35x^2-50x+24 (x-1)(x-2)(x-3)(x-4)      X4
    //x4−4x3−3x2+18x  x(x+2)(x-3)^2
    //x4+x3−2x2     x^2(x-1)(x+2)
    //x4−4x3    x^3(x-4)
    //x5+4x4+3x3−4x2−4x x(x+2)^2(x+1)(x-1)      X5
    //x5+4x4+x3−6x2    x^2(x-1)(x+3)(x+2)
    //x5−3x4−5x3+15x2+4x−12  (x-1)(x-2)(x-3)(x+1)(x+2)
    //x5−2x4−4x3+8x2     x^2(x-2)^2(x+2)
    //x5+x4−5x3−x2+8x−4    (x-1)^3(x+2)^2
    //x6−3x5−5x4+15x3+4x2−12x    x(x+2)(x+1)(x-3)(x-2)(x-1)      X6
    //x6−2x5−11x4+12x3+36x2      x^2(x+2)^2(x-1)^2
    //x6−x5−10x4+4x3+24x2   x^2(x+2)^2(x-3)(x-2)
    
    //hard coded the function parameters and some variables for drawing the function on the screen
    //x^6,x^5,x^4,x^3,x^2,x^1,x^0,a,y-interval, x-interval, x-start, y-start, loopNum, yscale1, yscale2
    var polyArray: [[Double]] = [[0.0, 0.0, 0.0, 1.0, -3.0, 2.0, 0.0, 2.0, 2.0, 40.0, 2.1, 20.0, 50.0, 0.4, -0.4], [0.0, 0.0, 1.0, -10.0, 35.0, -50.0, 24.0, 1.0, 3.0, 50.0, 2.2, -10.0, 60.0, 0.5, -1.0], [0.0, 0.0, 1.0, -4.0, -3.0, 18, 0.0, 4.0, 50.0, 75.0, 2.1, -10.0, 80.0, 10.0, -20.0], [0.0, 0.0, 1.0, 1.0, -2.0, 0.0, 0.0, 4.0, 7.0, 60.0, 2.1, -5.0, 60.0, 1.0, -3.0], [0.0, 0.0, 1.0, -4.0, 0.0, 0.0, 0.0, 3.0, 70.0, 75.0, 2.1, -10.0, 80.0, 20.0, -20.0], [0.0, 1.0, 4.0, 3.0, -4.0, -4.0, 0.0, 4.0, 7.0, 50.0, 2.1, -10.0, 60.0, 1.0, -3.0], [0.0, 1.0, 4.0, 1.0, -6.0, 0.0, 0.0, 5.0, 20.0, 60, 2.1, 20.0, 70, 5.0, -5.0], [0.0, 1.0, -3.0, -5.0, 15.0, 4.0, -12.0, 4.0, 55.0, 70.0, 2.1, -10.0, 80.0, 10.0, -10.0], [0.0, 1.0, -2.0, -4.0, 8.0, 0.0, 0.0, 4.0, 40.0, 60.0, 2.1, 12.0, 70.0, 14.0, 7.0], [0.0, 1.0, 1.0, -5.0, -1.0, 8.0, -4.0, 4.0, 30.0, 52.0, 2.1, -6.0, 70.0, 5.0, -10.0], [1.0, -3.0, -5.0, 15.0, 4.0, -12.0, 0.0, 4.0, 60.0, 70.0, 2.2, -10.0, 80.0, 10.0, -20.0], [1.0, -2.0, -11.0, 12.0, 36.0, 0.0, 0.0, 4.0, 150.0, 70.0, 2.1, 10.0, 80.0, 70.0, 20.0], [1.0, -1.0, -10.0, 4.0, 24.0, 0.0, 0.0, 4.0, 80.0, 70.0, 2.1, -10.0, 80.0, 20.0, -40.0]]

    //randomly choose one polynomial function to draw
    let num = Int.random(in: 0 ... 12)

    var count: Int = 10
    var pause = false
    
    let titleLabel = SKLabelNode()
    //Hearts
    var heartsArray: [SKSpriteNode]!
    //Timer
    let timeCounterLabel = SKLabelNode()
    var timerCount = 0
    var startTime: Double = 0
    var timer = Timer()
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
        // add function roots buttons on the screen
        xButtonNode = childNode(withName: "xButton")
        xButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12, y: -self.frame.size.height/6)
        xp1ButtonNode = childNode(withName: "xp1Button")
        xp1ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12, y: -self.frame.size.height/6 - xp1ButtonNode!.frame.size.height*3/2)
        xp2ButtonNode = childNode(withName: "xp2Button")
        xp2ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12, y: -self.frame.size.height/6 - 2 * xp1ButtonNode!.frame.size.height*3/2)
        xp3ButtonNode = childNode(withName: "xp3Button")
        xp3ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12, y: -self.frame.size.height/6 - 3 * xp1ButtonNode!.frame.size.height*3/2)
        xn1ButtonNode = childNode(withName: "xn1Button")
        xn1ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12 + xn1ButtonNode!.frame.size.width*5/4, y: -self.frame.size.height/6)
        xn2ButtonNode = childNode(withName: "xn2Button")
        xn2ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12 + xn1ButtonNode!.frame.size.width*5/4, y: -self.frame.size.height/6 - xp1ButtonNode!.frame.size.height*3/2)
        xn3ButtonNode = childNode(withName: "xn3Button")
        xn3ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12 + xn1ButtonNode!.frame.size.width*5/4, y: -self.frame.size.height/6 - 2 * xp1ButtonNode!.frame.size.height*3/2)
        xn4ButtonNode = childNode(withName: "xn4Button")
        xn4ButtonNode!.position = CGPoint(x: -self.frame.size.width*5/12 + xn1ButtonNode!.frame.size.width*5/4, y: -self.frame.size.height/6 - 3 * xp1ButtonNode!.frame.size.height*3/2)
        checkButtonNode = childNode(withName: "checkButton")
        checkButtonNode!.position = CGPoint(x: self.frame.size.width*5/12, y: -self.frame.size.height/2 + self.frame.size.width/8)
        checkButtonNode?.zPosition = 4
        clearButtonNode = childNode(withName: "clearButton")
        clearButtonNode!.position = CGPoint(x: self.frame.size.width*5/12, y: -self.frame.size.height/2 + self.frame.size.width/14)
        clearButtonNode?.zPosition = 4
        
        // start position for drawing the function graph
        let xStartPosition = -self.frame.size.width/CGFloat(polyArray[num][10])
        let yZeroPosition = -self.frame.size.height/CGFloat(polyArray[num][11])
            
        playerNodeAd6 = childNode(withName: "playerAd6")
        playerNodeAd6?.setScale(0.9)
        playerNodeAd6?.zPosition = 3
        playerNodeAd6?.position = CGPoint(x: xStartPosition, y: yZeroPosition+10)
        playerNodeAd6?.alpha = 0
        
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
        
        bgNodeAd6 = childNode(withName: "bgAd6")
        bgNodeAd6?.zPosition = -2
        backButtonNode = self.childNode(withName: "backButton")
        backButtonNode?.position = CGPoint(x: self.frame.size.width/25 - self.frame.size.width/2, y: self.frame.size.height/2 - (backButtonNode?.frame.size.height)!/2 - self.frame.size.width/25)
        backButtonNode?.zPosition = 4
        pauseButtonNode = self.childNode(withName: "pauseButton")
        pauseButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/30 - (pauseButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (pauseButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        pauseButtonNode?.zPosition = 4
        
        resumeButtonNode = self.childNode(withName: "resumeButton")
        resumeButtonNode?.position = CGPoint(x: self.frame.size.width/2 - self.frame.size.width/30 - (resumeButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (resumeButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        resumeButtonNode?.zPosition = -3
        
        replayButtonNode = self.childNode(withName: "replayButton")
        replayButtonNode?.position = CGPoint(x: self.frame.size.width/3 - (replayButtonNode?.frame.size.width)!/2, y: self.frame.size.height/2 - (replayButtonNode?.frame.size.height)!/2 - self.frame.size.width/30)
        replayButtonNode?.zPosition = 4
        
        
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
        tutorialTitleNode.position = CGPoint(x: 0, y: self.frame.size.height/8 + 20)
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
        tutorialLabelNode.text = "Your challenge is to make the Roller Coaster showing on the screen. \nAccording to the polynomial function graph, choosing the correct roots of the graph by clicking buttons on the left corner, put them together to make the complete function. Click Check button to check your answer and Clear button to redo. If you find the correct function, your roller coaster will be in motion."
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

        // add the polynomial function equation on the top of the screen
        polyFormulaLabel = self.childNode(withName: "polyFormula") as? SKLabelNode
        polyFormulaLabel.zPosition = 4
        polyFormulaLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/11 - 5)
        polyFormulaLabel.text = ""
        // obtain the function equation from x^6 to x^0
        for i in 0 ... 6 {
            if polyArray[num][i] != 0 {
                if polyFormulaLabel.text == "" {
                    if Int(polyArray[num][i]) == 1 {
                        polyFormulaLabel.text = "Y = X\(6-i)"
                    }
                    else {
                        polyFormulaLabel.text = "Y = \(Int(polyArray[num][i]))X\(6-i)"
                    }
                }
                else {
                    let textString = polyFormulaLabel.text!
                    if i != 6 {
                        if polyArray[num][i] > 0{
                            if Int(polyArray[num][i]) == 1 {
                                if 6 - i == 1 {
                                    polyFormulaLabel.text = "\(textString) + X"
                                }
                                else {
                                    polyFormulaLabel.text = "\(textString) + X\(6-i)"
                                }
                            }
                            else {
                                if 6 - i == 1 {
                                    polyFormulaLabel.text = "\(textString) + \(Int(polyArray[num][i]))X"
                                }
                                else {
                                    polyFormulaLabel.text = "\(textString) + \(Int(polyArray[num][i]))X\(6-i)"
                                }
                            }
                        }
                        if polyArray[num][i] < 0{
                            if Int(polyArray[num][i]) == -1 {
                                if 6 - i == 1 {
                                    polyFormulaLabel.text = "\(textString) - X"
                                }
                                else {
                                    polyFormulaLabel.text = "\(textString) - X\(6-i)"
                                }
                            }
                            else {
                                if 6 - i == 1 {
                                    polyFormulaLabel.text = "\(textString) \(Int(polyArray[num][i]))X"
                                }
                                else {
                                    polyFormulaLabel.text = "\(textString) \(Int(polyArray[num][i]))X\(6-i)"
                                }
                            }
                        }
                    }
                    else{
                        if polyArray[num][i] > 0{
                            polyFormulaLabel.text = "\(textString) + \(Int(polyArray[num][i]))"
                        }
                        if polyArray[num][i] < 0{
                            polyFormulaLabel.text = "\(textString) \(Int(polyArray[num][i]))"
                        }
                    }
                }
            }
        }
        // use NSMutableAttributedString to do the superscript for power, .baselineOffset +15 to move character up as superscript
        let textString = polyFormulaLabel.text!
        print(textString.indices(of: "X"))
        let indexArray: [Int] = textString.indices(of: "X")
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: textString, attributes: [.font: UIFont(name: "Gill Sans", size:30)!])
        for i in 0 ... indexArray.count - 1{
            if (indexArray[i] != textString.count - 1) && (textString[indexArray[i] + 1] != "1"){
                attString.addAttributes([.font:UIFont(name: "Gill Sans", size:22)!,.baselineOffset: 15], range: NSRange(location: indexArray[i]+1,length:1))
            }
        }
        polyFormulaLabel.attributedText = attString
        
        formulaLabelNode = self.childNode(withName: "formulaLabel") as? SKLabelNode
        formulaLabelNode.zPosition = 4
        formulaLabelNode.position = CGPoint(x: 50, y: -self.frame.size.height/2 + self.frame.size.width/11)
        formulaLabelNode.text = "Y = "
        
        
        timeCounterLabel.zPosition = 2
        timeCounterLabel.fontColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        timeCounterLabel.fontSize = 32
        timeCounterLabel.fontName = "AvenirNext-Bold"
        timeCounterLabel.position = CGPoint(x: 0, y: self.frame.size.height/2 - self.frame.size.width/16)
        timeCounterLabel.text = "Time: 00:00:00"
        self.addChild(timeCounterLabel)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        //Y axis
        let xCoordinateDistance = CGFloat((polyArray[num][7] * 10.0 - 10.0)) * self.frame.size.width/CGFloat(polyArray[num][9])
        let arrowY = UIBezierPath()
        arrowY.addArrow6(start: CGPoint(x: xStartPosition + xCoordinateDistance, y: -self.frame.size.height/2), end: CGPoint(x:  xStartPosition + CGFloat(xCoordinateDistance), y: self.frame.size.height/2 - 30), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        yCoordinate.path = arrowY.cgPath
        yCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        yCoordinate.lineWidth = 3
        yCoordinate.zPosition = 4
        self.addChild(yCoordinate)
        //X axis
        let arrowX = UIBezierPath()
        arrowX.addArrow6(start: CGPoint(x: -self.frame.size.width/2, y: yZeroPosition), end: CGPoint(x: self.frame.size.width/2 - 30, y: yZeroPosition), pointerLineLength: 20, arrowAngle: CGFloat(Double.pi / 4))
        xCoordinate.path = arrowX.cgPath
        xCoordinate.strokeColor = UIColor(red:0.99, green:0.55, blue:0.46, alpha:0.6)
        xCoordinate.lineWidth = 3
        xCoordinate.zPosition = 4
        self.addChild(xCoordinate)
        
        
        path1.move(to: CGPoint(x: xStartPosition, y: yZeroPosition))
        currentLocation = CGPoint(x: xStartPosition, y: yZeroPosition)
        lineShape1.zPosition = 2
        lineShape1.strokeColor = UIColor.black
        self.addChild(lineShape1)
        self.addChild(lineShape2)
        self.addChild(lineshape)
        
        let a = polyArray[num][7]
        // temp variable here represent y-interval
        let temp = self.frame.size.height/CGFloat(polyArray[num][8])
        for i in 10 ... Int(polyArray[num][12]){
            //calculate polynomial function
            let part0 = polyArray[num][6] * pow(Double(i)/10.0 - a, Double(0))
            let part1 = polyArray[num][5] * pow(Double(i)/10.0 - a, Double(1))
            let part2 = polyArray[num][4] * pow(Double(i)/10.0 - a, Double(2))
            let part3 = polyArray[num][3] * pow(Double(i)/10.0 - a, Double(3))
            let part4 = polyArray[num][2] * pow(Double(i)/10.0 - a, Double(4))
            let part5 = polyArray[num][1] * pow(Double(i)/10.0 - a, Double(5))
            let part6 = polyArray[num][0] * pow(Double(i)/10.0 - a, Double(6))
            
            let total = part0 + part1 + part2 + part3 + part4 + part5 + part6
            
            // move to the starting position
            if i == 10{
                path1.move(to: CGPoint(x: currentLocation.x, y: yZeroPosition + CGFloat(total) * temp))
            }
            
            //draw straight lines which looks more like roller coaster
            if i % 4 == 0 {
                path.move(to: CGPoint(x: currentLocation.x, y: yZeroPosition + CGFloat(total) * temp))
                
                
                path.addLine(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/2))
                path.move(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/2))
                
                lineshape.path = path
                lineshape.strokeColor = UIColor.black
                lineshape.alpha = 0.7
                lineshape.lineWidth = 2
                lineshape.zPosition = 2
            }
            
            // draw polynomial function graph
            path1.addLine(to: CGPoint(x: currentLocation.x, y: yZeroPosition + CGFloat(total) * temp))
            path1.move(to: CGPoint(x: currentLocation.x, y: yZeroPosition + CGFloat(total) * temp))
            currentLocation.x = currentLocation.x + self.frame.size.width/CGFloat(polyArray[num][9])
            
            lineShape1.path = path1
            lineShape1.strokeColor = UIColor.black
            lineShape1.lineWidth = 3
            
            // draw xscale
            if i%10 == 0{
                let scaleNumber = i/10 - Int(a)
                path2.move(to: CGPoint(x: xStartPosition + CGFloat(i-10) * self.frame.size.width/CGFloat(polyArray[num][9]), y: yZeroPosition))
                path2.addLine(to: CGPoint(x: xStartPosition + CGFloat(i-10) * self.frame.size.width/CGFloat(polyArray[num][9]), y: yZeroPosition+15))
                lineShape2.path = path2
                lineShape2.strokeColor = UIColor.red
                lineShape2.zPosition = 3
                lineShape2.lineWidth = 3
                let scaleLabel = SKLabelNode()
                scaleLabel.position = CGPoint(x: xStartPosition + CGFloat(i-10) * self.frame.size.width/CGFloat(polyArray[num][9]), y: yZeroPosition - 25)
                scaleLabel.text = "\(scaleNumber)"
                scaleLabel.fontSize = 20
                scaleLabel.fontName = "Arial-Bold"
                scaleLabel.fontColor = UIColor.red
                print("xScale\(i/10)")
                scaleLabel.name = "xScale\(i/10)"
                scaleLabel.zPosition = 3
                self.addChild(scaleLabel)
            }
        }
        // draw yscale
        for i in  1 ... 2{
            path2.move(to: CGPoint(x: xStartPosition + xCoordinateDistance, y: yZeroPosition + CGFloat(polyArray[num][i+12]) * temp))
            path2.addLine(to: CGPoint(x: xStartPosition + xCoordinateDistance + 15, y: yZeroPosition + CGFloat(polyArray[num][i+12]) * temp))
            lineShape2.path = path2
            lineShape2.strokeColor = UIColor.red
            lineShape2.zPosition = 3
            lineShape2.lineWidth = 3
            let scaleLabel = SKLabelNode()
            scaleLabel.position = CGPoint(x: xStartPosition + xCoordinateDistance - 25, y: yZeroPosition + CGFloat(polyArray[num][i+12]) * temp)
            scaleLabel.text = "\(polyArray[num][i+12])"
            scaleLabel.fontSize = 20
            scaleLabel.fontName = "Arial-Bold"
            scaleLabel.fontColor = UIColor.red
            print("yScale\(i)")
            scaleLabel.name = "yScale\(i)"
            scaleLabel.zPosition = 3
            self.addChild(scaleLabel)
        }
        
        currentLocation = CGPoint(x: xStartPosition, y: -self.frame.size.height/CGFloat(polyArray[num][11]))
        
        fillHearts(count: 3)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let a = polyArray[num][7]
        
        // if user successully find the function
        if success == true {
            //remove x,y coordinate, scale and scale label
            yCoordinate.removeFromParent()
            xCoordinate.removeFromParent()
            path2 = CGMutablePath()
            lineShape2.path = path2
            for i in 10 ... Int(polyArray[num][12]){
                if i % 10 == 0 {
                    (self.childNode(withName: "xScale\(i/10)") as! SKLabelNode).text = ""
                }
            }
            for j in 1 ... 2 {
                (self.childNode(withName: "yScale\(j)") as! SKLabelNode).text = ""
            }
            xButtonNode?.zPosition = -3
            xp1ButtonNode?.zPosition = -3
            xp2ButtonNode?.zPosition = -3
            xp3ButtonNode?.zPosition = -3
            xn1ButtonNode?.zPosition = -3
            xn2ButtonNode?.zPosition = -3
            xn3ButtonNode?.zPosition = -3
            xn4ButtonNode?.zPosition = -3
            checkButtonNode?.zPosition = -3
            clearButtonNode?.zPosition = -3
            formulaLabelNode.text = ""
            
            
            //show the roller coaster animation with playerNode
            if count >= 10 && count <= Int(polyArray[num][12]) * 10{
                if count % 10 == 0{
                    let counter = 10 + (count-10)/10
                    let part0 = polyArray[num][6] * pow(Double(counter)/10.0 - a, Double(0))
                    let part1 = polyArray[num][5] * pow(Double(counter)/10.0 - a, Double(1))
                    let part2 = polyArray[num][4] * pow(Double(counter)/10.0 - a, Double(2))
                    let part3 = polyArray[num][3] * pow(Double(counter)/10.0 - a, Double(3))
                    let part4 = polyArray[num][2] * pow(Double(counter)/10.0 - a, Double(4))
                    let part5 = polyArray[num][1] * pow(Double(counter)/10.0 - a, Double(5))
                    let part6 = polyArray[num][0] * pow(Double(counter)/10.0 - a, Double(6))
                    let temp = self.frame.size.height/CGFloat(polyArray[num][8])
                    
                    let total = part0 + part1 + part2 + part3 + part4 + part5 + part6
                    
                    let action = SKAction.move(to: CGPoint(x: currentLocation.x, y:  -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp + 10), duration: 0.25)
                    
                    currentLocation = CGPoint(x: currentLocation.x + self.frame.size.width/CGFloat(polyArray[num][9]), y: -self.frame.size.height/CGFloat(polyArray[num][11]) + CGFloat(total) * temp + 10)
                    
                    playerNodeAd6?.run(action)
                    playerNodeAd6?.alpha = 1
                }
                    
                if count == Int(polyArray[num][12]) * 10 {
                    finishAnimation = true
                    let data = applicationDelegate.levelRecordDictionary["level6"] as! NSDictionary
                    var gameData = data as! Dictionary<String, Int>
                    
                    // update highest star for level 6
                    if self.heartsArray.count > gameData["highestStar"]! {
                        gameData["highestStar"] = self.heartsArray.count
                    }
                    // update time counter for level 6
                    if self.timerCount < gameData["timeCount"]! {
                        gameData["timeCount"] = self.timerCount
                    }
                    // update badge, set 1 for obtain the badge and show obtained badge on the pop up congratulation window
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
                    if self.timerCount <= 40 {
                        gameData["expertBadge"] = 1
                        let expertBadgeNode = SKSpriteNode(texture: SKTexture(imageNamed: "expertBadge"))
                        expertBadgeNode.setScale(0.8)
                        expertBadgeNode.position = CGPoint(x: congratulationNode!.frame.size.width/3, y: -congratulationNode!.frame.size.height/3)
                        expertBadgeNode.name = "badge2"
                        expertBadgeNode.zPosition = 4
                        addChild(expertBadgeNode)
                    }
                    
                    applicationDelegate.levelRecordDictionary.setValue(gameData, forKey: "level6")
                    
                    finishGame = true
                    congratulationNode.texture = SKTexture(imageNamed: "congratulationSign\(self.heartsArray.count)")
                    congratulationNode?.zPosition = 3
                    gotItButtonNode?.zPosition = 4
                }
                count = count + 1
//                let gameSuccessScene = GameSuccessScene(fileNamed: "GameSuccessScene")
//                gameSuccessScene?.scaleMode = .aspectFill
//                gameSuccessScene!.performanceLevel = self.heartsArray.count
//                gameSuccessScene!.level = 6
//                self.view?.presentScene(gameSuccessScene!)
            }
        }
    }
}

// Mark: touch functions
extension AdventureScene6{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            // if user click the function root button, append text on formula label
            if nodesArray.first?.name == "xButton"{
                if pause == false{
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) x"
                    if playerAttempt["x"] == nil {
                        playerAttempt["x"] = 1
                    }
                    else {
                        var num = playerAttempt["x"]!
                        num = num + 1
                        playerAttempt["x"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xp1Button"{
                if pause == false {
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x+1)"
                    if playerAttempt["x+1"] == nil {
                        playerAttempt["x+1"] = 1
                    }
                    else {
                        var num = playerAttempt["x+1"]!
                        num = num + 1
                        playerAttempt["x+1"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xp2Button"{
                if pause == false{
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x+2)"
                    if playerAttempt["x+2"] == nil {
                        playerAttempt["x+2"] = 1
                    }
                    else {
                        var num = playerAttempt["x+2"]!
                        num = num + 1
                        playerAttempt["x+2"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xp3Button"{
                if pause == false {
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x+3)"
                    if playerAttempt["x+3"] == nil {
                        playerAttempt["x+3"] = 1
                    }
                    else {
                        var num = playerAttempt["x+3"]!
                        num = num + 1
                        playerAttempt["x+3"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xn1Button"{
                if pause == false {
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x-1)"
                    if playerAttempt["x-1"] == nil {
                        playerAttempt["x-1"] = 1
                    }
                    else {
                        var num = playerAttempt["x-1"]!
                        num = num + 1
                        playerAttempt["x-1"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xn2Button"{
                if pause == false {
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x-2)"
                    if playerAttempt["x-2"] == nil {
                        playerAttempt["x-2"] = 1
                    }
                    else {
                        var num = playerAttempt["x-2"]!
                        num = num + 1
                        playerAttempt["x-2"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xn3Button"{
                if pause == false{
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x-3)"
                    if playerAttempt["x-3"] == nil {
                        playerAttempt["x-3"] = 1
                    }
                    else {
                        var num = playerAttempt["x-3"]!
                        num = num + 1
                        playerAttempt["x-3"] = num
                    }
                    print(playerAttempt)
                }
            }
            if nodesArray.first?.name == "xn4Button"{
                if pause == false{
                    let formulaString = formulaLabelNode.text!
                    formulaLabelNode.text = "\(formulaString) (x-4)"
                    if playerAttempt["x-4"] == nil {
                        playerAttempt["x-4"] = 1
                    }
                    else {
                        var num = playerAttempt["x-4"]!
                        num = num + 1
                        playerAttempt["x-4"] = num
                    }
                    print(playerAttempt)
                }
            }
            // clear button to clear all the function root
            if nodesArray.first?.name == "clearButton"{
                // clear formula
                if pause == false {
                    formulaLabelNode.text = "Y = "
                    playerAttempt.removeAll()
                }
            }
            
            if nodesArray.first?.name == "checkButton"{
                // check if formula correct
                if pause == false {
                    if polyFunctions[num].count == playerAttempt.count {
                        for keyString in polyFunctions[num].keys {
                            if playerAttempt[keyString] == nil {
                                //lose heart if user misses the correct root button
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
                                delay(1.0){
                                    self.formulaLabelNode.text = "Y = "
                                    self.playerAttempt.removeAll()
                                }
                                return
                            }
                            if playerAttempt[keyString] != polyFunctions[num][keyString] {
                                //lose heart if user clicks the wrong root button
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
                                delay(1.0){
                                    self.formulaLabelNode.text = "Y = "
                                    self.playerAttempt.removeAll()
                                }
                                return
                            }
                        }
                        //sucess
                        success = true
                        run(Sound.applaud.action)
                        path2 = CGMutablePath()
                        lineShape2.path = path2
                        xButtonNode!.alpha = 0
                        xp1ButtonNode!.alpha = 0
                        xp2ButtonNode!.alpha = 0
                        xp3ButtonNode!.alpha = 0
                        xn1ButtonNode!.alpha = 0
                        xn2ButtonNode!.alpha = 0
                        xn3ButtonNode!.alpha = 0
                        xn4ButtonNode!.alpha = 0
//                        xCoordinate.removeFromParent()
//                        yCoordinate.removeFromParent()
                        checkButtonNode!.alpha = 0
                        clearButtonNode!.alpha = 0
                        formulaLabelNode.text = ""
                    }
                    else{
                        //lose heart if the root numbers is not the same as the target function
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
                        delay(1.0){
                            self.formulaLabelNode.text = "Y = "
                            self.playerAttempt.removeAll()
                        }
                        return
                    }
                }
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
                    let adventureScene6 = AdventureScene6(fileNamed: "AdventureScene6")
                    adventureScene6?.scaleMode = .aspectFill
                    self.view?.presentScene(adventureScene6!)
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
                    resumeButtonNode?.zPosition = 4
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
                    pauseButtonNode?.zPosition = 4
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
                // click gotItButton, the congratulationNode, gotItButtonNode, badges disappear. replayButton, backButton keep flashing to remind player to make decision
                congratulationNode!.zPosition = -3
                gotItButtonNode?.zPosition = -3
                (self.childNode(withName: "badge1") as! SKSpriteNode).removeFromParent()
                if self.timerCount <= 40{
                    (self.childNode(withName: "badge2") as! SKSpriteNode).removeFromParent()
                }
            }
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
        gameOverScene!.level = 6
        self.view?.presentScene(gameOverScene!)
    }
    
    // delay function to execute after certain time
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    @objc func updateTimer() {
        
        // Calculate total time since timer started in seconds
        //        var currentTime = Date().timeIntervalSinceReferenceDate - startTime
        if success == true {return}
        if pause == false && finishGame == false{
            timerCount += 1
            // Calculate minutes
            let timeString = String(format: "%02d:%02d:%02d", timerCount/3600, (timerCount/60)%60, timerCount%60)
            timeCounterLabel.text = "Time: \(timeString)"
        }
    }
}



extension UIBezierPath {
    func addArrow6(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
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

// additional helper function for String class
extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}
