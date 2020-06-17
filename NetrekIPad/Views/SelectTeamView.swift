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
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass

    var bigText: Font {
        guard let vSizeClass = vSizeClass else {
            return Font.headline
        }
        switch vSizeClass {
        case .regular:
            return .title
        case .compact:
            return .headline
        }
    }
    var regularText: Font {
        guard let vSizeClass = vSizeClass else {
            return Font.body
        }
        switch vSizeClass {
            
        case .regular:
            return .headline
        case .compact:
            return Font.body
        }
    }

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Select Server")
                }.font(bigText)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.appDelegate.newGameState(.noServerSelected)
                }
                Spacer()
                Text("Server \(appDelegate.reader?.hostname ?? "unknown")")
                    .font(bigText)
                Spacer()
                Text("Currently Selected Team: \(eligibleTeams.preferredTeam.description)")
                    .fontWeight(.bold)
                    .font(bigText)
                Spacer()
            }
            Text(universe.selectionError)
                .font(bigText)
                .foregroundColor(Color.red)
            Spacer()
            HStack {
                List {
                //VStack(alignment: .leading) {
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
                }//Vstack select team
                    .foregroundColor(.blue)
                Spacer()
                List {
                //VStack(alignment: .leading) {
                    Text("Launch Scout")
                        .padding(8)
                        .onTapGesture {
                            self.universe.selectionError = "Launching \(self.eligibleTeams.preferredTeam) Scout"
                            self.appDelegate.selectShip(ship: .scout)
                    }
                    Text("Launch Destroyer")
                        .padding(8)
                        .onTapGesture {
                            self.universe.selectionError = "Launching \(self.eligibleTeams.preferredTeam) Destroyer"
                            self.appDelegate.selectShip(ship: .destroyer)
                    }
                    Text("Launch Cruiser")
                        .padding(8)
                        .onTapGesture {
                            self.universe.selectionError = "Launching \(self.eligibleTeams.preferredTeam) Cruiser"
                            self.appDelegate.selectShip(ship: .cruiser)
                    }
                    
                    Text("Launch Battleship")
                        .padding(8)
                        .onTapGesture {
                            self.universe.selectionError = "Launching \(self.eligibleTeams.preferredTeam) Battleship"
                            self.appDelegate.selectShip(ship: .battleship)
                    }
                    
                    Text("Launch Assault Ship")
                        .padding(8)
                        .onTapGesture {
                            self.universe.selectionError = "Launching \(self.eligibleTeams.preferredTeam) Assault Ship"
                            self.appDelegate.selectShip(ship: .assault)
                    }
                    
                }//VStack launch ship
                    .foregroundColor(.blue)
                    .font(bigText)
                    
                
            }// Top HStack
                
                .font(bigText)
            Spacer()
            HStack {
                ScrollView {
                    MessagesView(universe: universe)
                }
                Spacer()
                ScrollView {
                    HelpView(help: appDelegate.help)
                    Spacer()
                    TeamListView(universe: universe)
                }//Botom right Vstack
            }//bottom HStack
        }.padding()
            .onAppear {
                self.universe.selectionError = ""
        }
    }
}

/*struct SelectTeamView_Previews: PreviewProvider {
 static var previews: some View {
 SelectTeamView()
 }
 }*/
