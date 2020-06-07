//
//  AppDelegate.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
    
    let defaults = UserDefaults.standard
    
    let help = Help()
    
    var serverFeatures: [String] = []
    var clientFeatures: [String] = ["FEATURE_PACKETS","SHIP_CAP","SP_GENERIC_32","TIPS"]
    
    var metaServer: MetaServer = MetaServer(primary: "metaserver.netrek.org", backup:
        "metaserver.eu.netrek.org", port: 3521)!
    
    var reader: TcpReader?
    @Published private(set) var gameState: GameState = .noServerSelected
    var analyzer: PacketAnalyzer?
    @ObservedObject var universe = Universe()
    var clientTypeSent = false
    var soundController: SoundController?
    
    //set this to true when we first set the preferred team, which we only do once
    //var initialTeamSet = false
    
    @ObservedObject var eligibleTeams = EligibleTeams()
    
    let loginInformationController = LoginInformationController()
    
    let timerInterval = 1.0 / Double(UPDATE_RATE)
    var timer: Timer?
    @State var timerCount = 0
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //metaServer = MetaServer(hostname: "metaserver.netrek.org", port: 3521)
        metaServer.update()
        /*if let metaServer = metaServer {
         metaServer.update()
         }*/
        
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //MARK: METASERVER
    func refreshMetaserver() {
        metaServer.update()
    }
    
    func resetConnection() {
        debugPrint("AppDelegate.resetConnection")
        if gameState == .gameActive || gameState == .serverConnected || gameState == .serverSlotFound || gameState == .loginAccepted {
            let cp_bye = MakePacket.cpBye()
            self.reader?.send(content: cp_bye)
        }
        if self.reader != nil {
            self.reader?.resetConnection()
        }
        self.reader = nil
    }
    
    @objc func timerFired() {
        timerCount = timerCount + 1
        //debugPrint("AppDelegate.timerFired \(Date())")
        self.universe.objectWillChange.send()
        switch self.gameState {
            
        case .noServerSelected:
            break
        case .serverSelected:
            break
        case .serverConnected:
            break
        case .serverSlotFound:
            break
        case .loginAccepted:
            break
        case .gameActive:
            if (timerCount % 100) == 0 {
                debugPrint("Setting needs display for playerListViewController")
                // send cpUpdate once every 10 seconds to prevent ghostbust
                let cpUpdates = MakePacket.cpUpdates()
                reader?.send(content: cpUpdates)
            }
            break
        }
    }
    
    public func selectServer(hostname: String) -> Bool {
        guard gameState == .noServerSelected else {
            debugPrint("AppDelegate.selectServer: Error cannot select server \(hostname) while gameState is \(self.gameState)")
            return false
        }
        if let server = metaServer.servers[hostname] {
            debugPrint("starting game server \(server.description)")
            if reader != nil {
                self.resetConnection()
            }
            if let reader = TcpReader(hostname: server.hostname, port: server.port, delegate: self) {
                self.reader = reader
                self.newGameState(.serverSelected)
                return true
            } else {
                debugPrint("AppDelegate failed to start reader")
                return false
            }
        }
        return false
    }
    func selectShip(ship: ShipType) {
        self.eligibleTeams.preferredShip = ship
        if self.gameState == .loginAccepted {
            if let reader = self.reader {
                let cpUpdates = MakePacket.cpUpdates()
                    reader.send(content: cpUpdates)
                let cpOutfit = MakePacket.cpOutfit(team: self.eligibleTeams.preferredTeam, ship: self.eligibleTeams.preferredShip)
                reader.send(content: cpOutfit)
            }
        }
        if self.gameState == .gameActive {
            if let reader = self.reader {
                let cpRefit = MakePacket.cpRefit(newShip: self.eligibleTeams.preferredShip)
                reader.send(content: cpRefit)
            }
        }
    }

    public func newGameState(_ newState: GameState ) {
        debugPrint("Game State: moving from \(self.gameState.rawValue) to \(newState.rawValue)\n")
        switch newState {
            
            
        case .noServerSelected:
            self.resetConnection()
            help.nextTip()
            universe.reset()
            //enableServerMenu()
            //disableShipMenu()
            self.gameState = newState
            universe.gotMessage("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again\n")
            debugPrint("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again\n")
            self.refreshMetaserver()
            break
            
        case .serverSelected:
            help.nextTip()
            //disableShipMenu()
            //disableServerMenu()
            self.gameState = newState
            self.analyzer = PacketAnalyzer()
            // no need to do anything here, handled in the menu function
            break
            
        case .serverConnected:
            help.nextTip()
            //disableShipMenu()
            //disableServerMenu()
            self.clientTypeSent = false
            DispatchQueue.main.sync {
                self.gameState = newState
            }
            
            guard let reader = reader else {
                self.newGameState(.noServerSelected)
                return
            }
            let cpSocket = MakePacket.cpSocket()
            DispatchQueue.global(qos: .background).async{
                reader.send(content: cpSocket)
            }
            for feature in clientFeatures {
                let cpFeature: Data
                if feature == "SP_GENERIC_32" {
                    cpFeature = MakePacket.cpFeatures(feature: feature,arg1: 2)
                } else {
                    cpFeature = MakePacket.cpFeatures(feature: feature)
                }
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+0.1) {
                    self.reader?.send(content: cpFeature)
                }
            }
            
        case .serverSlotFound:
            //disableShipMenu()
            //disableServerMenu()
            self.gameState = newState
            debugPrint("AppDelegate.newGameState: .serverSlotFound")
            let cpLogin: Data
            if self.loginInformationController.loginAuthenticated == true && self.loginInformationController.validInfo {
                cpLogin = MakePacket.cpLogin(name: self.loginInformationController.loginName, password: self.loginInformationController.loginPassword, login: self.loginInformationController.loginUsername)
            } else {
                cpLogin = MakePacket.cpLogin(name: "guest", password: "", login: "")
            }
            if let reader = reader {
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
                    
                    reader.send(content: cpLogin)
                }
            } else {
                debugPrint("ERROR: AppDelegate.newGameState.serverSlot found: no reader")
                self.newGameState(.noServerSelected)
            }
            
        case .loginAccepted:
            help.nextTip()
            //self.enableShipMenu()
            //self.disableServerMenu()
            /*DispatchQueue.main.async {
             self.playerListViewController?.view.needsDisplay = true
             }*/
            self.gameState = newState
            
        case .gameActive:
            help.noTip()
            //self.enableShipMenu()
            //self.disableServerMenu()
            /*DispatchQueue.main.async {
             self.playerListViewController?.view.needsDisplay = true
             }*/
            self.gameState = newState
            if !clientTypeSent {
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
                let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
                let data = MakePacket.cpMessage(message: "I am using the Swift Netrek Client version \(appVersion) build \(buildVersion) on IPadOS", team: .ogg, individual: 0)
                clientTypeSent = true
                self.reader?.send(content: data)
            }
        }
    }
    
}

extension AppDelegate: NetworkDelegate {
    func gotData(data: Data, from: String, port: Int) {
        debugPrint("appdelegate got data \(data.count) bytes")
        //debugPrint("appdelegate data index \(data.startIndex) \(data.endIndex)")
        if data.count > 0 {
            analyzer?.analyze(incomingData: data)
        }
        //debugPrint(String(data: data, encoding: .utf8))
    }
}

