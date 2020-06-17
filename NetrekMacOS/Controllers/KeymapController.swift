//
//  KeymapController.swift
//  Netrek
//
//  Created by Darrell Root on 3/8/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SwiftUI

enum Control: String, CaseIterable {
    case zeroKey = "0 key"
    case oneKey = "1 key"
    case twoKey = "2 key"
    case threeKey = "3 key"
    case fourKey = "4 key"
    case fiveKey = "5 key"
    case sixKey = "6 key"
    case sevenKey = "7 key"
    case eightKey = "8 key"
    case nineKey = "9 key"
    case spacebarKey = "spacebar key"
    case rightParenKey = ") key"
    case exclamationMarkKey = "! key"
    case atKey = "@ key"
    case percentKey = "% key"
    case poundKey = "# key"
    case lessThanKey = "< key"
    case greaterThanKey = "> key"
    case rightBracketKey = "] key"
    case leftBracketKey = "[ key"
    case leftMouse = "left mouse button"
    case otherMouse = "center mouse button"
    case rightMouse = "right mouse button"
    case leftCurly = "{ key"
    case rightCurly = "} key"
    case underscore = "_ key"
    case carrot = "^ key"
    case dollar = "$ key"
    case semicolon = "; key"
    case aKey = "a key"
    case bKey = "b key"
    case cKey = "c key"
    case dKey = "d key"
    case eKey = "e key"
    case fKey = "f key"
    case gKey = "g key"
    case hKey = "h key"
    case iKey = "i key"
    case jKey = "j key"
    case kKey = "k key"
    case lKey = "l key"
    case mKey = "m key"
    case nKey = "n key"
    case oKey = "o key"
    case pKey = "p key"
    case qKey = "q key"
    case rKey = "r key"
    case sKey = "s key"
    case tKey = "t key"
    case uKey = "u key"
    case vKey = "v key"
    case wKey = "w key"
    case xKey = "x key"
    case yKey = "y key"
    case zKey = "z key"
    case AKey = "A key"
    case BKey = "B key"
    case CKey = "C key"
    case DKey = "D key"
    case EKey = "E key"
    case FKey = "F key"
    case GKey = "G key"
    case HKey = "H key"
    case IKey = "I key"
    case JKey = "J key"
    case KKey = "K key"
    case LKey = "L key"
    case MKey = "M key"
    case NKey = "N key"
    case OKey = "O key"
    case PKey = "P key"
    case QKey = "Q key"
    case RKey = "R key"
    case SKey = "S key"
    case TKey = "T key"
    case UKey = "U key"
    case VKey = "V key"
    case WKey = "W key"
    case XKey = "X key"
    case YKey = "Y key"
    case ZKey = "Z key"
    case asteriskKey = "* key"
}

enum Command: String, CaseIterable {
    case speedZero = "Set speed 0"
    case speedOne = "Set speed 1"
    case speedTwo = "Set speed 2"
    case speedThree = "Set speed 3"
    case speedFour = "Set speed 4"
    case speedFive = "Set speed 5"
    case speedSix = "Set speed 6"
    case speedSeven = "Set speed 7"
    case speedEight = "Set speed 8"
    case speedNine = "Set speed 9"
    case speedTen = "Set speed 10"
    case speedEleven = "Set speed 11"
    case speedTwelve = "Set speed 12"
    case speedMax = "Set speed maximum"
    case speedHalf = "Set speed half"
    case speedDecrease = "Decrease speed 1"
    case speedIncrease = "Speed increase 1"
    case setCourse = "Set course"
    case beamUp = "Beam up armies"
    case beamDown = "Beam down armies"
    case bomb = "Bomb"
    case cloak = "Toggle cloak"
    case cloakUp = "Activate cloak"
    case cloakDown = "Deactivate cloak"
    case coup = "Coup own home planet"
    case detOwn = "Detonate own torpedoes"
    case detEnemy = "Detonate enemy torpedoes"
    case dockingPermission = "Docking Permission Toggle"
    case fireTorpedo = "Fire torpedo"
    case firePlasma = "Fire plasma"
    case fireLaser = "Fire laser"
    case information = "Information"
    case lockDestination = "Lock onto Destination"
    case lockStarbasePlanet = "Lock onto starbase or Planet"
    case lowerShields = "Lower shields"
    case nothing = "Nothing"
    case orbit = "Orbit"
    case pressorBeam = "Pressor beam toggle"
    case pressorOn = "Pressor beam on"
    case raiseShields = "Raise shields"
    case refit = "Refit (unused: use launch ship menu)"
    case repair = "Repair"
    case toggleShields = "Toggle shields"
    case tractorPressorOff = "Tractor and pressor beams off"
    case tractorBeam = "Tractor beam toggle"
    case tractorOn = "Tractor beam on"
    case quitGame = "Self destruct and quit game"
    case practiceRobot = "Send in practice robot"
}

