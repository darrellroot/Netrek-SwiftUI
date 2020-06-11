//
//  GameScreen.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

//Whenever gameState changes, gameScreen matches
//But we can manually change gameScreen to go to help or credits without changing gameState

enum GameScreen: String, CaseIterable {
    case noServerSelected
    case serverSelected
    case serverConnected
    case serverSlotFound
    case loginAccepted
    case gameActive
    case howToPlay
    case credits
}
