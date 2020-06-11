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
    @State var launching = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Select Server")
                }.onTapGesture {
                    self.appDelegate.newGameState(.noServerSelected)
                }
                Spacer()
                Text("Currently Selected Team: \(eligibleTeams.preferredTeam.description)")
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
                self.launching ? Text("Launching...").font(.title).foregroundColor(Color.red) : Text("")
            }
            Spacer()
            HStack {
                
                VStack(alignment: .leading) {
                    Text("Select Team Federation \(universe.federationPlayers) Players")
                        .fontWeight(eligibleTeams.fedEligible ? .bold : .regular)
                        .onTapGesture {
                            self.eligibleTeams.preferredTeam = .federation
                    }
                    Text("Select Team Roman \(universe.romanPlayers) Players")
                        .fontWeight(eligibleTeams.romEligible ? .bold : .regular)
                        .padding(8)
                        .onTapGesture {
                            self.eligibleTeams.preferredTeam = .roman
                    }
                    Text("Select Team Kazari \(universe.kazariPlayers) Players")
                        .fontWeight(eligibleTeams.kazariEligible ? .bold : .regular)
                        .padding(8)
                        .onTapGesture {
                            self.eligibleTeams.preferredTeam = .kazari
                    }
                    Text("Select Team Ori \(universe.orionPlayers) Players")
                        .fontWeight(eligibleTeams.oriEligible ? .bold : .regular)
                        .padding(8)
                        .onTapGesture {
                            self.eligibleTeams.preferredTeam = .orion
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Launch Scout")
                        .padding(8)
                        .onTapGesture {
                            self.launching = true
                            self.appDelegate.selectShip(ship: .scout)
                    }
                    Text("Launch Destroyer")
                        .padding(8)
                        .onTapGesture {
                            self.launching = true
                            self.appDelegate.selectShip(ship: .destroyer)
                    }
                    Text("Launch Cruiser")
                        .padding(8)
                        .onTapGesture {
                            self.launching = true
                            self.appDelegate.selectShip(ship: .cruiser)
                    }
                    
                    Text("Launch Battleship")
                        .padding(8)
                        .onTapGesture {
                            self.launching = true
                            self.appDelegate.selectShip(ship: .battleship)
                    }
                    
                    Text("Launch Assault Ship")
                        .padding(8)
                        .onTapGesture {
                            self.launching = true
                            self.appDelegate.selectShip(ship: .assault)
                    }
                    
                }//VStack launch ship
                    .font(.title)
                
            }// HStack
                
                .font(.title)
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    ForEach(self.universe.recentMessages, id: \.self) { message in
                        Text(message)
                            .font(.headline)
                    }
                }
                Spacer()
            }
        }.padding()
    }
}

/*struct SelectTeamView_Previews: PreviewProvider {
 static var previews: some View {
 SelectTeamView()
 }
 }*/
