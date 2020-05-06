//
//  TacticalView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TacticalView: View {
    //@EnvironmentObject var universe: Universe
    @ObservedObject var universe: Universe
    //@ObservedObject var players: [Player] = universe.players.values
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0 ..< self.universe.maxPlanets) { planetId in
                    PlanetView(planet: self.universe.planets[planetId], me: self.universe.me)
                }
            }
        }.frame(minWidth: 500, idealWidth: 800, maxWidth: nil, minHeight: 500, idealHeight: 800, maxHeight: nil, alignment: .center)
    }
}
//.offset(x: CGFloat(Int.random(in: -200 ..< 200)), y: CGFloat(Int.random(in: -200 ..< 200)))

/*struct TacticalView_Previews: PreviewProvider {
    static var previews: some View {
        TacticalView()
    }
}*/
