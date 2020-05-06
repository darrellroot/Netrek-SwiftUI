//
//  Plasma.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Plasma {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    private(set) var plasmaID = 0
    private(set) var status = 0
    private(set) var war: [Team:Bool] = [:]
    private(set) var directionNetrek = 0
    private(set) var direction = 0.0
    private(set) var positionX = 0
    private(set) var positionY = 0
    private var soundPlayed = false
    var plasmaNode = SKSpriteNode(color: .orange,
                                   size: CGSize(width: NetrekMath.torpedoSize * 2, height: NetrekMath.torpedoSize * 2))

    //from SP_PLASMA_INFO 8
    public func update(plasmaID: Int, war: UInt8, status: Int) {
        self.plasmaID = plasmaID
        for team in Team.allCases {
            if UInt8(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }
        self.status = status
        if status == 1 {
            soundPlayed = false
        }
    }
    // from SP_PLASMA 9
    func update(positionX: Int, positionY: Int) {
        self.positionX = positionX
        self.positionY = positionY
        if soundPlayed == false {
            if let me = appDelegate.universe.me {
                let taxiDistance = abs(me.positionX - self.positionX) + abs(me.positionY - self.positionY)
                if taxiDistance < NetrekMath.displayDistance / 3 {
                    let volume = 1.0 - (3.0 * Float(taxiDistance) / (NetrekMath.displayDistanceFloat))
                    appDelegate.soundController?.play(sound: .plasma, volume: volume)
                    debugPrint("playing plasma sound volume \(volume)")
                    soundPlayed = true
                }
            }
        }
    }
}
