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
    var initialTeamSet = false
    var preferredTeam: Team = .federation
    var preferredShip: ShipType = .cruiser
    let loginInformationController = LoginInformationController()
    let timerInterval = 1.0 / Double(UPDATE_RATE)
    var timer: Timer?
    var timerCount = 0
    var keymapController = KeymapController()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("Refresh Server List") {
                Button(action: {}) {
                    Text("Refresh from http://metaserver.netrek.org:3521")
                }
            }
            CommandMenu("Select Sever") {
                Button(action: {}) {
                    Text("pickled.netrek.org")
                }
            }
        }
    }
}
