//
//  EligibleTeams.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation
import SwiftUI

class EligibleTeams: ObservableObject {
    @Published var fedEligible = true
    @Published var romEligible = true
    @Published var kazariEligible = true
    @Published var oriEligible = true
    @Published var preferredTeam: Team = .federation
    var initialTeamSet = false
    
    public func updateEligibleTeams(mask: UInt8) {
        if mask & UInt8(Team.federation.rawValue) != 0 {
            self.fedEligible = true
        } else {
            self.fedEligible = false
        }
        if mask & UInt8(Team.roman.rawValue) != 0 {
            self.romEligible = true
        } else {
            self.romEligible = false
        }
        if mask & UInt8(Team.kazari.rawValue) != 0 {
            self.kazariEligible = true
        } else {
            self.kazariEligible = false
        }
        if mask & UInt8(Team.orion.rawValue) != 0 {
            self.oriEligible = true
        } else {
            oriEligible = false
        }
        if !self.initialTeamSet && mask != 0 {
            debugPrint("initial team set")
            if fedEligible {
                self.preferredTeam = .federation
                self.initialTeamSet = true
                return
            }
            if romEligible {
                self.preferredTeam = .roman
                self.initialTeamSet = true
                return
            }
            if kazariEligible {
                self.preferredTeam = .kazari
                self.initialTeamSet = true
                return
            }
            if oriEligible {
                self.preferredTeam = .orion
                self.initialTeamSet = true
                return
            }
        }

    }
}
