//
//  MetaServerEntry.swift
//  Netrek
//
//  Created by Darrell Root on 3/1/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

/*
 @"OPEN:",
 @"Wait queue:",
 @"Nobody",
 @"Timed out",
 @"No connection",
 @"Active",
 @"CANNOT CONNECT",
 @"DEFAULT SERVER",
 @"Flooding",
 Darrell-Roots-Potato:Netrek droot$ telnet metaserver.netrek.org 3521
 Trying 63.170.91.110...
 Connected to metaserver.netrek.org.
 Escape character is '^]'.
 
 *** Connected to MetaServerII v1.0.3 on port 3521 ***
 Date in Earth is Fri Mar  1 17:32:34 2019 (data spans 79 days)
 E-mail administrative requests to quozl at us dot netrek dot org.
 
 Retry periods (in minutes):  down:30 empty:15 open:5 queue:10
 
 Other interesting MetaServerII ports:  3522 1080
 
 Mins
 Server Host                             Port     Ago  Status            Flags
 --------------------------------------- -------- ---- ----------------- -------
 -h netrek.beeseenterprises.com          -p 2592    2  Nobody playing    T     S
 -h pickled.netrek.org                   -p 2592    0  OPEN: 1 player          B
 
 That's it!
 Connection closed by foreign host.
*/
enum MetaServerStatus: String, CaseIterable {
    case open
    case waitQueue
    case nobody
    case timedOut
    case noConnection
    case active
    case cannotDetect
    case defaultServer
    case flooding
}
enum MetaServerType: String, CaseIterable {
    case bronco = "B"
    case chaos = "C"
    case paradise = "P"
    case hockey = "H"
    case other = "O"
    case blessed = "R"
    case dead = "D"
    case tournament = "T"
    case sturgeon = "S"
}

class MetaServerEntry: CustomStringConvertible {
    var hostname: String
    var port: Int
    var type: MetaServerType
    var age: Int
    var players: Int
    
    var description: String {
        return "\(hostname) port:\(port) type:\(type) \(players) players"
    }
    
    init(hostname: String, port: Int, age: Int, players: Int, type: MetaServerType) {
        self.hostname = hostname
        self.port = port
        self.type = type
        self.age = age
        self.players = players
    }
    func update(status: MetaServerStatus, age: Int, players: Int) {
        self.age = age
        self.players = players
    }
}
