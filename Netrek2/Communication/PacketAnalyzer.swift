//
//  PacketAnalyzer.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit
class PacketAnalyzer {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let universe: Universe
    var leftOverData: Data?
    
    let msg_len = 80
    let name_len = 16
    let keymap_len = 96
    let playerMax = 100 // we ignore player updates for more than this

    
    init() {
        universe = appDelegate.universe
    }
    
    func analyze(incomingData: Data) {
        //debugPrint("incoming data size \(incomingData.count) leftOverData.size \(String(describing: leftOverData?.count))")
        var data = Data()
        //debugPrint("one data.startIndex \(data.startIndex) data.endIndex \(data.endIndex)")
        
        if leftOverData != nil {
            //debugPrint("leftoverdata.startIndex \(leftOverData!.startIndex) leftoverdata.endIndex \(leftOverData!.endIndex)")
            //data.append(leftOverData!)
            var leftOverDataStruct: [UInt8] = []
            for byte in leftOverData! {
                leftOverDataStruct.append(byte)
            }
            //let leftOverDataStruct: [UInt8] = leftOverData!
            data = leftOverDataStruct + incomingData
            //debugPrint("two")
            //debugPrint("data startIndex \(data.startIndex) endIndex \(data.endIndex)\n")
            //debugPrint("incomingData startIndex \(incomingData.startIndex) endIndex \(incomingData.endIndex)\n")

            //data.append(incomingData)
            //debugPrint("three")
            self.leftOverData = nil
        } else {
            //debugPrint("four")
            data = incomingData
        }
        //debugPrint("done copying data")
        repeat {
            guard let packetType: UInt8 = data.first else {
                debugPrint("PacketAnalyzer.analyze is done, should not have gotten here")
                appDelegate.reader?.receive()
                return
            }
            guard let packetLength = PACKET_SIZES[safe: Int(packetType)] else {
                debugPrint("Warning: PacketAnalyzer.analyze received invalid packet type \(packetType) dumping data")
                printData(data, success: false)
                return
            }
            guard packetLength > 0 else {
                debugPrint("PacketAnalyzer invalid packet length \(packetLength) type \(packetType)")
                printData(data, success: false)
                return
            }
            guard data.count >= packetLength else {
                debugPrint("PacketAnalyzer.analyze: fractional packet expected length \(packetLength) remaining size \(data.count) saving for next round")
                self.leftOverData = Data()
                for byte in data {
                    self.leftOverData?.append(byte)
                }
                //self.leftOverData!.append(data)
                //debugPrint("created leftOverData startIndex \(leftOverData?.startIndex) endIndex \(leftOverData?.endIndex)")
                //debugPrint("from data startIndex \(data.startIndex) endIndex \(data.endIndex)")

                appDelegate.reader?.receive()
                return
            }
            let range = (data.startIndex..<data.startIndex + packetLength)
            //debugPrint("packetAnalyzer.analyze startIndex \(data.startIndex) packetLength \(packetLength) endindex \(data.endIndex) packetType \(packetType)")
            let thisPacket = data.subdata(in: range)
            self.analyzeOnePacket(data: thisPacket)
            data.removeFirst(packetLength)
        } while data.count > 0
        // now that we've analyzed our data, we can try
        // to receive more
        /*DispatchQueue.main.async() {
            self.appDelegate.tacticalViewController?.scene.packetUpdate()
        }*/
        appDelegate.reader?.receive()
    }

