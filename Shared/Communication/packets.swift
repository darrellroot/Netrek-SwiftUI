//
//  packets.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

// could not get to align on byte boundaries ok
// had to import from C packets.h
/*struct CP_LOGIN {
 let type: UInt8 = 8
 let query: UInt8 = 1 // 0 means something
 let pad: UInt8 = 0
 let pad2: UInt8 = 0
 var name: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8 = NAME_LEN
 var password: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8
 var login: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8
 
 //var name = Data(count: NAME_LEN)
 //var password = Data(count: NAME_LEN)
 //var login = Data(count: NAME_LEN)
 var size: Int {
 return 52
 }
 }*/

struct CP_MESSAGE {
    let type: UInt8 = 1
    var group: UInt8 = 0
    var indiv: UInt8 = 0
    let pad1: UInt8 = 0
    var mesg: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
        UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
        UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
        UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
        UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) =
        (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

    var size: Int {
        return 84
    }
}

struct CP_SPEED {
    let type: UInt8 = 2
    var speed: UInt8 = 0
    var pad1: UInt8 = 0
    var pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_DIRECTION {
    let type: UInt8 = 3
    var direction: UInt8 = 0
    var pad1: UInt8 = 0
    var pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_LASER {
    let type: UInt8 = 4
    var netrekDirection: UInt8 = 0
    let pad1 = 0
    let pad2 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_PLASMA {
    let type: UInt8 = 5
    var netrekDirection: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}
struct CP_TORP {
    let type: UInt8 = 6
    var netrekDirection: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_QUIT {
    let type: UInt8 = 7
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

// CP_LOGIN 8 is in packets.h due to array
struct CP_LOGIN {
    let type: UInt8 = 8
    var query: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    var name: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    var password: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    var login: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    var size: Int {
        return 52
    }
}

struct CP_OUTFIT {
    let type: UInt8 = 9
    var team: UInt8 = 0
    var ship: UInt8 = 0
    let pad1: UInt8 = 0
    init(team: Team, ship: ShipType) {
        // menu option for independent and ogg does not exist.  Server only accepts 0-3, but it is inconsistent which team you get
        switch team {
            
        case .independent:
            self.team = 255
        case .federation:
            self.team = 0
        case .roman:
            self.team = 1
        case .kazari:
            self.team = 2
        case .orion:
            self.team = 3
        case .ogg:
            self.team = 255
        }
        //self.team = UInt8(team.rawValue)
        self.ship = UInt8(ship.rawValue)
        debugPrint("CP_OUTFIT \(self.type) \(self.team) \(self.ship) \(self.pad1)")
    }
    var size: Int {
        get {
            return 4
        }
    }
}

// CP_WAR 10 not implemented

struct CP_PRACTR {
    let type: UInt8 = 11
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    
    var size: Int {
        get {
            return 4
        }
    }
}

struct CP_SHIELD {
    let type: UInt8 = 12
    var state: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_REPAIR {
    let type: UInt8 = 13
    var state: UInt8 = 0  // on/off
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_ORBIT {
    let type: UInt8 = 14
    var state: UInt8 = 0  // on/off
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_PLANLOCK {
    let type: UInt8 = 15
    var planetID: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_PLAYLOCK {
    let type: UInt8 = 16
    var playerID: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_BOMB {
    let type: UInt8 = 17
    var state: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_BEAM {
    let type: UInt8 = 18
    var state: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_CLOAK {
    let type: UInt8 = 19
    var state: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_DET_TORPS {
    let type: UInt8 = 20
    var pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_DET_MYTORP {
    let type: UInt8 = 21
    var pad1: UInt8 = 0
    var tNumByte1: UInt8 = 0
    var tNumByte2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

// 22 copilot not implemented

struct CP_REFIT {
    let type: UInt8 = 23
    var ship: UInt8 = 0
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_TRACTOR {
    let type: UInt8 = 24
    var state: UInt8 = 0
    var playerID: UInt8 = 0
    var pad: UInt8 = 0
    
    var size: Int {
        return 4
    }
}
struct CP_REPRESS {
    let type: UInt8 = 25
    var state: UInt8 = 0
    var playerID: UInt8 = 0
    var pad: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_COUP {
    let type: UInt8 = 26
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    
    var size: Int {
        return 4
    }
}
struct CP_SOCKET {
    let type: UInt8 = 27
    let version: UInt8 = SOCKVERSION
    let udp_version: UInt8 = UDPVERSION
    let pad: UInt8 = 0
    //TODO: presumably we have to do something with this port
    let port: UInt32 = UInt32(32800).bigEndian
    
    var size: Int {
        return 8
    }
}

// 28 CP_OPTIONS not implamented

struct CP_BYE {
    let type: UInt8 = 29
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_DOCKPERM {
    let type: UInt8 = 30
    var state: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    
    var size: Int {
        return 4
    }
}

struct CP_UPDATES {
    let type: UInt8 = 31
    let pad1: UInt8 = 0
    let pad2: UInt8 = 0
    let pad3: UInt8 = 0
    let usecs: UInt32 = UInt32(100000).bigEndian
    
    var size: Int {
        return 8
    }
}

struct CP_FEATURE {
    let type: UInt8 = 60
    var feature_type: UInt8 = 0
    var arg1: UInt8 = 0
    var arg2: UInt8 = 0
    var value: UInt32 = 0
    var name:(UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
    UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
    UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
    UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,
    UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) =
    (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    var size: Int {
        return 88
    }
}

/* does not work but valiant attempt
struct CP_FEATURE {
    let type: UInt8 = 60
    let featureType: UInt8 = UInt8(ascii: "C")
    let arg1: UInt8 = 0
    let arg2: UInt8 = 0
    let value: UInt32
    var data = Data(count: 80)
    var size: Int {
        return 88
    }
    init(features: [String]) {
        debugPrint("data size \(MemoryLayout.size(ofValue:data))")
        debugPrint("data stride \(MemoryLayout.stride(ofValue:data))")
        debugPrint("data alignment \(MemoryLayout.alignment(ofValue:data))")

        value = UInt32(features.count).bigEndian
        var count = 0
        for feature in features {
            //do we have enough space remaining
            //for next feature
            if count + feature.count + 1 >= 80 {
                debugPrint("CP_FEATURE.init: Warning: Feature packet size exceeded")
                for _ in count..<80 {
                    data[count] = 0
                    count = count + 1
                }
                return
            }
            let feature = feature.utf8
            for char in feature {
                data[count] = char
                count = count + 1
            }
            data[count] = 0
            count = count + 1
        }
        // all features successfully added and null terminated.  now pad to 80
        for _ in count..<80 {
            data[count] = 0
            count = count + 1
        }
        return
    }
 }
 */
