//
//  BottomView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct CommunicationsView: View {
    @ObservedObject var universe = Universe.universe
    @FocusState var textFieldFocused


    var body: some View {
        HStack {
            StatisticsView(universe: universe, me: universe.players[universe.me])
            MessagesView(universe: universe, textFieldFocused: _textFieldFocused)
        }.frame(minWidth: 1000)
    }
}

/*struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView()
    }
}*/