class KeymapController {
    
    #if os(macOS)
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif
    
    var keymap: [Control:Command] = [:]
    
    init() {
        self.setDefaults()
        self.loadSavedKeymaps()
    }
    
    
    func setDefaults() {
        keymap = [:]
        keymap = [
            .zeroKey:.speedZero,
            .oneKey:.speedOne,
            .twoKey:.speedTwo,
            .threeKey:.speedThree,
            .fourKey:.speedFour,
            .fiveKey:.speedFive,
            .sixKey:.speedSix,
            .sevenKey:.speedSeven,
            .eightKey:.speedEight,
            .nineKey:.speedNine,
            .spacebarKey:.nothing,
            .rightParenKey:.speedTen,
            .exclamationMarkKey:.speedEleven,
            .atKey:.speedTwelve,
            .percentKey:.speedMax,
            .poundKey:.speedHalf,
            .lessThanKey:.speedDecrease,
            .greaterThanKey:.speedIncrease,
            .rightBracketKey:.raiseShields,
            .leftBracketKey:.lowerShields,
            .leftCurly:.cloakDown,
            .rightCurly:.cloakUp,
            .underscore:.tractorOn,
            .carrot:.pressorOn,
            .dollar:.tractorPressorOff,
            .aKey:.nothing,
            .bKey:.bomb,
            .cKey:.cloak,
            .dKey:.detEnemy,
            .eKey:.dockingPermission,
            .fKey:.firePlasma,
            .gKey:.nothing,
            .hKey:.nothing,
            .iKey:.information,
            .jKey:.nothing,
            .kKey:.setCourse,
            .lKey:.lockDestination,
            .mKey:.nothing,
            .nKey:.nothing,
            .oKey:.orbit,
            .pKey:.fireLaser,
            .qKey:.nothing,
            .rKey:.refit,
            .sKey:.toggleShields,
            .tKey:.fireTorpedo,
            .uKey:.raiseShields,
            .vKey:.nothing,
            .wKey:.nothing,
            .xKey:.beamDown,
            .yKey:.pressorBeam,
            .zKey:.beamUp,
            .AKey:.nothing,
            .BKey:.nothing,
            .CKey:.coup,
            .DKey:.detOwn,
            .EKey:.nothing,
            .FKey:.nothing,
            .GKey:.nothing,
            .HKey:.nothing,
            .IKey:.nothing,
            .JKey:.nothing,
            .KKey:.nothing,
            .LKey:.nothing,
            .MKey:.nothing,
            .NKey:.nothing,
            .OKey:.nothing,
            .PKey:.nothing,
            .QKey:.quitGame,
            .RKey:.repair,
            .SKey:.nothing,
            .TKey:.tractorBeam,
            .UKey:.nothing,
            .VKey:.nothing,
            .WKey:.nothing,
            .XKey:.nothing,
            .YKey:.nothing,
            .ZKey:.nothing,
            .leftMouse:.fireTorpedo,
            .otherMouse:.fireLaser,
            .rightMouse:.setCourse,
            .asteriskKey:.practiceRobot,
        ]
    }
    public func setKeymap(control: Control, command: Command) {
        self.keymap[control] = command
        appDelegate.defaults.set(command.rawValue, forKey: control.rawValue)
    }
    func resetKeymaps() {
        for control in Control.allCases {
            appDelegate.defaults.removeObject(forKey: control.rawValue)
        }
        self.setDefaults()
        appDelegate.defaults.synchronize()
    }
    func loadSavedKeymaps() {
        for control in Control.allCases {
            if let commandString = appDelegate.defaults.string(forKey: control.rawValue) {
                for command in Command.allCases {
                    if command.rawValue == commandString {
                        keymap[control] = command
                    }
                }
            }
        }
    }
    //appDelegate.keymapController.setKeymap(control: control, command: command)
    
