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

    @ObservedObject var preferencesController: PreferencesController


    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 0) {
                    TacticalView(help: help, preferencesController: preferencesController)
                        .frame(width: geo.size.width / 2, height: geo.size.width / 2)
                    StrategicView()
                        .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                }
                CommunicationsView()
            }
        }
    }
}

/*struct EverythingView_Previews: PreviewProvider {
    static var previews: some View {
        EverythingView()
    }
}*/
