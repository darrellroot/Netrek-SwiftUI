//
//  SelectTeamView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct SelectTeamView: View {
    @ObservedObject var eligibleTeams: EligibleTeams
    @ObservedObject var universe: Universe
    
    var body: some View {
        VStack {
            Text("Currently Selected Team: \(eligibleTeams.preferredTeam.description)")
            Spacer()
            Text("Select Team Federation \(universe.federationPlayers) Players")
                .onTapGesture {
                    self.eligibleTeams.preferredTeam = .federation
            }
            Text("Select Team Roman \(universe.romanPlayers) Players")
                .onTapGesture {
                    self.eligibleTeams.preferredTeam = .roman
            }
            Text("Select Team Kazari \(universe.kazariPlayers) Players")
                .onTapGesture {
                    self.eligibleTeams.preferredTeam = .kazari
            }
            Text("Select Team Ori \(universe.orionPlayers) Players")
                .onTapGesture {
                    self.eligibleTeams.preferredTeam = .orion
            }
            Spacer()
        }
    }
}

/*struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView()
    }
}*/
