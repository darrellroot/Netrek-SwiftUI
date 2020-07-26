//
//  ContentView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var serverUpdate = Universe.universe.serverUpdate
    @ObservedObject var metaServer: MetaServer
    @ObservedObject var universe: Universe
    @ObservedObject var appDelegate: AppDelegate
    @State var displayHelp = false
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var body: some View {
        switch (appDelegate.gameScreen, universe.players[universe.me].slotStatus) {
        case (.howToPlay,_):
            return AnyView(HowToPlayView())
        case (.credits,_):
            return AnyView(CreditsView(appDelegate: appDelegate))
        case (.preferences,_):
            return AnyView(LoginView(loginName: appDelegate.loginInformationController.loginName,loginPassword: appDelegate.loginInformationController.loginPassword, userInfo: appDelegate.loginInformationController.userInfo, loginInformationController: appDelegate.loginInformationController))
        case (.noServerSelected,_):
            return AnyView(PickServerView(metaServer: metaServer, universe: universe))
        case (.serverSelected,_):
            return AnyView(ServerSelectedView(appDelegate: appDelegate, server: appDelegate.reader?.hostname ?? "unknown"))
        case (.serverConnected,_):
            return AnyView(ServerConnectedView(appDelegate: appDelegate, universe: universe))
        case (.serverSlotFound,_):
            return AnyView(ServerSlotView(appDelegate: appDelegate))
        case (.loginAccepted,.explode):
            return AnyView(TacticalHudView(universe: universe, me: universe.players[universe.me], help: appDelegate.help))
        case (.loginAccepted,_):
            return AnyView(SelectTeamView(eligibleTeams: self.appDelegate.eligibleTeams, universe: universe))
        case (.gameActive,_):
            return AnyView(TacticalHudView(universe: universe, me: universe.players[universe.me],help: appDelegate.help))
        //default:
            //return AnyView(Text("Unexpected Error"))
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
