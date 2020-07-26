//
//  DetailedStatisticsView.swift
//  Netrek
//
//  Created by Darrell Root on 7/3/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct DetailedStatisticsView: View {
    @ObservedObject var universe = Universe.universe
    var body: some View {
        VStack {
            HStack {
                Group {
                    Text("             ").overlay(Text("Name")).fixedSize()
                    Text("          ").overlay(Text("Rank")).fixedSize()
                    Text("Kills").fixedSize()
                    VStack {
                        Text("Max")
                        Text("Kills")
                    }.fixedSize()
                    VStack {
                        Text("T")
                        Text("Kills")
                    }.fixedSize()
                    VStack {
                        Text("T")
                        Text("Losses")
                    }.fixedSize()
                    VStack {
                        Text("T")
                        Text("Planets")
                    }.fixedSize()
                    VStack {
                        Text("T")
                        Text("Armies")
                    }.fixedSize()
                }
                Group {
                    VStack {
                        Text("Overall")
                        Text("Kills")
                    }.fixedSize()
                    VStack {
                        Text("Overall")
                        Text("Losses")
                    }.fixedSize()
                    VStack {
                        Text("Practice")
                        Text("Planets")
                    }.fixedSize()
                    VStack {
                        Text("Practice")
                        Text("Armies")
                    }.fixedSize()
                    VStack {
                        Text("SB")
                        Text("Kills")
                    }.fixedSize()
                    VStack {
                        Text("SB")
                        Text("Losses")
                    }.fixedSize()
                    VStack {
                        Text("SB")
                        Text("MaxKills")
                    }.fixedSize()
                }
            }
            ForEach(universe.activePlayers, id: \.playerId) { player in
                HStack {
                    Group {
                        Text("            ").overlay(Text(player.name)).fixedSize()
                        Text("           ").overlay(Text(player.rank.description)).fixedSize()
                        Text("     ").overlay(Text("\(player.kills,specifier: "%.2f")")).fixedSize()
                        Text("      ").overlay(Text("\(player.maxKills,specifier: "%.2f")")).fixedSize()
                        Text("     ").overlay(Text("\(player.tournamentKills)")).fixedSize()
                        Text("      ").overlay(Text("\(player.tournamentLosses)")).fixedSize()
                        Text("       ").overlay(Text("\(player.tournamentPlanets)")).fixedSize()
                        Text("      ").overlay(Text("\(player.tournamentArmies)")).fixedSize()
                    }
                    Group {
                        Text("       ").overlay(Text("\(player.overallKills)")).fixedSize()
                        Text("       ").overlay(Text("\(player.overallLosses)")).fixedSize()
                        Text("        ").overlay(Text("\(player.practicePlanets)")).fixedSize()
                        Text("        ").overlay(Text("\(player.practiceArmies)")).fixedSize()
                        Text("     ").overlay(Text("\(player.starbaseKills)")).fixedSize()
                        Text("      ").overlay(Text("\(player.starbaseLosses)")).fixedSize()
                        Text("        ").overlay(Text("\(player.sbMaxKills,specifier: "%.2f")")).fixedSize()
                    }

                    //Text("\(player.starbaseKills)")
                    //Text("\(player.starbaseLosses)")
                }.foregroundColor(NetrekMath.color(team: player.team))
            }
        }.font(.system(.body, design: .monospaced))
        .padding(10)
    }
}

struct DetailedStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedStatisticsView(universe: Universe())
    }
}
