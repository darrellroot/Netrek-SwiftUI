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
        VStack {
            HStack {
                Text("Speed \(me.speed)")
                Text("Armies \(me.armies)")
                Text("Fuel \(me.fuel)")
            }
            HStack {
                if me.tractorFlag { Text("Tractor") }
                if me.pressor { Text("Pressor")}
                if me.enginesOverheated { Text("EngineFail")}
            }
            ForEach(self.universe.players, id: \.playerId) { player in
                HStack {
                    Text("\(NetrekMath.teamLetter(team: player.team))\(NetrekMath.playerLetter(playerId: player.playerId))")
                }
            }
        }
    }
}

/*struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}*/
