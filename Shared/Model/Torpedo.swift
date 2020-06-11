//
//  Torpedo.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class Torpedo: ObservableObject {
    
    #if os(macOS)
    lazy var appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif

    
    var torpedoId: Int = 0
    @Published var status: UInt8 = 0
    //0 = inactive, 1=active, 2 = exploding?
    
    //public var displayed: Bool = false
    private(set) var war: [Team:Bool] = [:]
    var directionNetrek: Int = 0  // netrek format direction for now
    var direction: Double = 0.0 // in radians
    @Published var positionX: Int = 0
    @Published var positionY: Int = 0
    @Published var color: Color = Color.red

    public func reset() {
        self.positionX = 0
        self.positionY = 0
        self.status = 0
    }

    private var soundPlayed = false
    /*var torpedoNode = SKSpriteNode(color: .red,
                                   size: CGSize(width: NetrekMath.torpedoSize, height: NetrekMath.torpedoSize))*/

    init(torpedoId: Int) {
        self.torpedoId = torpedoId
    }
    func update(war: UInt8, status: UInt8) {
        DispatchQueue.main.async {
            for team in Team.allCases {
                if UInt8(team.rawValue) & war != 0 {
                    self.war[team] = true
                } else {
                    self.war[team] = false
                }
            }
            let myTeam = self.appDelegate.universe.players[self.appDelegate.universe.me].team
            //DispatchQueue.main.async {
                if self.war[myTeam] == true {
                    self.color = Color.red
                } else {
                    self.color = Color.green
                }
                self.status = status
            //}
            if status == 1 {
                self.soundPlayed = false
            }
        }
    }
    func update(directionNetrek: Int, positionX: Int, positionY: Int) {
        if self.status == 0 {
            return
        }
        DispatchQueue.main.async {
            self.positionX = positionX
            self.positionY = positionY
        }
        if soundPlayed == false {
            let me = appDelegate.universe.players[appDelegate.universe.me]
            let taxiDistance = abs(me.positionX - self.positionX) + abs(me.positionY - self.positionY)
            if taxiDistance < NetrekMath.displayDistance / 4 {
                let volume = 1.0 - (4.0 * Float(taxiDistance) / (NetrekMath.displayDistanceFloat))
                
                appDelegate.soundController?.play(sound: .torpedo, volume: volume)
                debugPrint("playing torpedo sound volume \(volume)")
                soundPlayed = true
            }
        }
    }
}