    func printData(_ data: Data, success: Bool) {
        let printPacketDumps = true
            if printPacketDumps {
            var dumpString = "\(success) "
            for byte in data {
                let addString = String(format:"%x ",byte)
                dumpString += addString
            }
            debugPrint(dumpString)
        }
    }
    func analyzeOnePacket(data: Data) {
        //debugPrint("in analyze one packet")
        guard data.count > 0 else {
            debugPrint("PacketAnalyer.analyzeOnePacket data length 0")
            return
        }
        let packetType: UInt8 = data[0]
        //debugPrint("in analyze one packet packetType \(packetType)")
        guard let packetLength = PACKET_SIZES[safe: Int(packetType)] else {
            debugPrint("Warning: PacketAnalyzer.analyzeOnePacket received invalid packet type \(packetType)")
            printData(data, success: false)
            return
        }
        guard packetLength > 0 else {
            debugPrint("PacketAnalyzer.analyzeOnePacket invalid packet length \(packetLength) type \(packetType)")
            printData(data, success: false)
            return
        }
        guard packetLength == data.count else {
            debugPrint("PacketAnalyzer.analyeOnePacket unexpected data length \(data.count) expected \(packetLength) type \(packetType)")
            printData(data, success: false)
            return
        }
        switch packetType {
            
        case 1:
            let flags = Int(data[1])
            let m_recpt = Int(data[2])
            let m_from = Int(data[3])
            let range = (4..<(4 + msg_len))
            let messageData = data.subdata(in: range)
            var messageString = "message_decode_error"
//            if let messageStringWithNulls = String(data: messageData, encoding: .utf8) {
            if let messageStringWithNulls = String(data: messageData, encoding: .ascii) {
                messageString = ""
                var done = false
                for char in messageStringWithNulls {
                    if !done && char != "\0" {
                        messageString.append(char)
                    } else {
                        done = true
                    }
                }
 
                messageString = NetrekMath.sanitizeString(messageString)
            //appDelegate.messageViewController?.gotMessage(messageString)
                //debugPrint(messageString)
                //printData(data, success: true)
            } else {
                debugPrint("PacketAnalyzer unable to decode message type 1")
                printData(data, success: false)
            }
            messageString = NetrekMath.sanitizeString(messageString)
            debugPrint("Received SP_MESSAGE 1 from \(m_from) message \(messageString)")

        case 2:
            debugPrint("Received SP_PLAYER_INFO 2")
            //SP_PLAYER_INFO
            let playerID = Int(data[1])
            let shipType = Int(data[2])
            let team = Int(data[3])
            debugPrint("Received SP_PLAYER_INFO 2 playerID \(playerID) shipType \(shipType) team \(team)")
            universe.updatePlayer(playerID: playerID, shipType: shipType, team: team)
       
        case 3:
            // SP_KILLS
            let playerID = Int(data[1])
            let killsInt = data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped
            let kills: Double = Double(killsInt) / 100.0
            universe.updatePlayer(playerID: playerID, kills: kills)
            debugPrint("Received SP_KILLS 3 playerID \(playerID) killsInt \(killsInt) kills \(kills)")

        case 4:
            // SP_PLAYER py-struct
            let playerID = Int(data[1])
            let directionNetrek = UInt8(data[2])
            let speed = Int(data[3])
            let positionX = NetrekMath.netrekX2GameX(Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped))
            let positionY = NetrekMath.netrekY2GameY(Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped))
            universe.updatePlayer(playerID: playerID, directionNetrek: directionNetrek, speed: speed, positionX: positionX, positionY: positionY)
            debugPrint("Received SP_PLAYER 4 playerID \(playerID) directionNetrek \(directionNetrek) speed \(speed) positionX \(positionX) positionY \(positionY)")

        case 5:
            // SP_TORP_INFO
            let war = UInt8(data[1])  //mask of teams torp is hostile to
            let status = UInt8(data[2]) // new status of torp, TFREE, TDET, etc
            // pad
            let torpedoNumber = Int(data.subdata(in: (4..<6)).to(type: UInt16.self).byteSwapped)
            universe.updateTorpedo(torpedoNumber: torpedoNumber, war: war, status: status)
            debugPrint("Received SP_TORP_INFO 5 torpedoNumber \(torpedoNumber) war \(war) status \(status) ")
        
