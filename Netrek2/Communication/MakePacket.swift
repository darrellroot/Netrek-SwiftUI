//
//  MakePacket.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit

class MakePacket {
    static let appDelegate = NSApplication.shared.delegate as! AppDelegate

    static func make16Tuple(string: String) -> (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) {
        var temp: [UInt8] = []
        for _ in 0..<16 {
            temp.append(0)
        }
        for (index,char) in string.utf8.enumerated() {
            if index < 15 {
                // leaving last position with null
                temp[index] = char
            }
        }
        let information = (temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14],temp[15])
        return information
    }
    
    // CP_MEESSAGE 1
    static func cpMessage(message: String, team: Team?, individual: UInt8) -> Data {
        let message_length = 80
        var packet = CP_MESSAGE()
        //packet.type = 1
        if let team = team {
            switch team {
            case .independent: // we'll assume this means all teams
                packet.group = 8 // MALL
                packet.indiv = 0
            case .federation, .roman, .kazari, .orion:
                packet.group = 4 //MTEAM
                packet.indiv = UInt8(team.rawValue)
            case .ogg:  // meaning all teams
                packet.group = 8 // MALL
                packet.indiv = 0
            }
        } else {  // team == nil so this is going to an individual
            packet.group = 2 // MINDIV
            packet.indiv = UInt8(individual)
        }
        //packet.pad1 = 0
        withUnsafeMutablePointer(to: &packet.mesg) {
            $0.withMemoryRebound(to: UInt8.self, capacity: message_length) {mesg_ptr in
                for count in 0 ..< message_length {
                    mesg_ptr[count] = 0
                }
                var count = 0
                for char in message.utf8 {
                    if count < message_length - 1 {
                        mesg_ptr[count] = char
                        count = count + 1
                    }
                }
                for count2 in count ..< message_length {
                    mesg_ptr[count2] = 0
                }
            }
        }
        let data = Data(bytes: &packet, count: message_length + 4)
        debugPrint("Sending CP_MESSAGE 1 team: \(team) individual: \(individual) message \(message)")
        return data
    }

    // CP_SPEED 2
    static func cpSpeed(speed: Int) -> Data? {
        var packet = CP_SPEED()
        guard speed >= 0 else {
            return nil
        }
        guard speed < 13 else {
            return nil
        }
        packet.speed = UInt8(speed)
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_SPEED 2 speed \(speed)")
        return data
    }

    // CP_DIRECTION 3
    static func cpDirection(netrekDirection: UInt8) -> Data? {
        var packet = CP_DIRECTION()
        packet.direction = UInt8(netrekDirection)
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_DIRECTION 3 direction \(netrekDirection)")
        return data
    }
    // CP_LASER 4
    static func cpLaser(netrekDirection: UInt8) -> Data {
        var packet = CP_LASER()
        packet.netrekDirection = netrekDirection
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_LASER 4 direction \(netrekDirection)")
        return data
    }
    // CP_PLASMA 5
    static func cpPlasma(netrekDirection: UInt8) -> Data {
        var packet = CP_PLASMA()
        packet.netrekDirection = netrekDirection
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_PLASMA 5 direction \(netrekDirection)")
        return data
    }
    
    // CP_TORP 6
    static func cpTorp(netrekDirection: UInt8) -> Data {
        var packet = CP_TORP()
        packet.netrekDirection = netrekDirection
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_TORP 6 direction \(netrekDirection)")
        return data
    }
    // CP_QUIT 7
    static func cpQuit() -> Data {
        var packet = CP_QUIT()
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_QUIT 7")
        return data
    }
    
    // CP_LOGIN 8
    static func cpLogin(name: String, password: String, login: String) -> Data {
        // ugly hack with 16-element tuple and
        // C structure header to get bit boundaries to align
        
        var packet = CP_LOGIN()
        //packet.type = 8
        packet.query = 0
        packet.name = make16Tuple(string: name)
        packet.login = make16Tuple(string: login)
        packet.password = make16Tuple(string: password)
        debugPrint("Sending CP_LOGIN 8 query \(packet.query) name \(name)")
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    // CP_OUTFIT 9
    static func cpOutfit(team: Team, ship: ShipType) -> Data {
        debugPrint("Sending CP_OUTFIT 9")
        // packet type 9
        var packet = CP_OUTFIT(team: team, ship: ship)
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    // CP 10 war not implemented
    
    static func cpPractice() -> Data {
        debugPrint("Sending CP_PRACTR 11")
        var packet = CP_PRACTR()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    // CP_SHIELD 12
    static func cpShield(up: Bool) -> Data {
        var packet = CP_SHIELD()
        if up {
            packet.state = 1
        } else {
            packet.state = 0
        }
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_SHIELD state \(packet.state)")
        return data
    }
    
    // CP_REPAIR 13 not called yet
    static func cpRepair(state: Bool) -> Data {
        var packet = CP_REPAIR()
        if state {
            packet.state = 1
        } else {
            packet.state = 0
        }
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_REPAIR state \(packet.state)")
        return data
    }
    
    // CP_ORBIT 14 NOT implemented
    static func cpOrbit(state: Bool) -> Data {
        var packet = CP_ORBIT()
        if state {
            packet.state = 1
        } else {
            packet.state = 0
        }
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_ORBIT state \(packet.state)")
        return data
    }
    
    // CP_PLANLOCK 15
    static func cpPlanetLock(planetID: UInt8) -> Data {
        var packet = CP_PLANLOCK()
        packet.planetID = planetID
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_PLANLOCK planetID \(planetID)")
        return data
    }
    
    // CP_PLAYLOCK 16
    static func cpPlayerLock(playerID: UInt8) -> Data{
        var packet = CP_PLAYLOCK()
        packet.playerID = playerID
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_PLAYLOCK playerID \(playerID)")
        return data
    }
    
    //CP_BOMB 17
    static func cpBomb(state: Bool) -> Data {
        var packet = CP_BOMB()
        if state {
            packet.state = 1
        } else {
            packet.state = 0
        }
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_BOMB state \(packet.state)")
        return data
    }
    //CP_BEAM 18
    static func cpBeam(state: Bool) -> Data {
        //state true means beamup, state false means beamdown
        var packet = CP_BEAM()
        if state {
            packet.state = 1
        } else {
            packet.state = 2
        }
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_BEAM state \(packet.state)")
        return data
    }

    //CP_CLOAK 19
    static func cpCloak(state: Bool) -> Data {
        var packet = CP_CLOAK()
        if state {
            packet.state = 1
        } else {
            packet.state = 0
        }
        let data = Data(bytes: &packet, count: packet.size)
        debugPrint("Sending CP_CLOAK state \(packet.state)")
        return data
    }
    
    // CP_DET_TORPS 20
    static func cpDetTorps() -> Data {
        debugPrint("Sending CP_DET_TORPS")
        var packet = CP_DET_TORPS()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }

    // CP_DET_MYTORPS 21
    static func cpDetMyTorps(torpNum: UInt8) -> Data {
        debugPrint("Sending CP_DET_MYTORP")
        var packet = CP_DET_MYTORP()
        packet.tNumByte1 = 0
        packet.tNumByte2 = torpNum
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    // CP_COPLIOT 22 not implemented
    
    // CP_REFIT 23
    static func cpRefit(newShip: ShipType) -> Data {
        debugPrint("Sending CP_REFIT 23 shipType \(newShip.rawValue)")
        var packet = CP_REFIT()
        packet.ship = UInt8(newShip.rawValue)
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }

    static func cpTractor(on: Bool, playerID: UInt8) -> Data {
        debugPrint("Sending CP_TRACTOR 24 on \(on) playerID \(playerID)")
        var packet = CP_TRACTOR()
        if on {
            packet.state = 1
        } else {
            packet.state = 0
        }
        packet.playerID = playerID
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    static func cpPressor(on: Bool, playerID: UInt8) -> Data {
        debugPrint("Sending CP_REPRESS 25 on \(on) playerID \(playerID)")
        var packet = CP_REPRESS()
        if on {
            packet.state = 1
        } else {
            packet.state = 0
        }
        packet.playerID = playerID
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    static func cpCoup() -> Data {
        debugPrint("Sending CP_COUP 26")
        var packet = CP_COUP()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }

    static func cpSocket() -> Data {
        debugPrint("Sending CP_SOCKET 27")

        // packet type 27
        var packet = CP_SOCKET()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    // CP_OPTIONS 28 not implemented
    
    static func cpBye() -> Data {
        debugPrint("Sending CP_BYE 29")
        var packet = CP_BYE()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    
    static func cpDockperm(state: Bool) -> Data {
        debugPrint("Sending CP_DOCKPERM 30 \(state)")
        var packet = CP_DOCKPERM()
        if state {
            packet.state = 1
        } else {
            packet.state = 0
        }
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpUpdates() -> Data {
        var packet = CP_UPDATES()
        debugPrint("Sending CP_UPDATE 31 \(packet.usecs.byteSwapped)")
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpFeatures(feature: String, arg1: Int8 = 0) -> Data {
        let value = 1
        debugPrint("Sending CP_FEATURE 60 arg1 \(arg1) value \(value) feature \(feature)")
        var packet = CP_FEATURE()
        //packet.type = 60
        packet.feature_type = 83 // S in ascii
        packet.arg1 = UInt8(arg1)
        packet.arg2 = 0
        packet.value = UInt32(value).bigEndian
        var name = withUnsafeMutableBytes(of: &packet.name) {bytes in
            var count = 0
            let feature = feature.utf8
            for char in feature {
                bytes[count] = char
                count = count + 1
            }
            // now null pad to 80
            for _ in count..<80 {
                bytes[count] = 0
                count = count + 1
            }
        }
        //var packet = CP_FEATURE(feature: feature)
        let data = Data(bytes: &packet, count: MemoryLayout.size(ofValue: packet))
        return data
    }

    /*static func cpLogin(name: String, password: String, login: String) -> Data {
        var packet = CP_LOGIN()
        for (index,char) in name.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                debugPrint("index \(index) char \(UInt8(char))")
                packet.name[index] = UInt8(char)
            }
        }
        for (index,char) in password.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                packet.password[index] = UInt8(char)
            }
        }
        for (index,char) in login.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                packet.login[index] = UInt8(char)
            }
        }
        let data = Data(bytes: &packet, count: packet.size)
        for byte in data {
            debugPrint(byte)
        }
        return data
    }*/
}
