//
//  MessagesController.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation
import SwiftUI

class MessagesController {
    #if os(macOS)
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif
    
    var universe: Universe
    
    init(universe: Universe) {
        self.universe = universe
    }
    
    func sendMayday() {
        guard appDelegate.gameState == .gameActive else { return }
        let me = appDelegate.universe.players[appDelegate.universe.me]
        let (planetOptional,_) = findClosestPlanet(location: CGPoint(x: me.positionX,y: me.positionY))
        guard let planet = planetOptional else { return }

        let message = "MAYDAY near \(planet.name) shields \(me.shieldStrength) damage \(me.damage) armies \(me.armies)"
        self.sendMessage(message: message, sendToAll: false)
    }
    func sendEscort() {
        guard appDelegate.gameState == .gameActive else { return }
        let me = appDelegate.universe.players[appDelegate.universe.me]
        let (planetOptional,_) = findClosestPlanet(location: CGPoint(x: me.positionX,y: me.positionY))
        guard let planet = planetOptional else { return }

        let message = "Request Escort near \(planet.name) shields \(me.shieldStrength) damage \(me.damage) armies \(me.armies)"
        self.sendMessage(message: message, sendToAll: false)
    }

    func sendMessage(message: String) {
        self.sendMessage(message: message, sendToAll: false)
    }
    func sendMessage(message: String, sendToAll: Bool) {
        if message == "" {
            return
        }
        if sendToAll {
            let data = MakePacket.cpMessage(message: message, team: .independent, individual: 0)
            self.appDelegate.reader?.send(content: data)
        } else {
            let data = MakePacket.cpMessage(message: message, team: self.universe.players[self.universe.me].team, individual: 0)
            self.appDelegate.reader?.send(content: data)
        }
    }
    private func findClosestPlanet(location: CGPoint) -> (planet: Planet?,distance: Int) {
        var closestPlanetDistance = 10000
        var closestPlanet: Planet?
        for planet in appDelegate.universe.planets {
            let thisPlanetDistance = abs(planet.positionX - Int(location.x)) + abs(planet.positionY - Int(location.y))
            if thisPlanetDistance < closestPlanetDistance {
                closestPlanetDistance = thisPlanetDistance
                closestPlanet = planet
            }
        }
        return (closestPlanet,closestPlanetDistance)
    }

}
