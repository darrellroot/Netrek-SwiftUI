//
//  NetrekMath.swift
//  Netrek
//
//  Created by Darrell Root on 3/7/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit
class NetrekMath {
    
    static let displayDistance = 3000
    static let displayDistanceFloat: Float = 3000.0
    static let galacticSize = 10000
    static let actionThreshold = 100
    static let planetDiameter = 112
    static let planetFontSize: CGFloat = 80.0
    static let hintFontSize: CGFloat = 200.0
    static let playerSize = 80
    static let torpedoSize = 10
    static let appDelegate = NSApplication.shared.delegate as! AppDelegate

    static func sanitizeString(_ input: String) -> String {
        var outputString = input.replacingOccurrences(of: "Romulus", with: "Rome")
        outputString = outputString.replacingOccurrences(of: "Klingus", with: "Kazari")
        outputString = outputString.replacingOccurrences(of: "Praxis", with: "Prague")
        outputString = outputString.replacingOccurrences(of: "phaser", with: "laser")
        outputString = outputString.replacingOccurrences(of: "Phaser", with: "Laser")
        outputString = outputString.replacingOccurrences(of: "KLI", with: "KAZ")


        return outputString
    }
    static func directionNetrek2radian(_ directionNetrek: UInt8) -> Double {
        let answer = Double.pi * ((Double(directionNetrek) / -128.0) + 0.5)
        if answer > 0 {
            return answer
        } else {
            return answer - 2.0 * Double.pi
        }
    }
    static func directionNetrek2radian(_ directionNetrek: UInt8) -> CGFloat {
        let answer = CGFloat(Double.pi * ((Double(directionNetrek) / -128.0) + 0.5))
        if answer > 0 {
            return answer
        } else {
            return answer - 2.0 * CGFloat.pi
        }
    }

    static func netrekY2GameY(_ netrekY: Int) -> Int {
        return ( 100000 - netrekY) / 10
    }
    static func netrekX2GameX(_ netrekX: Int) -> Int {
        return netrekX / 10
    }
    static func calculateNetrekDirection(mePositionX: Double, mePositionY: Double, destinationX: Double, destinationY: Double) -> UInt8 {
        let deltaX = Double(destinationX - mePositionX)
        let deltaY = Double(destinationY - mePositionY)
        var angleRadians = atan2(deltaY,deltaX)
        if angleRadians < 0 { angleRadians = angleRadians + Double.pi + Double.pi }
        let netrekDirection = Int(64.0 - 128.0 * angleRadians / Double.pi)
        if netrekDirection >= 0 {
            return(UInt8(netrekDirection))
        } else {
            return(UInt8(netrekDirection + 256))
        }
    }
    static func teamLetter(team: Team) -> String {
        switch team {
            
        case .independent:
            return "I"
        case .federation:
            return "F"
        case .roman:
            return "R"
        case .kazari:
            return "K"
        case .orion:
            return "O"
        case .ogg:
            return "I"
        }
    }
    static func playerLetter(playerID: Int) -> String {
        let playerLetter: String
        if playerID < 16 {
            playerLetter = String(format: "%x", playerID)
        } else {
            switch playerID {
            case 16:
                playerLetter = "g"
            case 17:
                playerLetter = "h"
            case 18:
                playerLetter = "i"
            case 19:
                playerLetter = "j"
            case 20:
                playerLetter = "k"
            case 21:
                playerLetter = "l"
            case 22:
                playerLetter = "m"
            case 23:
                playerLetter = "n"
            case 24:
                playerLetter = "o"
            case 25:
                playerLetter = "p"
            case 26:
                playerLetter = "q"
            case 27:
                playerLetter = "r"
            case 28:
                playerLetter = "s"
            case 29:
                playerLetter = "t"
            case 30:
                playerLetter = "u"
            case 31:
                playerLetter = "v"
            default:
                playerLetter = "?"
            }
        }
        return playerLetter
    }
    static public func color(team: Team) -> NSColor {
        switch team {
            
        case .independent:
            return NSColor.gray
        case .federation:
            return NSColor.yellow
        case .roman:
            return NSColor.red
        case .kazari:
            return NSColor.green
        case .orion:
            return NSColor.blue
        case .ogg:
            return NSColor.gray
        }
        
    }
}
