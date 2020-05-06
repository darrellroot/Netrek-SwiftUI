//
//  PlayerStatus.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

enum PlayerStatus: UInt32 {
    case shield = 0x0001
    case repair = 0x0002
    case bomb = 0x0004
    case orbit = 0x0008
    case cloak = 0x0010
    case weaponTemp = 0x0020
    case engineTemp = 0x0040
    case robot = 0x0080
    case beamup = 0x0100
    case beamdown = 0x0200
    case selfDestruct = 0x0400
    case greenAlert = 0x0800
    case yellowAlert = 0x1000
    case redAlert = 0x2000
    case playerLock = 0x4000
    case planetLock = 0x8000
    case coPilot = 0x10000 // not displayed
    case war = 0x20000
    case practiceRobot = 0x40000
    case dock = 0x80000
    case refit = 0x100000 // not displayed
    case refitting = 0x200000
    case tractor = 0x400000
    case pressor = 0x800000
    case dockOk = 0x1000000
    case seen = 0x2000000
    case observe = 0x8000000
    case transWarp = 0x40000000 // paradise mode
    case bpRobot = 0x80000000
}
