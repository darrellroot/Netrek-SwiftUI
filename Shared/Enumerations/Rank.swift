//
//  Rank.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

enum Rank: Int, CaseIterable {
    case ensign = 0
    case lieutenant = 1
    case ltCmdr = 2
    case commander = 3
    case captain = 4
    case fleetCapt = 5
    case commodore = 6
    case rearAdm = 7
    case admiral = 8
    
    var description: String {
        switch self {
            
        case .ensign:
            return "Ensign"
        case .lieutenant:
            return "Lieutenant"
        case .ltCmdr:
            return "Lt. Cmdr."
        case .commander:
            return "Commander"
        case .captain:
            return "Captain"
        case .fleetCapt:
            return "Flt. Capt."
        case .commodore:
            return "Commodore"
        case .rearAdm:
            return "Rear Adm."
        case .admiral:
            return "Admiral"
        }
        
    }
}
