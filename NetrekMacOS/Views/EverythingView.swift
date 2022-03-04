//
//  EverythingView.swift
//  Netrek
//
//  Created by Darrell Root on 3/4/22.
//  Copyright © 2022 Darrell Root. All rights reserved.
//

import SwiftUI

struct EverythingView: View {
    @ObservedObject var help: Help
    @ObservedObject var universe = Universe.universe
    @ObservedObject var preferencesController: PreferencesController


    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 0) {
                    TacticalView(help: help, preferencesController: preferencesController)
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                        .border(universe.players[Universe.universe.me].alertCondition.color, width: 10).opacity(0.5)
                    StrategicView()
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                }
                CommunicationsView()
                    .frame(width: geo.size.width, height: geo.size.width * 0.6)
            }
        }
    }
}

/*struct EverythingView_Previews: PreviewProvider {
    static var previews: some View {
        EverythingView()
    }
}*/
