//
//  Sound.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 12/2/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import Foundation
import SpriteKit

enum Sound : String{
    case hit, jump, meteorFalling, reward
    var action : SKAction{
        return SKAction.playSoundFileNamed(rawValue + "Sound.wav", waitForCompletion: false)
    }
}

extension SKAction{
    static let playGameMusic: SKAction = repeatForever(playSoundFileNamed("music.wav", waitForCompletion: false))
}
