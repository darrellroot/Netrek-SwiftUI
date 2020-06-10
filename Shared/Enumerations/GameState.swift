//
//  GameState.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

enum GameState: String, CaseIterable {
    case noServerSelected
    case serverSelected
    case serverConnected
    case serverSlotFound
    case loginAccepted
    case gameActive
}
