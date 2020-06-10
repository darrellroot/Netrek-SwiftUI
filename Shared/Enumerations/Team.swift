//
//  Team.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

// teams_numeric = {IND: -1, FED: 0, ROM: 1, KLI: 2, ORI: 3} for joining games

enum Team: Int, CaseIterable {
    case independent = 0
    case federation = 1
    case roman = 2
    case kazari = 4
    case orion = 8
    case ogg = 15
    
    var description: String {
        switch self {
            
        case .independent:
            return "Independent"
        case .federation:
            return "Federation"
        case .roman:
            return "Roman"
        case .kazari:
            return "Kazari"
        case .orion:
            return "Orion"
        case .ogg:
            return "Ogg"
        }
    }
    var letter: String {
        switch self {
        case .independent:
            return "I"
        case .federation:
            return "F"
        case .roman:
            return "R"
        case .kazari:
            return "K"
        case .orion:
            return "O"
        case .ogg:
            return "I"
        }
    }
}
