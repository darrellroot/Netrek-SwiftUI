//
//  ContentView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var metaServer: MetaServer
    @ObservedObject var universe: Universe
    @ObservedObject var appDelegate: AppDelegate
    @State var displayHelp = false
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var body: some View {
        switch (appDelegate.gameState, universe.players[universe.me].slotStatus, displayHelp) {
        case (.noServerSelected,_,true):
            return AnyView(HowToPlayView(displayHelp: $displayHelp))
        case (.noServerSelected,_,_):
            return AnyView(PickServerView(metaServer: metaServer, universe: universe,displayHelp: $displayHelp))
        case (.serverSelected,_,_):
            return AnyView(ServerSelectedView(appDelegate: appDelegate, server: appDelegate.reader?.hostname ?? "unknown"))
        case (.serverConnected,_,_):
            return AnyView(Text("Server Connected"))
        case (.serverSlotFound,_,_):
            return AnyView(Text("Server Slot Found"))
        case (.loginAccepted,.explode,_):
            return AnyView(TacticalHudView(universe: universe, help: appDelegate.help))
        case (.loginAccepted,_,_):
            return AnyView(SelectTeamView(eligibleTeams: self.appDelegate.eligibleTeams, universe: universe))
        case (.gameActive,_,_):
            return AnyView(TacticalHudView(universe: universe, help: appDelegate.help))
        default:
            return AnyView(Text("Unexpected Error"))
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
