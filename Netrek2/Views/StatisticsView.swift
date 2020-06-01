//
//  StatisticsView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var universe: Universe
    @ObservedObject var me: Player
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Speed \(me.speed)")
                Text("Shield \(me.shieldStrength)")
                Text("Damage \(me.damage)")
                Text("Armies \(me.armies)")
                Text("Fuel \(me.fuel)")
            }
            HStack {
                if me.tractorFlag { Text("Tractor") }
                if me.pressor { Text("Pressor")}
                if me.enginesOverheated { Text("EngineFail")}
            }
            ForEach(self.universe.activePlayers, id: \.playerId) { player in
                HStack {
                    Text("\(NetrekMath.teamLetter(team: player.team))\(NetrekMath.playerLetter(playerId: player.playerId))")
                    Text("                ").overlay(Text(player.name))
                    //Text(player.name)
                    Text("               ").overlay(Text(player.rank.description))
                    //Text(player.rank.description)
                    Text(player.ship?.description ?? "??")
                    Text("Kills \(player.kills,specifier: "%.2f")")
                }.padding(.leading)
                    .font(.system(.body, design: .monospaced))
                .foregroundColor(NetrekMath.color(team: player.team))
            }
            Spacer()
        }
    }
}

/*struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}*/
