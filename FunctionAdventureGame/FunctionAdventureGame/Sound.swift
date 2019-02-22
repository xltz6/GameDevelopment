//
//  Sound.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 12/2/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import Foundation
import SpriteKit

// declare an enum Sound and define each case
enum Sound : String{
    case hit, jump, meteorFalling, reward, applaud, levelUp
    var action : SKAction{
        return SKAction.playSoundFileNamed(rawValue + "Sound.wav", waitForCompletion: false)
    }
}

extension SKAction{
    // menu scene background music
    static let playGameMusic: SKAction = repeatForever(playSoundFileNamed("music.wav", waitForCompletion: false))
}