    func execute(_ control: Control, location: CGPoint?) {
        if let command = keymap[control] {
            execute(command, location: location)
        }
    }
    func execute(_ command: Command, location: CGPoint?) {
        let universe = appDelegate.universe
        let players = appDelegate.universe.players
        let me = appDelegate.universe.me
        switch command {
            
        case .nothing:
            break
        case .speedZero:
            self.setSpeed(0)
        case .speedOne:
            self.setSpeed(1)
        case .speedTwo:
            self.setSpeed(2)
        case .speedThree:
            self.setSpeed(3)
        case .speedFour:
            self.setSpeed(4)
        case .speedFive:
            self.setSpeed(5)
        case .speedSix:
            self.setSpeed(6)
        case .speedSeven:
            self.setSpeed(7)
        case .speedEight:
            self.setSpeed(8)
        case .speedNine:
            self.setSpeed(9)
        case .speedTen:
            self.setSpeed(10)
        case .speedEleven:
            self.setSpeed(11)
        case .speedTwelve:
            self.setSpeed(12)
        case .speedMax:
            if let myShipType = players[me].ship, let myShipInfo = universe.shipInfo[myShipType] {
                self.setSpeed(myShipInfo.maxSpeed)
            }
        case .speedHalf:
            if let myShipType = players[me].ship, let myShipInfo = universe.shipInfo[myShipType] {
                self.setSpeed(myShipInfo.maxSpeed / 2)
            }
        case .speedIncrease:
            let currentSpeed = players[me].speed
            if currentSpeed < 12 {
                self.setSpeed(currentSpeed + 1)
            }
        case .speedDecrease:
            let currentSpeed = players[me].speed
            if currentSpeed > 0 {
                self.setSpeed(currentSpeed + 1)
            }
            /*
             case speedMax = "Set speed maximum"
             case speedHalf = "Set speed half"
             */
        case .beamUp:
            let cpBeam = MakePacket.cpBeam(state: true)
            appDelegate.reader?.send(content: cpBeam)
        case .beamDown:
            let cpBeam = MakePacket.cpBeam(state: false)
            appDelegate.reader?.send(content: cpBeam)
        case .bomb:
            let bombState = players[me].bomb
            let cpBomb = MakePacket.cpBomb(state: !bombState )
            appDelegate.reader?.send(content: cpBomb)
        case .cloakUp:
            guard appDelegate.gameState == .gameActive else { return }
            let cpCloak = MakePacket.cpCloak(state: true )
            appDelegate.reader?.send(content: cpCloak)
            appDelegate.soundController?.play(sound: .shield, volume: 1.0)
        case .cloakDown:
            guard appDelegate.gameState == .gameActive else { return }
            let cpCloak = MakePacket.cpCloak(state: false )
            appDelegate.reader?.send(content: cpCloak)
            appDelegate.soundController?.play(sound: .shield, volume: 1.0)
            
        case .cloak:
            guard appDelegate.gameState == .gameActive else { return }
            let cloakState = players[me].cloak
            let cpCloak = MakePacket.cpCloak(state: !cloakState )
            appDelegate.reader?.send(content: cpCloak)
            appDelegate.soundController?.play(sound: .shield, volume: 1.0)
            
        case .coup:
            let cpCoup = MakePacket.cpCoup()
            appDelegate.reader?.send(content: cpCoup)
            
        case .detEnemy:
            guard appDelegate.gameState == .gameActive else { return }
            let cpDetTorps = MakePacket.cpDetTorps()
            appDelegate.reader?.send(content: cpDetTorps)
            appDelegate.soundController?.play(sound: .detonate, volume: 0.5)
            
        case .detOwn:
            let me = appDelegate.universe.me
            guard appDelegate.gameState == .gameActive else { return }
            for count in 0..<8 {
                let myTorpNum = UInt8(me * 8 + count)
                let cpDetMyTorps = MakePacket.cpDetMyTorps(torpNum: myTorpNum)
                appDelegate.reader?.send(content: cpDetMyTorps)
            }
            appDelegate.soundController?.play(sound: .detonate, volume: 0.5)
        case .dockingPermission:
            let me = appDelegate.universe.me
            let cpDockperm = MakePacket.cpDockperm(state: !players[me].dockok)
            appDelegate.reader?.send(content: cpDockperm)
        case .information:
            guard let location = location else {
                debugPrint("KeymapController.execute.information location is nil...no information")
                return
            }
            let (closestPlayerOptional,closestPlayerDistance) = findClosestPlayer(location: location)
            let (closestPlanetOptional,closestPlanetDistance) = findClosestPlanet(location: location)
            if closestPlayerDistance < closestPlanetDistance {
                // player is closer
                guard let closestPlayer = closestPlayerOptional else { return }
                closestPlayer.showInfo()
            } else {
                // planet is closer
                guard let closestPlanet = closestPlanetOptional else { return }
                DispatchQueue.main.async {
                    closestPlanet.showInfo()
                }
            }
            
        case .refit:
            universe.gotMessage("To refit, orbit home planet and select LAUNCH SHIP menu item")
            break
        case .setCourse:
            guard let location = location else {
                debugPrint("KeymapController.execute.setCourse location is nil...holding steady")
                return
            }
            let me = appDelegate.universe.me
            let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(players[me].positionX), mePositionY: Double(players[me].positionY), destinationX: Double(location.x), destinationY: Double(location.y))
            if let cpDirection = MakePacket.cpDirection(netrekDirection: netrekDirection) {
                appDelegate.reader?.send(content: cpDirection)
            }
            
        case .toggleShields:
            guard appDelegate.gameState == .gameActive else { return }
            
            let shieldsUp = players[me].shieldsUp
            if shieldsUp {
                let cpShield = MakePacket.cpShield(up: false)
                appDelegate.reader?.send(content: cpShield)
            } else {
                let cpShield = MakePacket.cpShield(up: true)
                appDelegate.reader?.send(content: cpShield)
            }
            appDelegate.soundController?.play(sound: .shield, volume: 1.0)
        case .tractorPressorOff:
            let cpTractor = MakePacket.cpTractor(on: false, playerID: 0)
            appDelegate.reader?.send(content: cpTractor)
            let cpPressor = MakePacket.cpPressor(on: false, playerID: 0)
            appDelegate.reader?.send(content: cpPressor)
            
        case .tractorOn:
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.tractorBeam location is nil...cannot lock onto nothing")
                return
            }
            let (closestPlayerOptional,_) = findClosestPlayer(location: targetLocation)
            guard let target = closestPlayerOptional else {
                return
            }
            //guard let me = appDelegate.universe.me else { return }
            if target.me == true { return }
            guard target.playerId >= 0 else { return }
            guard target.playerId < 256 else { return }
            let playerID = UInt8(target.playerId)
            let cpTractor = MakePacket.cpTractor(on: true, playerID: playerID)
            appDelegate.reader?.send(content: cpTractor)
            
