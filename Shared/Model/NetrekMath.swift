//
//  NetrekMath.swift
//  Netrek
//
//  Created by Darrell Root on 3/7/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#endif
import SwiftUI

class NetrekMath {

    #if os(macOS)
    static let displayDistance = 3000
    #elseif os(iOS)
    static let displayDistance = 1500
    #endif
    
    static let visualDisplayDistance = 6 * NetrekMath.displayDistance / 10
    
    static let displayDistanceFloat: Float = Float(displayDistance)

    static let galacticSize = 10000

    static let actionThreshold = 100
    static let planetDiameter = 112
    static let planetFontSize: CGFloat = 80.0
    static let hintFontSize: CGFloat = 200.0
    static let playerSize = 80
    static let torpedoSize = 10
    static let plasmaSize = 25
    #if os(macOS)
    static let appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif


    
    // size = 112 / 3000 * width
    
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
            return answer + 2.0 * Double.pi
        }
    }
    
    //angleDiff is used in netrek-server-swift but we put the tests in netrek client because we dont know how to test in swift package manager yet.  sorry
    static func angleDiff(_ angle1: Double, _ angle2: Double) -> Double {
        //returns diff between two angles, including dealing with 2*pi case
        // inputs must be between 0 and 2*Pi
        switch angle1 - angle2 {
        case 0:
            return 0.0
        case 0 ..< Double.pi:
            return angle1 - angle2
        case -Double.pi ..< 0:
            return angle1 - angle2
        case Double.pi...:
            return Double.pi - (angle1 - (angle2 + Double.pi))
        case ...Double.pi:
            return Double.pi * 2 + angle2 - angle1
        default:
            // should not get here
            return 0.0
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
    static func playerLetter(playerId: Int) -> String {
        let playerLetter: String
        if playerId < 16 {
            playerLetter = String(format: "%x", playerId)
        } else {
            switch playerId {
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
    static public func color(team: Team) -> Color {
        switch team {
            
        case .independent:
            return Color.gray
        case .federation:
            return Color.yellow
        case .roman:
            return Color.red
        case .kazari:
            return Color.green
        case .orion:
            return Color.blue
        case .ogg:
            return Color.gray
        }
    }
}
