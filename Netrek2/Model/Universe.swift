//
//  Universe.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class Universe: ObservableObject {
    @Published var players: [Int:Player] = [:]
    @Published var planets: [Int:Planet] = [:]
    @Published var torpedoes: [Int: Torpedo] = [:]
    var lasers: [Int: Laser] = [:]
    var plasmas: [Int: Plasma] = [:]
    var shipInfo: [ShipType:ShipInfo] = [:]
    @Published var me: Player?
    let maxPlanets = 200
    let maxPlayers = 100
    let maxTorpedoes = 1000
    let maxLasers = 100
    let maxPlasma = 100
    
    init() {
    }
    public func reset() {
        //called when we disconnect from server
        for player in players.values {
            player.reset()
        }
        players = [:]
        for planet in planets.values {
            planet.reset()
        }
        planets = [:]
        torpedoes = [:]
        lasers = [:]
        plasmas = [:]
        shipInfo = [:]
        me = nil
    }
    public func createPlanet(planetID: Int, positionX: Int, positionY: Int, name: String) {
        guard planetID >= 0 else {
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetID)")
            return
        }
        guard planetID < maxPlanets else {   // sanity check for crazy planet numbers
            debugPrint("ERROR: Universe.updatePlanet invalid planetID \(planetID)")
            return
        }
        if let planet = planets[planetID] {
            planet.update(name: name, positionX: positionX, positionY: positionY)
        } else {
            let newPlanet = Planet(planetID: planetID)
            newPlanet.update(name: name, positionX: positionX, positionY: positionY)
            planets[planetID] = newPlanet
        }
    }
    public func updatePlayer(playerID: Int, shipType: Int, team: Int) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(shipType: shipType)
        self.players[playerID]?.update(team: team)
    }
    public func updatePlayer(playerID: Int, war: UInt32, hostile: UInt32) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(war: war, hostile: hostile)
    }
    public func updatePlayer(playerID: Int, rank: Int, name: String, login: String) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(rank: rank, name: name, login: login)

    }

    public func updatePlayer(playerID: Int, kills: Double) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(kills: kills)
    }
    public func updatePlayer(playerID: Int, directionNetrek: UInt8, speed: Int, positionX: Int, positionY: Int) {
        guard playerID >= 0 && playerID < maxPlayers else {
            debugPrint("Universe.updatePlayer invalid playerID \(playerID)")
            return
        }
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.update(directionNetrek: directionNetrek, speed: speed, positionX: positionX, positionY: positionY)
    }
    
    public func updatePlayer(playerID: Int, tournamentKills: Int, tournamentLosses: Int, tournamentTicks: Int, tournamentPlanets: Int, tournamentArmies: Int) {
        if self.players[playerID] == nil {
            let newPlayer = Player(playerID: playerID)
            self.players[playerID] = newPlayer
        }
        self.players[playerID]?.updatePlayer(playerID: playerID, tournamentKills: tournamentKills, tournamentLosses: tournamentLosses, tournamentTicks: tournamentTicks, tournamentPlanets: tournamentPlanets, tournamentArmies: tournamentArmies)
    }

    
    public func updateMe(myPlayerID: Int, hostile: UInt32, war: UInt32, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        guard myPlayerID >= 0 && myPlayerID < maxPlayers else {
            debugPrint("Universe.updateMe invalid playerID \(myPlayerID)")
            return
        }
        if self.players[myPlayerID] == nil {
            let newPlayer = Player(playerID: myPlayerID)
            self.players[myPlayerID] = newPlayer
        }
        if self.me == nil {
            self.me = self.players[myPlayerID]
        }
        self.me?.updateMe(myPlayerID: myPlayerID, hostile: hostile, war: war, armies: armies, tractor: tractor, flags: flags, damage: damage, shieldStrength: shieldStrength, fuel: fuel, engineTemp: engineTemp, weaponsTemp: weaponsTemp, whyDead: whyDead, whoDead: whoDead)
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