        case .tractorBeam:
            debugPrint("TractorBeam location \(String(describing: location))")
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.tractorBeam location is nil...cannot lock onto nothing")
                return
            }
            let (closestPlayerOptional,_) = findClosestPlayer(location: targetLocation)
            guard let target = closestPlayerOptional else {
                return
            }
            let me = appDelegate.universe.me
            if target.me == true { return }
            guard target.playerId >= 0 else { return }
            guard target.playerId < 256 else { return }
            let playerID = UInt8(target.playerId)
            let cpTractor = MakePacket.cpTractor(on: !players[me].tractorFlag, playerID: playerID)
            appDelegate.reader?.send(content: cpTractor)
        case .pressorOn:
            debugPrint("PressorBeam location \(String(describing: location))")
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.pressorBeam location is nil...cannot lock onto nothing")
                return
            }
            let (closestPlayerOptional,_) = findClosestPlayer(location: targetLocation)
            guard let target = closestPlayerOptional else {
                return
            }
            //guard let me = appDelegate.universe.me else { return }
            if target.me == true { return }
            guard target.playerId >= 0 else { return }
            guard target.playerId < 256 else { return }
            let playerID = UInt8(target.playerId)
            let cpPressor = MakePacket.cpPressor(on: true, playerID: playerID)
            appDelegate.reader?.send(content: cpPressor)
            
        case .pressorBeam:
            debugPrint("PressorBeam location \(String(describing: location))")
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.pressorBeam location is nil...cannot lock onto nothing")
                return
            }
            let (closestPlayerOptional,_) = findClosestPlayer(location: targetLocation)
            guard let closestPlayer = closestPlayerOptional else {
                return
            }
            let me = appDelegate.universe.me
            if closestPlayer.me == true { return }
            guard closestPlayer.playerId >= 0 else { return }
            guard closestPlayer.playerId < 256 else { return }
            let playerID = UInt8(closestPlayer.playerId)
            let cpPressor = MakePacket.cpPressor(on: !players[me].pressor, playerID: playerID)
            appDelegate.reader?.send(content: cpPressor)
            
        case .orbit:
            let orbitState = universe.players[me].orbit
            let cpOrbit = MakePacket.cpOrbit(state: !orbitState)
            appDelegate.reader?.send(content: cpOrbit)
            
        case .lowerShields:
            guard appDelegate.gameState == .gameActive else { return }
            
            let cpShield = MakePacket.cpShield(up: false)
            appDelegate.reader?.send(content: cpShield)
            appDelegate.soundController?.play(sound: .shield, volume: 1.0)
            
        case .raiseShields:
            guard appDelegate.gameState == .gameActive else { return }
            
            let cpShield = MakePacket.cpShield(up: true)
            appDelegate.reader?.send(content: cpShield)
            appDelegate.soundController?.play(sound: .shield, volume: 1.0)
            
        case .repair:
            guard appDelegate.gameState == .gameActive else { return }
            
            let repairState = players[me].repair
            let cpRepair = MakePacket.cpRepair(state: !repairState )
            universe.players[me].throttle = 0.0 // used by slider in tacticalView
            appDelegate.reader?.send(content: cpRepair)
        case .fireLaser:
            guard appDelegate.gameState == .gameActive else { return }
            
            debugPrint("FireLaser location \(String(describing: location))")
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.fireLaser location is nil...holding fire")
                return
            }
            let me = appDelegate.universe.me
            let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(players[me].positionX), mePositionY: Double(players[me].positionY), destinationX: Double(targetLocation.x), destinationY: Double(targetLocation.y))
            let cpLaser = MakePacket.cpLaser(netrekDirection: netrekDirection)
            appDelegate.reader?.send(content: cpLaser)
            
        case .fireTorpedo:
            guard appDelegate.gameState == .gameActive else { return }
            
            debugPrint("LeftMouseDown location \(String(describing: location))")
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.fireTorpedo location is nil...holding fire")
                return
            }
            let me = appDelegate.universe.me
            let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(players[me].positionX), mePositionY: Double(players[me].positionY), destinationX: Double(targetLocation.x), destinationY: Double(targetLocation.y))
            let cpTorp = MakePacket.cpTorp(netrekDirection: netrekDirection)
            appDelegate.reader?.send(content: cpTorp)
        case .firePlasma:
            guard appDelegate.gameState == .gameActive else { return }
            
            debugPrint("firePlasma location \(String(describing: location))")
            guard let targetLocation = location else {
                debugPrint("KeymapController.execute.firePlasma location is nil...holding fire")
                return
            }
            let me = appDelegate.universe.me
            let netrekDirection = NetrekMath.calculateNetrekDirection(mePositionX: Double(players[me].positionX), mePositionY: Double(players[me].positionY), destinationX: Double(targetLocation.x), destinationY: Double(targetLocation.y))
            let cpPlasma = MakePacket.cpPlasma(netrekDirection: netrekDirection)
            appDelegate.reader?.send(content: cpPlasma)
        case .quitGame:
            debugPrint("Quitting game")
            let cpQuit = MakePacket.cpQuit()
            appDelegate.reader?.send(content: cpQuit)
        case .practiceRobot:
            debugPrint("Requesting practice robot")
            let cpPractice = MakePacket.cpPractice()
            appDelegate.reader?.send(content: cpPractice)
        case .lockStarbasePlanet:
            guard let lockLocation = location else {
                debugPrint("KeymapController.execute.lockDestination location is nil...awaiting instructions")
                return
            }
            let lockLocationX = Int(lockLocation.x)
            let lockLocationY = Int(lockLocation.y)
            var closestPlanetDistance = 10000
            var closestPlanet: Planet?
            var closestPlayerDistance = 10000
            var closestPlayer: Player?
            
            for planet in appDelegate.universe.planets {
                let thisPlanetDistance = abs(planet.positionX - lockLocationX) + abs(planet.positionY - lockLocationY)
                if thisPlanetDistance < closestPlanetDistance {
                    closestPlanetDistance = thisPlanetDistance
                    closestPlanet = planet
                }
            }
            for player in appDelegate.universe.players {
                if player.ship == .starbase && player.me == false {
                    let thisPlayerDistance = abs(player.positionX - lockLocationX) + abs(player.positionY - lockLocationY)
                    if thisPlayerDistance < closestPlayerDistance {
                        closestPlayerDistance = thisPlayerDistance
                        closestPlayer = player
                    }
                }
            }
            if closestPlayerDistance < closestPlanetDistance {
                // lock onto player
                guard let player = closestPlayer else { return }
                guard player.playerId > 0 && player.playerId < 256 else {
                    debugPrint("keymap.playerlock invalid playerID \(player.playerId)")
                    return
                }
                let cpPlayerLock = MakePacket.cpPlayerLock(playerID: UInt8(player.playerId))
                appDelegate.reader?.send(content: cpPlayerLock)
            } else {
                guard let planet = closestPlanet else { return }
                guard planet.planetId > 0 && planet.planetId < 256 else {
                    debugPrint("keymap.planetlock invalid planetID \(planet.planetId)")
                    return
                }
                let cpPlanetLock = MakePacket.cpPlanetLock(planetID: UInt8(planet.planetId))
                appDelegate.reader?.send(content: cpPlanetLock)
            }
            
        case .lockDestination:
            guard let lockLocation = location else {
                debugPrint("KeymapController.execute.lockDestination location is nil...awaiting instructions")
                return
            }
            let lockLocationX = Int(lockLocation.x)
            let lockLocationY = Int(lockLocation.y)
            var closestPlanetDistance = 10000
            var closestPlanet: Planet?
            var closestPlayerDistance = 10000
            var closestPlayer: Player?
            
            for planet in appDelegate.universe.planets {
                let thisPlanetDistance = abs(planet.positionX - lockLocationX) + abs(planet.positionY - lockLocationY)
                if thisPlanetDistance < closestPlanetDistance {
                    closestPlanetDistance = thisPlanetDistance
                    closestPlanet = planet
                }
            }
            for player in appDelegate.universe.players {
                if player.me == false {
                    let thisPlayerDistance = abs(player.positionX - lockLocationX) + abs(player.positionY - lockLocationY)
                    if thisPlayerDistance < closestPlayerDistance {
                        closestPlayerDistance = thisPlayerDistance
                        closestPlayer = player
                    }
                }
            }
            if closestPlayerDistance < closestPlanetDistance {
                // lock onto player
                guard let player = closestPlayer else { return }
                guard player.playerId >= 0 && player.playerId < 256 else {
                    debugPrint("keymap.playerlock invalid playerID \(player.playerId)")
                    return
                }
                let cpPlayerLock = MakePacket.cpPlayerLock(playerID: UInt8(player.playerId))
                appDelegate.reader?.send(content: cpPlayerLock)
            } else {
                guard let planet = closestPlanet else { return }
                guard planet.planetId >= 0 && planet.planetId < 256 else {
                    debugPrint("keymap.planetlock invalid planetID \(planet.planetId)")
                    return
                }
                let cpPlanetLock = MakePacket.cpPlanetLock(planetID: UInt8(planet.planetId))
                appDelegate.reader?.send(content: cpPlanetLock)
            }
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
    private func findClosestPlayer(location: CGPoint) -> (player: Player?, distance: Int) {
        var closestPlayerDistance = 10000
        var closestPlayer: Player?
        for player in appDelegate.universe.players {
            if player.me == false {
                let thisPlayerDistance = abs(player.positionX - Int(location.x)) + abs(player.positionY - Int(location.y))
                if thisPlayerDistance < closestPlayerDistance {
                    closestPlayerDistance = thisPlayerDistance
                    closestPlayer = player
                }
            }
        }
        return (closestPlayer, closestPlayerDistance)
    }
    func setSpeed(_ speed: Int) {
        if let cpSpeed = MakePacket.cpSpeed(speed: speed) {
            appDelegate.reader?.send(content: cpSpeed)
        }
    }
    
}
