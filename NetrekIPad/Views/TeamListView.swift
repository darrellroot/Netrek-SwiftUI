//
//  TeamListView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TeamListView: View {
    @ObservedObject var universe: Universe
    
    var body: some View {
        VStack {
            Spacer()
            ForEach(self.universe.allPlayers, id: \.playerId) { player in
                HStack {
                    Text("\(NetrekMath.teamLetter(team: player.team))\(NetrekMath.playerLetter(playerId: player.playerId))")
                    Text("                ").overlay(Text(player.name))
                    //Text(player.name)
                    Text("               ").overlay(Text(player.rank.description))
                    //Text(player.rank.description)
                    Text(player.ship?.description ?? "??")
                    Text("Kills \(player.kills,specifier: "%.2f")")
                }
                .font(.system(.body, design: .monospaced))
                .border(NetrekMath.color(team: player.team), width: player === self.universe.players[self.universe.me] ? 1 : 0)
                    
                //player === universe.players[me] ? .fontWeight(.bold) : .fontWeight(.regular)
                    
                .foregroundColor(NetrekMath.color(team: player.team))
            }
        }
    }
}

/*struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
    }
}*/
