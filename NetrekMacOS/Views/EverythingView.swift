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
    @FocusState var textFieldFocused
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TacticalView(help: help, preferencesController: preferencesController)
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                        .border(universe.players[Universe.universe.me].alertCondition.color.opacity(0.5), width: 10)
                        .onTapGesture {
                            textFieldFocused = false
                        }
                        .clipped()

                    StrategicView()
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                        .border(universe.players[Universe.universe.me].alertCondition.color.opacity(0.5), width: 10)
                        .onTapGesture {
                            textFieldFocused = false
                        }
                        .clipped()
                }
                CommunicationsView(textFieldFocused: _textFieldFocused)
                    .frame(width: geo.size.width)
                    .border(universe.players[Universe.universe.me].alertCondition.color.opacity(0.5), width: 3)
                    .clipped()
            }
        }
    }
}

/*struct EverythingView_Previews: PreviewProvider {
    static var previews: some View {
        EverythingView()
    }
}*/
