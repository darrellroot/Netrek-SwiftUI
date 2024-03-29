//
//  Universe.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SwiftUI

class Universe: ObservableObject {
    static var universe = Universe()
    
    var players: [Player] = []
    

    let defaultVisualWidth: CGFloat = 3000
    @Published var visualWidth: CGFloat = 3000 // 30% of galactic size 10000.  Netrek size 100,000
    @Published var waitQueue = 0
    
    var seconds = UpdateCounter(name: "Seconds")
    var serverUpdate = UpdateCounter(name: "ServerUpdate")

    //let device = UIDevice.current.userInterfaceIdiom
    
    var activePlayers: [Player] {
        return players.filter({$0.slotStatus != .free && $0.slotStatus != .observe} )
    }
    var allPlayers: [Player] {
        return players.filter({$0.slotStatus == .alive || $0.slotStatus == .outfit })
    }

    var federationPlayers: Int {
        return players.filter({$0.slotStatus != .free && $0.slotStatus != .observe && $0.team == .federation}).count
    }
    var romanPlayers: Int {
        return players.filter({$0.slotStatus != .free && $0.slotStatus != .observe && $0.team == .roman}).count
    }
    var kazariPlayers: Int {
        return players.filter({$0.slotStatus != .free && $0.slotStatus != .observe && $0.team == .kazari}).count
    }
    var orionPlayers: Int {
        return players.filter({$0.slotStatus != .free && $0.slotStatus != .observe && $0.team == .orion}).count
    }

