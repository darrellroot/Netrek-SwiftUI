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
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var body: some View {
        switch appDelegate.gameState {
        case .noServerSelected:
            return AnyView(PickServerView(metaServer: metaServer, universe: universe))
        case .serverSelected:
            return AnyView(Text("Server Selected"))
        case .serverConnected:
            return AnyView(Text("Server Connected"))
        case .serverSlotFound:
            return AnyView(Text("Server Slot Found"))
        case .loginAccepted:
            return AnyView(SelectTeamView(eligibleTeams: self.appDelegate.eligibleTeams, universe: universe))
        case .gameActive:
            return AnyView(TacticalView(universe: universe, help: appDelegate.help))
        default:
            return AnyView(Text("not implemented"))
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
