//
//  Universe.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Universe: ObservableObject {
    var players: [Player] = []
    var planets: [Planet] = []
    var torpedoes: [Int: Torpedo] = [:]
    var lasers: [Int: Laser] = [:]
    var plasmas: [Int: Plasma] = [:]
    var shipInfo: [ShipType:ShipInfo] = [:]
    var me: Player
    let maxPlanets = 40
    let maxPlayers = 32
    let maxTorpedoes = 32 * 8
    let maxLasers = 32
    let maxPlasma = 32
    
    init() {
        for planetId in 0 ..< maxPlanets {
            planets.append(Planet(planetId: planetId))
        }
        for playerId in 0 ..< maxPlayers {
            players.append(Player(playerId: playerId))
        }
        self.me = players[0]
    }
    public func reset() {
        //called when we disconnect from server
        for player in players {
            player.reset()
        }
        for planet in planets {
            planet.reset()
        }
        torpedoes = [:]
        lasers = [:]
        plasmas = [:]
        shipInfo = [:]
        me = players[0]
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
        if self.players[playerId] == nil {
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
        if self.players[playerId] == nil {
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
        if self.players[playerId] == nil {
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
        if self.players[playerId] == nil {
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
        if self.players[playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.update(directionNetrek: directionNetrek, speed: speed, positionX: positionX, positionY: positionY)
    }
    
    public func updatePlayer(playerId: Int, tournamentKills: Int, tournamentLosses: Int, tournamentTicks: Int, tournamentPlanets: Int, tournamentArmies: Int) {
        if self.players[playerId] == nil {
            let newPlayer = Player(playerId: playerId)
            self.players[playerId] = newPlayer
        }
        self.players[safe: playerId]?.updatePlayer(playerId: playerId, tournamentKills: tournamentKills, tournamentLosses: tournamentLosses, tournamentTicks: tournamentTicks, tournamentPlanets: tournamentPlanets, tournamentArmies: tournamentArmies)
    }

    
    public func updateMe(myPlayerId: Int, hostile: UInt32, war: UInt32, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        guard myPlayerId >= 0 && myPlayerId < maxPlayers else {
            debugPrint("Universe.updateMe invalid playerID \(myPlayerId)")
            return
        }
        if self.players[myPlayerId] == nil {
            let newPlayer = Player(playerId: myPlayerId)
            self.players[myPlayerId] = newPlayer
        }
        if self.me == nil {
            self.me = self.players[myPlayerId]
        }
        self.me.updateMe(myPlayerId: myPlayerId, hostile: hostile, war: war, armies: armies, tractor: tractor, flags: flags, damage: damage, shieldStrength: shieldStrength, fuel: fuel, engineTemp: engineTemp, weaponsTemp: weaponsTemp, whyDead: whyDead, whoDead: whoDead)
    }
    public func updateTorpedo(torpedoNumber: Int, war: UInt8, status: UInt8) {
        guard torpedoNumber >= 0 && torpedoNumber < maxTorpedoes else {
            debugPrint("Universe.updatePlayer invalid torpedoNumber \(torpedoNumber)")
            return
        }
        if self.torpedoes[torpedoNumber] == nil {
            let newTorpedo = Torpedo(torpedoID: torpedoNumber)
            self.torpedoes[torpedoNumber] = newTorpedo
        }
        self.torpedoes[torpedoNumber]?.update(war: war, status: status)
    }
    public func updateTorpedo(torpedoNumber: Int, directionNetrek: Int, positionX: Int, positionY: Int) {
        guard torpedoNumber >= 0 && torpedoNumber < maxTorpedoes else {
            debugPrint("Universe.updatePlayer invalid torpedoNumber \(torpedoNumber)")
            return
        }
        if self.torpedoes[torpedoNumber] == nil {
            let newTorpedo = Torpedo(torpedoID: torpedoNumber)
            self.torpedoes[torpedoNumber] = newTorpedo
        }
        self.torpedoes[torpedoNumber]?.update(directionNetrek: directionNetrek, positionX: positionX, positionY: positionY)
    }
    public func updateLaser(laserID: Int, status: Int, directionNetrek: UInt8, positionX: Int, positionY: Int, target: Int) {
        guard laserID >= 0 && laserID < maxLasers else {
            debugPrint("Universe.updatePlayer invalid laserNumber \(laserID)")
            return
        }
        if self.lasers[laserID] == nil {
            let newLaser = Laser()
            self.lasers[laserID] = newLaser
        }
        self.lasers[laserID]?.update(laserID: laserID, status: status, directionNetrek: directionNetrek, positionX: positionX, positionY: positionY, target: target)
    }

    public func updatePlasma(plasmaID: Int, war: UInt8, status: Int) {
        guard plasmaID >= 0 && plasmaID < maxPlasma else {
            debugPrint("Universe.updatePlayer invalid plasmaNumber \(plasmaID)")
            return
        }
        if self.plasmas[plasmaID] == nil {
            let newPlasma = Plasma()
            self.plasmas[plasmaID] = newPlasma
        }
        self.plasmas[plasmaID]?.update(plasmaID: plasmaID, war: war, status: status)
    }
    public func updatePlasma(plasmaID: Int, positionX: Int, positionY: Int) {
        guard plasmaID >= 0 && plasmaID < maxPlasma else {
            debugPrint("Universe.updatePlayer invalid plasmaID \(plasmaID)")
            return
        }
        if self.plasmas[plasmaID] == nil {
            let newPlasma = Plasma()
            self.plasmas[plasmaID] = newPlasma
        }
        self.plasmas[plasmaID]?.update(positionX: positionX, positionY: positionY)
    }
    
    public func shipinfo(shipType: ShipType, torpSpeed: Int, phaserRange: Int, maxSpeed: Int, maxFuel: Int, maxShield: Int, maxDamage: Int, maxWpnTmp: Int, maxEngTmp: Int, width: Int, height: Int, maxArmies: Int) {
        if shipInfo[shipType] == nil {
            let newShipInfo = ShipInfo(shipType: shipType, torpSpeed: torpSpeed, phaserRange: phaserRange, maxSpeed: maxSpeed, maxFuel: maxFuel, maxShield: maxShield, maxDamage: maxDamage, maxWpnTmp: maxWpnTmp, maxEngTmp: maxEngTmp, width: width, height: height, maxArmies: maxArmies)
            self.shipInfo[shipType] = newShipInfo
        }
    }


}
