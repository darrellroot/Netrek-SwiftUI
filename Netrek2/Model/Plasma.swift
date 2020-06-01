//
//  Plasma.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

class Plasma: ObservableObject {
    lazy var appDelegate = NSApplication.shared.delegate as! AppDelegate

    private(set) var plasmaId: Int
    @Published private(set) var status = 0
    private(set) var war: [Team:Bool] = [:]
    private(set) var directionNetrek = 0
    private(set) var direction = 0.0
    @Published private(set) var positionX = 0
    @Published private(set) var positionY = 0
    @Published var color: Color = Color.red

    private var soundPlayed = false
    /*var plasmaNode = SKSpriteNode(color: .orange,
                                   size: CGSize(width: NetrekMath.torpedoSize * 2, height: NetrekMath.torpedoSize * 2))*/

    init(plasmaId: Int) {
        self.plasmaId = plasmaId
    }
    public func reset() {
        self.positionX = 0
        self.positionY = 0
        self.status = 0
    }

    //from SP_PLASMA_INFO 8
    public func update(plasmaId: Int, war: UInt8, status: Int) {
        self.plasmaId = plasmaId
        for team in Team.allCases {
            if UInt8(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }
        let myTeam = appDelegate.universe.players[appDelegate.universe.me].team
        DispatchQueue.main.async {
            if self.war[myTeam] == true {
                self.color = Color.red
            } else {
                self.color = Color.green
            }
            self.status = status
        }
        if status == 1 {
            soundPlayed = false
        }
    }
    // from SP_PLASMA 9
    func update(positionX: Int, positionY: Int) {
        DispatchQueue.main.async {
            self.positionX = positionX
            self.positionY = positionY
        }
        if soundPlayed == false {
            let me = appDelegate.universe.me
            let taxiDistance = abs(appDelegate.universe.players[me].positionX - self.positionX) + abs(appDelegate.universe.players[me].positionY - self.positionY)
            if taxiDistance < NetrekMath.displayDistance / 3 {
                let volume = 1.0 - (3.0 * Float(taxiDistance) / (NetrekMath.displayDistanceFloat))
                appDelegate.soundController?.play(sound: .plasma, volume: volume)
                debugPrint("playing plasma sound volume \(volume)")
                soundPlayed = true
            }
        }
    }
}