        case 6:
            // SP_TORP
            let directionNetrek = Int(UInt8(data[1]))
            let torpedoNumber = Int(data.subdata(in: (2..<4)).to(type: UInt16.self).byteSwapped)
            let positionX = NetrekMath.netrekX2GameX(Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped))
            let positionY = NetrekMath.netrekY2GameY((Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped)))
            debugPrint("Received SP_TORP 6 torpedoNumber \(torpedoNumber) directionNetrek \(directionNetrek) positionX \(positionX) positionY \(positionY)")
            universe.updateTorpedo(torpedoNumber: torpedoNumber, directionNetrek: directionNetrek, positionX: positionX, positionY: positionY)
            
        case 7:
            // SP_LASER 7
            let laserID = Int(data[1])
            let status = Int(data[2]) // LA_HIT etc...
            let directionNetrek = UInt8(data[3])
            let positionX = NetrekMath.netrekX2GameX(Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped))
            let positionY = NetrekMath.netrekY2GameY(Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped))
            let target = Int(data.subdata(in: (12..<16)).to(type: Int32.self).byteSwapped)
            debugPrint("Received SP_LASER 7 laserID \(laserID) status \(status) directionNetrek \(directionNetrek) positionX \(positionX) positionY \(positionY) target \(target)")
            universe.updateLaser(laserID: laserID, status: status, directionNetrek: directionNetrek, positionX: positionX, positionY: positionY, target: target)
        case 8:
            //SP_PLASMA_INFO
            let war = UInt8(data[1])
            let status = Int(data[2])
            let plasmaID = Int(data.subdata(in: (4..<6)).to(type: UInt16.self).byteSwapped)
            universe.updatePlasma(plasmaID: plasmaID, war: war, status: status)
            debugPrint("Received SP_PLASMA 8 plasmaID \(plasmaID) war \(war) status \(status)")

        case 9:
            //SP_PLASMA
            let plasmaID = Int(data.subdata(in: (2..<4)).to(type: UInt16.self).byteSwapped)
            let positionX = NetrekMath.netrekX2GameX(Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped))
            let positionY = NetrekMath.netrekY2GameY(Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped))
            debugPrint("Received SP_PLASMA 9 plasmaID \(plasmaID) positionX \(positionX) positionY \(positionY)")
            universe.updatePlasma(plasmaID: plasmaID, positionX: positionX, positionY: positionY)
        
        case 10:
            // SP_WARNING
            let range = (4..<84)
            let messageData = data.subdata(in: range)
            if let messageStringWithNulls = String(data: messageData, encoding: .utf8) {
                var messageString = messageStringWithNulls.filter { $0 != "\0" }
                
                messageString.append("\n")
                messageString = NetrekMath.sanitizeString(messageString)
                debugPrint("Received SP_WARNING 10 sent to messages")
                //appDelegate.messageViewController?.gotMessage(messageString)
                //debugPrint(messageString)
                //printData(data, success: true)
            } else {
                debugPrint("PacketAnalyzer unable to decode message type 10")
                printData(data, success: false)
            }

        case 11:
            debugPrint("Received SP_PLAYER_INFO SP_MOTD 11")
            // message
            let range = (4..<84)
            let messageData = data.subdata(in: range)
            if let messageStringWithNulls = String(data: messageData, encoding: .utf8) {
                var messageString = messageStringWithNulls.filter { $0 != "\0" }
                messageString.append("\n")
                messageString = NetrekMath.sanitizeString(messageString)
                //appDelegate.messageViewController?.gotMessage(messageString)
                //debugPrint(messageString)
                //printData(data, success: true)
            } else {
                debugPrint("PacketAnalyzer unable to decode message type 11")
                printData(data, success: false)
            }
        case 12:
            // My information
            // SP_YOU length 32
            let myPlayerID = Int(data[1])
            let hostile = UInt32(data[2])
            let war = UInt32(data[3])
            let armies = Int(data[4])
            let tractor = Int(data[5])
            let flags = data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped
            let damage = Int(data.subdata(in: (12..<16)).to(type: UInt32.self).byteSwapped)
            let shieldStrength = Int(data.subdata(in: (16..<20)).to(type: UInt32.self).byteSwapped)
            let fuel = Int(data.subdata(in: (20..<24)).to(type: UInt32.self).byteSwapped)
            let engineTemp = Int(data.subdata(in: (24..<26)).to(type: UInt16.self).byteSwapped)
            let weaponsTemp = Int(data.subdata(in: (26..<28)).to(type: UInt16.self).byteSwapped)
            let whyDead = Int(data.subdata(in: (28..<30)).to(type: UInt16.self).byteSwapped)
            let whoDead = Int(data.subdata(in: (30..<32)).to(type: UInt16.self).byteSwapped)
            debugPrint("Received SP_YOU 12 \(myPlayerID) hostile \(hostile) war \(war) armies \(armies) tractor \(tractor) flags \(flags) damage \(damage) shieldStrength \(shieldStrength) fuel \(fuel) engineTemp \(engineTemp) weaponsTemp \(weaponsTemp) whyDead \(whyDead) whodead \(whoDead)")
            //printFlags(flags: flags)
            universe.updateMe(myPlayerID: myPlayerID, hostile: hostile, war: war, armies: armies, tractor: tractor, flags: flags, damage: damage, shieldStrength: shieldStrength, fuel: fuel, engineTemp: engineTemp, weaponsTemp: weaponsTemp, whyDead: whyDead, whoDead: whoDead)
            if appDelegate.gameState == .serverSelected || appDelegate.gameState == .serverConnected {
                appDelegate.newGameState(.serverSlotFound)
            }
            //debugPrint(me.description)
            //printData(data, success: true)

        case 13:
            debugPrint("Received SP_QUEUE 13")
            // SP_QUEUE
            let queue = data.subdata(in: (2..<4)).to(type: UInt16.self).byteSwapped
            debugPrint("Connected to server. Wait queue position \(queue)")
            //printData(data, success: true)
            
        case 14:
            let tourn = Int(data[1])
            //pad1
            //pad2
            let armsBomb = (data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped)
            let planets = (data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped)
            let kills = (data.subdata(in: (12..<16)).to(type: UInt32.self).byteSwapped)
            let losses = (data.subdata(in: (16..<20)).to(type: UInt32.self).byteSwapped)
            let time = (data.subdata(in: (20..<24)).to(type: UInt32.self).byteSwapped)
            let timeProd = (data.subdata(in: (24..<28)).to(type: Int32.self).byteSwapped)
            debugPrint("Received SP_STATUS 14 tourn \(tourn) armsBomb \(armsBomb) planets \(planets) kills \(kills) losses \(losses) time \(time) timeProd \(timeProd)")
            let messageString = "Your stats: bombed \(armsBomb) armies, captured \(planets) planets, killed \(kills) enemies, died \(losses) times in \(time/3600) hours"
            debugPrint(messageString)
        case 15:
            //SP_PLANET
            let planetID = Int(data[1])
            let owner = Int(data[2])
            let info = Int(data[3])
            let flags = data.subdata(in: (4..<6)).to(type: UInt16.self).byteSwapped
            // pad
            // pad
            let armies = Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped)
            debugPrint("Received SP_PLANET 15 planetID \(planetID) owner \(owner) info \(info) flags \(flags) armies \(armies)")
            guard let planet = universe.planets[planetID] else {
                debugPrint("ERROR: invalid planetID \(planetID)")
                return
            }
            planet.update(owner: owner, info: info, flags: flags, armies: armies)
            
        case 16:
            // SP_PICKOK
            let state = Int(data[1]) // 0 = no, 1 = yes
            //pad2
            //pad3
            debugPrint("Received SP_PICKOK 16 state: \(state)")
            if state == 1 {
                appDelegate.newGameState(.gameActive)
            }
            if state == 0 {
                debugPrint("Server rejected that choice, pick a different fleet or ship")
            }

        case 17:
            debugPrint("Received SP_LOGIN 17")
            // SP_LOGIN
            let accept = Int(data[1])
            let paradise1 = Int(data[2])
            let paradise2 = Int(data[3])
            let flags = data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped
            let keymap = data.subdata(in: (8..<96))
            
            if paradise1 == 69 && paradise2 == 42 {
                debugPrint("paradise server not supported")
                appDelegate.newGameState(.noServerSelected)
            }
            if accept == 0 {   // login failed
                debugPrint("login failed")
                appDelegate.newGameState(.noServerSelected)
            } else {
                appDelegate.newGameState(.loginAccepted)
            }
            //printData(data, success: true)

        case 18:
            //SP_FLAGS 18
            let playerID = Int(data[1])
            let tractor = Int(data[2])
            let flags = data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped

            debugPrint("Received SP_FLAGS 18 playerID \(playerID) tractor \(tractor) flags \(flags)")

            guard let player = universe.players[playerID] else {
                debugPrint("PacketAnalyzer type 18 invalid player id \(playerID)")
                printData(data, success: false)

                return
            }
            player.update(tractor: tractor, flags: flags)
            //debugPrint(player)
            //printData(data, success: true)

        case 19:
            //TODO process mask  Tournament mode mask
            //SP_MASK
            let mask = UInt8(data[1])
            DispatchQueue.main.async {
                self.appDelegate.updateTeamMenu(mask: mask)
            }
            // pad2
            // pad3
            debugPrint("Received SP_MASK 19 mask \(mask)")
        case 20:
            // SP_PSTATUS
            let playerID = Int(data[1])
            let status = Int(data[2])
            guard let player = universe.players[playerID] else {
                debugPrint("PacketAnalyzer type 20 invalid player id \(playerID)")
                printData(data, success: false)
                return
            }
            debugPrint("Received SP_PSTATUS 20 playerID \(playerID) status \(status)")
            player.update(sp_pstatus: status)
            //player.status = Int(status)
            //debugPrint(player)
            //printData(data, success: true)
        case 21: //SP_BADVERSION
            let why = UInt8(data[2])
            debugPrint("Received SP_BADVERSION 21 reason: \(why)")

        case 22:
            debugPrint("Received SP_HOSTILE 22")
            let playerID = Int(data[1])
            let war = UInt32(data[2])
            let hostile = UInt32(data[3])
            debugPrint("Received SP_HOSTILE 22 playerID \(playerID) war \(war) hostile \(hostile)")
            universe.updatePlayer(playerID: playerID, war: war, hostile: hostile)
            
        case 23:
            // SP_STATS 23
            let playerID = Int(data[1])
            // pad1
            // pad2
            let tournamentKills = Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped)
            let tournamentLosses = Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped)
            let overallKills = Int(data.subdata(in: (12..<16)).to(type: UInt32.self).byteSwapped)
            let overallLosses = Int(data.subdata(in: (16..<20)).to(type: UInt32.self).byteSwapped)
            let tournamentTicks = Int(data.subdata(in: (20..<24)).to(type: UInt32.self).byteSwapped)
            let tournamentPlanets = Int(data.subdata(in: (24..<28)).to(type: UInt32.self).byteSwapped)
            let tournamentArmies = Int(data.subdata(in: (28..<32)).to(type: UInt32.self).byteSwapped)
            let starbaseKills = Int(data.subdata(in: (32..<36)).to(type: UInt32.self).byteSwapped)
            let starbaseLosses = Int(data.subdata(in: (36..<40)).to(type: UInt32.self).byteSwapped)
            let intramuralArmies = Int(data.subdata(in: (40..<44)).to(type: UInt32.self).byteSwapped)
            let intramuralPlanets = Int(data.subdata(in: (44..<48)).to(type: UInt32.self).byteSwapped)
            let maxKills100 = Int(data.subdata(in: (48..<52)).to(type: UInt32.self).byteSwapped)
            let starbaseMaxKills100 = Int(data.subdata(in: (52..<56)).to(type: UInt32.self).byteSwapped)
            let maxKills = Double(maxKills100) / 100.0
            let starbaseMaxKills = Double(starbaseMaxKills100) / 100.0
            appDelegate.universe.updatePlayer(playerID: playerID, tournamentKills: tournamentKills, tournamentLosses: tournamentLosses, tournamentTicks: tournamentTicks, tournamentPlanets: tournamentPlanets, tournamentArmies: tournamentArmies)
            debugPrint("Received SP_STATS 23  tkills \(tournamentKills) tlosses \(tournamentLosses) overallKills \(overallKills) overallLosses \(overallLosses) tTicks \(tournamentTicks) tPlanets \(tournamentPlanets) tArmies \(tournamentArmies) sbKills \(starbaseKills) sbLosses \(starbaseLosses) intramuralArmies \(intramuralArmies) intramuralPlanets \(intramuralPlanets) maxKills \(maxKills) starbaseMaxKills \(starbaseMaxKills)")
            //TODO need to process this data
        case 24:
            debugPrint("Received SP_PL_LOGIN 24")
            //plyr_long_spacket SP_PL_LOGIN
            // new player logged in
            let playerID = Int(data[1])
            let rank = Int(data[2])
            let nameData = data.subdata(in: (4..<20))
            var name = "unknown"
            if let nameStringWithNulls = String(data: nameData, encoding: .utf8) {
                name = nameStringWithNulls.filter { $0 != "\0" }
            }
            let monitorData = data.subdata(in: (20..<36))
            var monitor = "unknown"
            if let monitorStringWithNulls = String(data: monitorData, encoding: .utf8) {
                monitor = monitorStringWithNulls.filter { $0 != "\0" }
            }
            let loginData = data.subdata(in: (36..<52))
            var login = "unknown"
            if let loginStringWithNulls = String(data: loginData, encoding: .utf8) {
                login = loginStringWithNulls.filter { $0 != "\0" }
            }
            debugPrint("Received SP_PL_LOGIN 24 playerID: \(playerID) rank: \(rank) name: \(name) login: \(login)")
            universe.updatePlayer(playerID: playerID, rank: rank, name: name, login: login)
        /*case 25:
            // is reserved, but I got one on pickled.netrek.org
            break*/
        case 26:
            // SP_PLANET_LOC
            let planetID = Int(data[1])
            let positionX = NetrekMath.netrekX2GameX(Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped))
            let positionY = NetrekMath.netrekY2GameY(Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped))
            let nameData = data.subdata(in: (12..<28))
            var name = "unknown"
            if let nameStringWithNulls = String(data: nameData, encoding: .utf8) {
                name = nameStringWithNulls.filter { $0 != "\0" }
            }
            if name == "Romulus" {
                name = "Rome"
            }
            if name == "Klingus" {
                name = "Kazari"
            }
            if name == "Praxis" {
                name = "Prague"
            }
            universe.createPlanet(planetID: planetID, positionX: positionX, positionY: positionY, name: name)
            /*if let planet = universe.planets[planetID] {
                //debugPrint(planet)
            }*/
            debugPrint("Received SP_PLANET_LOC 26 name \(name) planetID \(planetID) positionX \(positionX) positionY \(positionY)")
            //printData(data, success: true)

        case 32:
            let version = Int(data[1])
            guard version == 98 else {
                debugPrint("Received SPGeneric 32 version \(version) discarding)")
                return
            }
            let repairTime = (data.subdata(in: (2..<4)).to(type: UInt16.self).byteSwapped)
            let pl_orbit = Int8(data[3])
            let gameup = (data.subdata(in: (4..<6)).to(type: UInt16.self).byteSwapped)
            let tournamentTeams = UInt8(data[6])
            let tournamentAge = UInt8(data[7])
            let tournamentUnits = UInt8(data[8])
            let tournamentRemain = UInt8(data[9])
            let tournamentRemainUnits = UInt8(data[10])
            let starbaseRemain = UInt8(data[11]) //starbase reconstruction in minutes
            let teamRemain = UInt8(data[12]) // team surrender time
            // 18 bytes padding
            debugPrint("Received SP_GENERIC 32 version \(version) repairTime \(repairTime) orbit \(pl_orbit) and other stuff all discarded")
            // 26 bytes of unused padding
        case 39:
            // SP_SHIP_CAP
            let operation = UInt8(data[1])  // /* 0 = add/change a ship, 1 = remove a ship */
            let shipType = Int(data.subdata(in: (2..<4)).to(type: UInt16.self).byteSwapped)
            let torpSpeed = Int(data.subdata(in: (4..<6)).to(type: UInt16.self).byteSwapped)
            let phaserRange = Int(data.subdata(in: (6..<8)).to(type: UInt16.self).byteSwapped)
            let maxSpeed = Int(data.subdata(in: (8..<12)).to(type: UInt32.self).byteSwapped)
            let maxFuel = Int(data.subdata(in: (12..<16)).to(type: UInt32.self).byteSwapped)
            let maxShield = Int(data.subdata(in: (16..<20)).to(type: UInt32.self).byteSwapped)
            let maxDamage = Int(data.subdata(in: (20..<24)).to(type: UInt32.self).byteSwapped)
            let maxWpnTmp = Int(data.subdata(in: (24..<28)).to(type: Int32.self).byteSwapped)
            let maxEngTmp = Int(data.subdata(in: (28..<32)).to(type: Int32.self).byteSwapped)
            let width = Int(data.subdata(in: (32..<34)).to(type: UInt16.self).byteSwapped)
            let height = Int(data.subdata(in: (34..<36)).to(type: UInt16.self).byteSwapped)
            let maxArmies = Int(data.subdata(in: (36..<38)).to(type: UInt16.self).byteSwapped)
            let letter = Character(UnicodeScalar(Int(data[38])) ?? "U")
            // pad 39
            let nameData = data.subdata(in: (40..<56))
            var shipName = "unknown"
            if let nameStringWithNulls = String(data: nameData, encoding: .utf8) {
                shipName = nameStringWithNulls.filter { $0 != "\0" }
            }
            let s_desig1 = UInt8(data[56])
            let s_desig2 = UInt8(data[57])
            let bitmap = (data.subdata(in: (58..<60)).to(type: UInt16.self).byteSwapped)
            debugPrint("Received SP_SHIP_CAP 39 operation \(operation) shipType \(shipType) torpSpeed \(torpSpeed) phaserRange \(phaserRange) maxSpeed \(maxSpeed) maxFuel \(maxFuel) maxShield \(maxShield) maxDamage \(maxDamage) maxWpnTmp \(maxWpnTmp) maxEngTmp \(maxEngTmp) width \(width) height \(height) maxArmies \(maxArmies) letter \(letter) shipName \(shipName) s_desig1 \(s_desig1) s_desig2 \(s_desig2) bitmap \(bitmap)")
            for ship in ShipType.allCases {
                if ship.rawValue == shipType {
                    appDelegate.universe.shipinfo(shipType: ship, torpSpeed: torpSpeed, phaserRange: phaserRange, maxSpeed: maxSpeed, maxFuel: maxFuel, maxShield: maxShield, maxDamage: maxDamage, maxWpnTmp: maxWpnTmp, maxEngTmp: maxEngTmp, width: width, height: height, maxArmies: maxArmies)

                }
            }
        case 60:
            var datacopy = data
            let feature_type = Character(UnicodeScalar(Int(data[1])) ?? "U") // expect C
            let arg1 = Int(data[2])
            let arg2 = Int(data[3])
            let value = Int(data.subdata(in: (4..<8)).to(type: UInt32.self).byteSwapped)
            var features: [String] = []
            var newString: String = ""
            var newStringValid = false
            for index in 8 ..< 88 {  // feature packet size better be 88
                if data[index] != 0 {
                    if let unicodeScalar = UnicodeScalar(Int(data[index])) {
                        let char = Character(unicodeScalar)
                        newStringValid = true
                        newString.append(char)
                    }
                } else {
                    if newStringValid == true {
                        features.append(newString)
                        newString = ""
                        newStringValid = false
                    }
                }
            }
            if features.count > 0 {
                for feature in features {
                    debugPrint("Received SP_FEATURE 60 \(feature)")
                }
            } else {
                debugPrint("Received SP_FEATURE 60 empty")
            }
            appDelegate.serverFeatures = appDelegate.serverFeatures + features

        default:
            debugPrint("Default case: Received packet type \(packetType) length \(packetLength)\n")
            printData(data, success: true)

        }
    }
    func printFlags(flags: UInt32) {
        var flags = flags
        for bit in 0..<32 {
            let thisFlag = flags & 0x01
            debugPrint("bit \(bit) flag \(thisFlag)\n")
            flags = flags >> 1
        }
    }
}
