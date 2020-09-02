//
//  Netrek3App.swift
//  Netrek3
//
//  Created by Darrell Root on 8/23/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

@main
struct Netrek3App: App {
    let universe = Universe.universe
    let help = Help()
    let defaults = UserDefaults.standard
    let preferencesController = PreferencesController(defaults: UserDefaults.standard)
    var serverFeatures: [String] = []
    var clientFeatures: [String] = ["FEATURE_PACKETS","SHIP_CAP","SP_GENERIC_32","TIPS"]
    //var metaServer: MetaServer?
    //var reader: TcpReader?
    //var analyzer: PacketAnalyzer?
    //var clientTypeSent = false
    //var soundController: SoundController?
    var serverByTag: [Int:String] = [:]
    //set this to true when we first set the preferred team, which we only do once
    //var initialTeamSet = false
    //var preferredTeam: Team = .federation
    //var preferredShip: ShipType = .cruiser
    let loginInformationController = LoginInformationController()
    var keymapController = KeymapController()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("Refresh Server List") {
                Button(action: {
                    self.universe.refreshMetaserver()
                }) {
                    Text("Refresh from http://metaserver.netrek.org:3521")
                }
            }
            CommandMenu("Select Sever") {
                Button(action: {
                    connectToServer(server: "pickled.netrek.org")
                }) {
                    Text("pickled.netrek.org")
                }
            }
        }
    }
    
    public func connectToServer(server: String) {
        guard universe.gameState == .noServerSelected || universe.gameState == .serverSelected else {
            debugPrint("Can only connect if not connected")
            return
        }
        if let reader = TcpReader(hostname: server, port: 2592, delegate: universe) {
               universe.reader = reader
               universe.newGameState(.serverSelected)
           } else {
               debugPrint("\(#file) \(#function) failed to start reader")
           }
    }

}
