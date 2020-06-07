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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var body: some View {
        VStack {
            Text("Currently Selected Team: \(eligibleTeams.preferredTeam.description)")
                .fontWeight(.bold)
                .font(.title)
            Spacer()
            VStack {
                Text("Select Team Federation \(universe.federationPlayers) Players")
                    .fontWeight(eligibleTeams.fedEligible ? .bold : .regular)
                    .onTapGesture {
                        self.eligibleTeams.preferredTeam = .federation
                }
                Text("Select Team Roman \(universe.romanPlayers) Players")
                    .fontWeight(eligibleTeams.romEligible ? .bold : .regular)
                    .onTapGesture {
                        self.eligibleTeams.preferredTeam = .roman
                }
                Text("Select Team Kazari \(universe.kazariPlayers) Players")
                    .fontWeight(eligibleTeams.kazariEligible ? .bold : .regular)
                    .onTapGesture {
                        self.eligibleTeams.preferredTeam = .kazari
                }
                Text("Select Team Ori \(universe.orionPlayers) Players")
                    .fontWeight(eligibleTeams.oriEligible ? .bold : .regular)
                    .onTapGesture {
                        self.eligibleTeams.preferredTeam = .orion
                }//VStack teams
                .font(.title)
            }
            Spacer()
            VStack {
                Text("Launch Scout")
                    .onTapGesture {
                        self.appDelegate.selectShip(ship: .scout)
                }
                Text("Launch Destroyer")
                        .onTapGesture {
                            self.appDelegate.selectShip(ship: .destroyer)
                    }
                Text("Launch Cruiser")
                    .onTapGesture {
                        self.appDelegate.selectShip(ship: .cruiser)
                }

                Text("Launch Battleship")
                    .onTapGesture {
                        self.appDelegate.selectShip(ship: .battleship)
                }

                Text("Launch Assault Ship")
                    .onTapGesture {
                        self.appDelegate.selectShip(ship: .assault)
                }

                Text("Launch Starbase")
                    .onTapGesture {
                        self.appDelegate.selectShip(ship: .starbase)
                }

            }//VStack launch ship
                .font(.title)
        }
    }
}

/*struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView()
    }
}*/