    @Published var selectionError = ""

    
    var visibleTractors: [Player] {
        guard players[me].slotStatus == .alive && players[me].tractor >= 64 && players[me].tractor < 96 else {
            return []
        }
        let targetId = players[me].tractor - 64
        guard let target = players[safe: targetId] else {
            return []
        }
        guard target.slotStatus == .alive, (abs(target.positionX - players[me].positionX) < NetrekMath.visualDisplayDistance) && abs(target.positionY - players[me].positionY) < NetrekMath.visualDisplayDistance else {
            return []
        }
        return [target]
    }
    var alivePlayers: [Player] {
        return players.filter({ $0.slotStatus == .alive})
    }
    var explodingPlayers: [Player] {
        return players.filter({$0.slotStatus == .explode} )
    }
    var visiblePlayers: [Player] {
        return alivePlayers.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) < Int(visualWidth / 2) })
    }
    
    //converse of visible players
    //for iPad strategic display
    var strategicPlayers: [Player] {
        //return alivePlayers
        return alivePlayers.filter({(abs($0.positionX - players[me].positionX) >= Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) >= Int(visualWidth / 2)})
    }
    
    var visibleFriendlyPlayers: [Player] {
        return alivePlayers.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) < Int(visualWidth / 2) && $0.team == players[me].team })
    }

    var visibleEnemyPlayers: [Player] {
        return alivePlayers.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) < Int(visualWidth / 2) && $0.team != players[me].team })
    }

    
    
    var planets: [Planet] = []
    
    var visiblePlanets: [Planet] {
        return planets.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth) / 2) && abs($0.positionY - players[me].positionY) < Int(visualWidth) / 2 })
    }
    
    var torpedoes: [Torpedo] = []
    var activeTorpedoes: [Torpedo] {
        return torpedoes.filter({$0.status == 1 } )
    }
    var explodingTorpedoes: [Torpedo] {
        return torpedoes.filter({$0.status == 2 || $0.status == 3 } )
    }

    
    var visibleTorpedoes: [Torpedo] {
        return activeTorpedoes.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) < Int(visualWidth / 2) })
    }
    
    var lasers: [Laser] = []
    var activeLasers: [Laser] {
        return lasers.filter({$0.status != 0 } )
    }
    var visibleLasers: [Laser] {
        return activeLasers.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) < Int(visualWidth / 2) })
    }
    
    var plasmas: [Plasma] = []
    var activePlasmas: [Plasma] {
        return plasmas.filter({$0.status != 0 } )
    }
    var explodingPlasmas: [Plasma] {
        return plasmas.filter({$0.status == 2 || $0.status == 3 } )
    }

    var visiblePlasmas: [Plasma] {
        return activePlasmas.filter({(abs($0.positionX - players[me].positionX) < Int(visualWidth / 2)) && abs($0.positionY - players[me].positionY) < Int(visualWidth / 2) })
    }

    var shipInfo: [ShipType:ShipInfo] = [:]
    @Published var me: Int = 0 {
        didSet {
            debugPrint("me set \(me)")
        }
    }
    let maxPlanets = 40
    let maxPlayers = 32
    let maxTorpedoes = 32 * 8
    let maxLasers = 32
    let maxPlasma = 32
    
    @Published private(set) var messages: [String] = []
    
    var activeMessages: ArraySlice<String> {
        let messagesToDisplay = 20
        if messages.count >= messagesToDisplay {
            return messages[messages.count - messagesToDisplay ..< messages.count]
        } else {
            return messages[0 ..< messages.count]
        }
    }
    
    //most recent 15 messages
    @Published var recentMessages: [String] = [] {
        didSet {
            debugPrint("recent MESSAGE set")
        }
    }
    /*var recentMessages: [String] {
        if messages.count >= 10 {
            return Array(messages[messages.count - 10 ..< messages.count])
        } else {
            return Array(messages[0 ..< messages.count])
        }
    }*/

    var lastMessage: String {
        return self.messages.last ?? ""
    }
    func gotMessage(_ newMessage: String) {
        DispatchQueue.main.async {
            self.messages.append(newMessage)
            self.recentMessages.append(newMessage)
            if self.recentMessages.count > 15 {
                self.recentMessages.remove(at: 0)
            }
            
            //only test strings for outfit errors if im not alive
            //saves cpu
            guard self.players[self.me].slotStatus != .alive else {
                return
            }
            if newMessage == "I cannot allow that.  Pick another team\n" {
                self.selectionError = newMessage
            }
            if newMessage == "Please confirm change of teams.  Select the new team again.\n" {
                self.selectionError = newMessage
            }
            if newMessage == "That is an illegal ship type.  Try again.\n" {
                self.selectionError = newMessage
            }
            if newMessage == "That ship hasn't been designed yet.  Try again.\n" {
                self.selectionError = newMessage
            }
            if newMessage.contains("You need a rank of") {
                self.selectionError = newMessage
            }
            if newMessage.contains("You need an offense of") {
                self.selectionError = newMessage
            }
        }
    }
    init() {
        for planetId in 0 ..< maxPlanets {
            planets.append(Planet(planetId: planetId))
        }
        for playerId in 0 ..< maxPlayers {
            players.append(Player(playerId: playerId))
        }
        for torpedoId in 0 ..< maxTorpedoes {
            torpedoes.append(Torpedo(torpedoId: torpedoId))
        }
        for laserId in 0 ..< maxLasers {
            lasers.append(Laser(laserId: laserId))
        }
        for plasmaId in 0 ..< maxPlasma {
            plasmas.append(Plasma(plasmaId: plasmaId))
        }
        //self.me = players[0]
    }
    public func reset() {
        //called when we disconnect from server
        for player in players {
            player.reset()
        }
        for planet in planets {
            planet.reset()
        }
        for torpedo in torpedoes {
            torpedo.reset()
        }
        for laser in lasers {
            laser.reset()
        }
        for plasma in plasmas {
            plasma.reset()
        }
        shipInfo = [:]
        me = 0
    }
    public func createPlanet(planetId: Int, positionX: Int, positionY: Int, name: String) {
        guard planetId >= 0 else {
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetId)")
            return
        }
        guard planetId < maxPlanets else {   // sanity check for crazy planet numbers
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetId)")
            return
        }
        guard let planet = planets[safe: planetId] else {
            debugPrint("Error planet id \(planetId) does not exist)")
            return
        }
        planet.update(name: name, positionX: positionX, positionY: positionY)

        /*else {
            let newPlanet = Planet(planetID: planetID)
            newPlanet.update(name: name, positionX: positionX, positionY: positionY)
            planets[planetID] = newPlanet
        }*/
    }
    public func updatePlayer(playerId: Int, shipType: Int, team: Int) {
        guard playerId >= 0 && playerId < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerId)")
            return
        }
        if self.players[safe: playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.update(shipType: shipType)
        self.players[safe: playerId]?.update(team: team)
    }
    public func updatePlayer(playerId: Int, war: UInt32, hostile: UInt32) {
        guard playerId >= 0 && playerId < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerId)")
            return
        }
        if self.players[safe: playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.update(war: war, hostile: hostile)
    }
    public func updatePlayer(playerId: Int, rank: Int, name: String, login: String) {
        guard playerId >= 0 && playerId < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerId)")
            return
        }
        if self.players[safe: playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.update(rank: rank, name: name, login: login)

    }

    public func updatePlayer(playerId: Int, kills: Double) {
        guard playerId >= 0 && playerId < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerId)")
            return
        }
        if self.players[safe: playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.update(kills: kills)
    }
    public func updatePlayer(playerId: Int, directionNetrek: UInt8, speed: Int, positionX: Int, positionY: Int) {
        guard playerId >= 0 && playerId < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerId)")
            return
        }
        if self.players[safe: playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.update(directionNetrek: directionNetrek, speed: speed, positionX: positionX, positionY: positionY)
    }
    
    public func updatePlayer(playerID: Int, tournamentKills: Int, tournamentLosses: Int, overallKills: Int, overallLosses: Int, tournamentTicks: Int, tournamentPlanets: Int, tournamentArmies: Int, starbaseKills: Int, starbaseLosses: Int, practiceArmies: Int, practicePlanets: Int, maxKills: Double, sbMaxKills: Double) {
        if self.players[safe: playerID] == nil {
            let newPlayer = Player(playerId: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[safe: playerID]?.updatePlayer(playerId: playerID, tournamentKills: tournamentKills, tournamentLosses: tournamentLosses,
        overallKills: overallKills,
        overallLosses: overallLosses,
        tournamentTicks: tournamentTicks,
        tournamentPlanets: tournamentPlanets,
        tournamentArmies: tournamentArmies,
        starbaseKills: starbaseKills,
        starbaseLosses: starbaseLosses,
        practiceArmies: practiceArmies,
        practicePlanets: practicePlanets,
        maxKills: maxKills,
        sbMaxKills: sbMaxKills)
    }
    /*public func updatePlayer(playerId: Int, tournamentKills: Int, tournamentLosses: Int, tournamentTicks: Int, tournamentPlanets: Int, tournamentArmies: Int) {
        if self.players[safe: playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.updatePlayer(playerId: playerId, tournamentKills: tournamentKills, tournamentLosses: tournamentLosses, tournamentTicks: tournamentTicks, tournamentPlanets: tournamentPlanets, tournamentArmies: tournamentArmies)
    }*/

    
    public func updateMe(myPlayerId: Int, hostile: UInt32, war: UInt32, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        guard myPlayerId >= 0 && myPlayerId < maxPlayers else {
            debugPrint("Universe.updateMe invalid playerID \(myPlayerId)")
            return
        }
        guard myPlayerId >= 0 && myPlayerId < self.maxPlayers else {
            debugPrint("Fatal Error: unexpected myPlayerId \(myPlayerId)")
            return
        }
        DispatchQueue.main.async {
            self.me = myPlayerId
            debugPrint("Me updated to \(myPlayerId)")
            self.players[self.me].updateMe(myPlayerId: myPlayerId, hostile: hostile, war: war, armies: armies, tractor: tractor, flags: flags, damage: damage, shieldStrength: shieldStrength, fuel: fuel, engineTemp: engineTemp, weaponsTemp: weaponsTemp, whyDead: whyDead, whoDead: whoDead)
        }
    }
    public func updateTorpedo(torpedoNumber: Int, war: UInt8, status: UInt8) {
        guard torpedoNumber >= 0 && torpedoNumber < maxTorpedoes else {
            debugPrint("Universe.updatePlayer invalid torpedoNumber \(torpedoNumber)")
            return
        }
        /*if self.torpedoes[torpedoNumber] == nil {
            let newTorpedo = Torpedo(torpedoID: torpedoNumber)
            self.torpedoes[torpedoNumber] = newTorpedo
        }*/
        self.torpedoes[torpedoNumber].update(war: war, status: status)
    }
    public func updateTorpedo(torpedoNumber: Int, directionNetrek: Int, positionX: Int, positionY: Int) {
        guard torpedoNumber >= 0 && torpedoNumber < maxTorpedoes else {
            debugPrint("Universe.updatePlayer invalid torpedoNumber \(torpedoNumber)")
            return
        }
        if self.torpedoes[safe: torpedoNumber] == nil {
            let newTorpedo = Torpedo(torpedoId: torpedoNumber)
            self.torpedoes[torpedoNumber] = newTorpedo
        }
        self.torpedoes[torpedoNumber].update(directionNetrek: directionNetrek, positionX: positionX, positionY: positionY)
    }
    public func updateLaser(laserId: Int, status: Int, directionNetrek: UInt8, positionX: Int, positionY: Int, target: Int) {
        guard laserId >= 0 && laserId < maxLasers else {
            debugPrint("Universe.updatePlayer invalid laserNumber \(laserId)")
            return
        }
        self.lasers[laserId].update(laserId: laserId, status: status, directionNetrek: directionNetrek, positionX: positionX, positionY: positionY, target: target)
    }

    public func updatePlasma(plasmaId: Int, war: UInt8, status: Int) {
        guard plasmaId >= 0 && plasmaId < maxPlasma else {
            debugPrint("Universe.updatePlayer invalid plasmaNumber \(plasmaId)")
            return
        }
        self.plasmas[plasmaId].update(plasmaId: plasmaId, war: war, status: status)
    }
    public func updatePlasma(plasmaId: Int, positionX: Int, positionY: Int) {
        guard plasmaId >= 0 && plasmaId < maxPlasma else {
            debugPrint("Universe.updatePlayer invalid plasmaID \(plasmaId)")
            return
        }
        self.plasmas[plasmaId].update(positionX: positionX, positionY: positionY)
    }
    
    public func shipinfo(shipType: ShipType, torpSpeed: Int, phaserRange: Int, maxSpeed: Int, maxFuel: Int, maxShield: Int, maxDamage: Int, maxWpnTmp: Int, maxEngTmp: Int, width: Int, height: Int, maxArmies: Int) {
        if shipInfo[shipType] == nil {
            let newShipInfo = ShipInfo(shipType: shipType, torpSpeed: torpSpeed, phaserRange: phaserRange, maxSpeed: maxSpeed, maxFuel: maxFuel, maxShield: maxShield, maxDamage: maxDamage, maxWpnTmp: maxWpnTmp, maxEngTmp: maxEngTmp, width: width, height: height, maxArmies: maxArmies)
            self.shipInfo[shipType] = newShipInfo
        }
    }


}
