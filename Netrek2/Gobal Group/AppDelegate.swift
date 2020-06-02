//
//  AppDelegate.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Cocoa
import SwiftUI
import Network

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let defaults = UserDefaults.standard

    var serverFeatures: [String] = []
    var clientFeatures: [String] = ["FEATURE_PACKETS","SHIP_CAP","SP_GENERIC_32","TIPS"]

    var tacticalWindow: NSWindow!
    var strategicWindow: NSWindow!
    var communicationsWindow: NSWindow!
    var manualServerWindow: NSWindow!
    var preferencesWindow: NSWindow!
    
    var metaServer: MetaServer?
    var reader: TcpReader?
    private(set) var gameState: GameState = .noServerSelected
    var analyzer: PacketAnalyzer?
    @ObservedObject var universe = Universe()
    var clientTypeSent = false
    var soundController: SoundController?


    @IBOutlet weak var serverMenu: NSMenu!

    @IBOutlet weak var selectShipScout: NSMenuItem!
    @IBOutlet weak var selectShipDestroyer: NSMenuItem!
    @IBOutlet weak var selectShipCruiser: NSMenuItem!
    @IBOutlet weak var selectShipBattleship: NSMenuItem!
    @IBOutlet weak var selectShipAssault: NSMenuItem!
    @IBOutlet weak var selectShipStarbase: NSMenuItem!
    @IBOutlet weak var selectShipBattlecruiser: NSMenuItem!

    @IBOutlet weak var selectTeamFederation: NSMenuItem!
    @IBOutlet weak var selectTeamRoman: NSMenuItem!
    @IBOutlet weak var selectTeamKazari: NSMenuItem!
    @IBOutlet weak var selectTeamOrion: NSMenuItem!

    
    var loginName: String?
    var loginPassword: String?
    var loginUserName: String?
    var loginAuthenticated = false

    var preferredTeam: Team = .federation
    var preferredShip: ShipType = .cruiser
    var keymapController: KeymapController!

    let timerInterval = 1.0 / Double(UPDATE_RATE)
    var timer: Timer?
    @State var timerCount = 0

    
    @IBAction func disconnectGame(_ sender: NSMenuItem) {
        self.newGameState(.noServerSelected)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let loginName = defaults.string(forKey: LoginDefault.loginName.rawValue) {
            self.loginName = loginName
        }
        if let loginUserName = defaults.string(forKey: LoginDefault.loginUserName.rawValue) {
            self.loginUserName = loginUserName
        }
        self.loginAuthenticated = defaults.bool(forKey: LoginDefault.loginAuthenticated.rawValue)
            
        if let loginPassword = LoginInformationController.getPasswordKeychain() {
            self.loginPassword = loginPassword
        }
        self.soundController = SoundController()
        self.keymapController = KeymapController()

        metaServer = MetaServer(hostname: "metaserver.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
        }
        timer = Timer(timeInterval: timerInterval , target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        timer?.tolerance = timerInterval / 10.0
        if let timer = timer {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        self.updateTeamMenu()
        self.disableShipMenu()

        // Create the SwiftUI view that provides the window contents.
        let tacticalView = TacticalView(universe: universe)
        let strategicView = StrategicView(universe: universe)

        // Create the window and set the content view. 
        tacticalWindow = NSCommandedWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        tacticalWindow.center()
        tacticalWindow.setFrameAutosaveName("Tactical")
        tacticalWindow.contentView = NSHostingView(rootView: tacticalView)
        
        //The title name impacts the keypress location algorithm, see NSCommmandedWindow
        tacticalWindow.title = "Tactical"
        
        tacticalWindow.makeKeyAndOrderFront(nil)
        
        strategicWindow = NSCommandedWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        strategicWindow.center()
        strategicWindow.setFrameAutosaveName("Strategic")
        
        //The title name impacts the keypress location algorithm, see NSCommmandedWindow
        strategicWindow.title = "Strategic"
        
        strategicWindow.contentView = NSHostingView(rootView: strategicView)
        strategicWindow.makeKeyAndOrderFront(nil)

        let communicationsView = CommunicationsView(universe: universe)
        communicationsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 7000, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        communicationsWindow.center()
        communicationsWindow.setFrameAutosaveName("Communications")
        communicationsWindow.title = "Communications"
        communicationsWindow.contentView = NSHostingView(rootView: communicationsView)
        communicationsWindow.makeKeyAndOrderFront(nil)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    //MARK: METASERVER
    func refreshMetaserver() {
        if let metaServer = metaServer {
            metaServer.update()
        }
    }
    @IBAction func refreshMetaserverNetrekOrg(_ sender: NSMenuItem) {
        metaServer = MetaServer(hostname: "metaserver.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
        }
    }
    @IBAction func refreshMetaserverEuNetrekOrg(_ sender: NSMenuItem) {
        metaServer = MetaServer(hostname: "metaserver.eu.netrek.org", port: 3521)
        if let metaServer = metaServer {
            metaServer.update()
        }
    }
    public func metaserverUpdated() {
        debugPrint("AppDelegate.metaserverUpdated")
        if let metaServer = metaServer {
            universe.gotMessage("Server list updated from metaserver")
            serverMenu.removeAllItems()
            for (index,server) in metaServer.servers.enumerated() {
                let newItem = NSMenuItem(title: server.description, action: #selector(self.selectServer), keyEquivalent: "")
                newItem.tag = index
                serverMenu.addItem(newItem)
            }
            let separator = NSMenuItem.separator()
            serverMenu.addItem(separator)
            let customItem = NSMenuItem(title: "Manually choose server by hostname", action: #selector(self.manualServer), keyEquivalent: "")
            serverMenu.addItem(customItem)
        }
    }
    
    @IBAction func preferences(_ sender: NSMenuItem) {
        let preferencesView = PreferencesView(keymapController: keymapController)
        preferencesWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        preferencesWindow.center()
        preferencesWindow.setFrameAutosaveName("Preferences")
        preferencesWindow.title = "Preferences"
        preferencesWindow.contentView = NSHostingView(rootView: preferencesView)
        preferencesWindow.makeKeyAndOrderFront(nil)

    }
    
    
    @objc func manualServer(sender: NSMenuItem) {
        let manualServerView = ManualServerView()
        manualServerWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        manualServerWindow.center()
        manualServerWindow.setFrameAutosaveName("Manual Server")
        manualServerWindow.title = "Manual Server"
        manualServerWindow.contentView = NSHostingView(rootView: manualServerView)
        manualServerWindow.makeKeyAndOrderFront(nil)
        
    }
    
    public func connectToServer(server: String) {
        guard self.gameState == .noServerSelected || self.gameState == .serverSelected else {
            debugPrint("Can only connect if not connected")
            return
        }
        if let reader = TcpReader(hostname: server, port: 2592, delegate: self) {
               self.reader = reader
               self.newGameState(.serverSelected)
           } else {
               debugPrint("AppDelegate failed to start reader")
           }
    }

    @objc func selectServer(sender: NSMenuItem) {
        let tag = sender.tag
        if let server = metaServer?.servers[safe: tag] {
            print("starting game server \(server.description)")
            if reader != nil {
                self.resetConnection()
            }
            if let reader = TcpReader(hostname: server.hostname, port: server.port, delegate: self) {
                self.reader = reader
                self.newGameState(.serverSelected)
 
            } else {
                debugPrint("AppDelegate failed to start reader")
            }
        }
    }
    
    private func disableShipMenu() {
        DispatchQueue.main.async {
            debugPrint("disable ship menu")
            self.selectShipScout.isEnabled = false
            self.selectShipDestroyer.isEnabled = false
            self.selectShipCruiser.isEnabled = false
            self.selectShipBattleship.isEnabled = false
            self.selectShipAssault.isEnabled = false
            self.selectShipStarbase.isEnabled = false
            self.selectShipBattlecruiser.isEnabled = false
        }
    }
    private func enableShipMenu() {
        DispatchQueue.main.async {
            debugPrint("enable ship menu")
            self.selectShipScout.isEnabled = true
            self.selectShipDestroyer.isEnabled = true
            self.selectShipCruiser.isEnabled = true
            self.selectShipBattleship.isEnabled = true
            self.selectShipAssault.isEnabled = true
            self.selectShipStarbase.isEnabled = true
            self.selectShipBattlecruiser.isEnabled = true
        }
    }
    @IBAction func selectTeam(_ sender: NSMenuItem) {
        let tag = sender.tag
        for team in Team.allCases {
            if tag == team.rawValue {
                self.preferredTeam = team
                self.updateTeamMenu()
            }
        }
    }

    @IBAction func selectShip(_ sender: NSMenuItem) {
        let tag = sender.tag
        for ship in ShipType.allCases {
            if tag == ship.rawValue {
                self.preferredShip = ship
            }
        }
        if self.gameState == .loginAccepted {
            if let reader = self.reader {
                let cpUpdates = MakePacket.cpUpdates()
                    reader.send(content: cpUpdates)
                let cpOutfit = MakePacket.cpOutfit(team: self.preferredTeam, ship: self.preferredShip)
                reader.send(content: cpOutfit)
            }
        }
        if self.gameState == .gameActive {
            if let reader = self.reader {
                let cpRefit = MakePacket.cpRefit(newShip: self.preferredShip)
                reader.send(content: cpRefit)
            }
        }
    }

    
    private func disableServerMenu() {
        DispatchQueue.main.async {
            debugPrint("disable server menu")
            for menuItem in self.serverMenu.items {
                debugPrint("disabling server menu \(menuItem.title)")
                menuItem.isEnabled = false
            }
        }
    }

    private func enableServerMenu() {
        DispatchQueue.main.async {
            debugPrint("enable server menu")
            for menuItem in self.serverMenu.items {
                menuItem.isEnabled = true
            }
        }
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

    public func updateTeamMenu(mask: UInt8) {
        if mask & UInt8(Team.federation.rawValue) != 0 {
            self.selectTeamFederation.indentationLevel = 0
        } else {
            self.selectTeamFederation.indentationLevel = 1
        }
        if mask & UInt8(Team.roman.rawValue) != 0 {
            self.selectTeamRoman.indentationLevel = 0
        } else {
            self.selectTeamRoman.indentationLevel = 1
        }
        if mask & UInt8(Team.kazari.rawValue) != 0 {
            self.selectTeamKazari.indentationLevel = 0
        } else {
            self.selectTeamKazari.indentationLevel = 1
        }
        if mask & UInt8(Team.orion.rawValue) != 0 {
            self.selectTeamOrion.indentationLevel = 0
        } else {
            self.selectTeamOrion.indentationLevel = 1
        }
    }
    private func updateTeamMenu() {
        DispatchQueue.main.async {
            self.selectTeamFederation.state = .off
            self.selectTeamFederation.state = .off
            self.selectTeamRoman.state = .off
            self.selectTeamKazari.state = .off
            self.selectTeamOrion.state = .off
            switch self.preferredTeam {
            case .federation:
                self.selectTeamFederation.state = .on
            case .roman:
                self.selectTeamRoman.state = .on
            case .kazari:
                self.selectTeamKazari.state = .on
            case .orion:
                self.selectTeamOrion.state = .on
            case .independent:
                break
            case .ogg:
                break
            }
        }
    }

    @objc func timerFired() {
        timerCount = timerCount + 1
        //debugPrint("AppDelegate.timerFired \(Date())")
        if timerCount % 50 == 0 {
            //self.tacticalViewController?.updateHint()
        }
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
            if (timerCount % 200) == 0 {
                debugPrint("AppDelegate.timer.gameActive: updating sendMessageViewController")
                /*DispatchQueue.main.async {
                    self.sendMessageViewController?.updateMenu()
                }*/
            }
            if (timerCount % 100) == 0 {
                debugPrint("Setting needs display for playerListViewController")
                /*DispatchQueue.main.async {
                    self.playerListViewController?.view.needsDisplay = true
                }*/
                // send cpUpdate once every 10 seconds to prevent ghostbust
                let cpUpdates = MakePacket.cpUpdates()
                reader?.send(content: cpUpdates)
            }
            if (timerCount % 10) == 0 {
                /*DispatchQueue.main.async {
                    self.strategicViewController?.view.needsDisplay = true
                    self.hudViewController?.view.needsDisplay = true
                }*/
            }
            //TODO send ping every x timer counts
            break
        }
    }


    public func newGameState(_ newState: GameState ) {
        debugPrint("Game State: moving from \(self.gameState.rawValue) to \(newState.rawValue)\n")
        switch newState {

        case .noServerSelected:
            self.resetConnection()
            universe.reset()
            enableServerMenu()
            disableShipMenu()
            self.gameState = newState
            universe.gotMessage("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again\n")
            debugPrint("AppDelegate GameState \(newState) we may have been ghostbusted!  Resetting.  Try again\n")
            self.refreshMetaserver()
            break

        case .serverSelected:
            disableShipMenu()
            disableServerMenu()
            self.gameState = newState
            self.analyzer = PacketAnalyzer()
            // no need to do anything here, handled in the menu function
            break

        case .serverConnected:
            disableShipMenu()
            disableServerMenu()
            self.clientTypeSent = false
            self.gameState = newState

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
            disableShipMenu()
            disableServerMenu()
            self.gameState = newState
            debugPrint("AppDelegate.newGameState: .serverSlotFound")
            let cpLogin: Data
            if loginAuthenticated == true, let loginName = self.loginName, let loginPassword = self.loginPassword, let loginUserName = self.loginUserName {
                cpLogin = MakePacket.cpLogin(name: loginName, password: loginPassword, login: loginUserName)
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
        self.enableShipMenu()
        self.disableServerMenu()
        /*DispatchQueue.main.async {
            self.playerListViewController?.view.needsDisplay = true
        }*/
        self.gameState = newState

        case .gameActive:
            self.enableShipMenu()
            self.disableServerMenu()
            /*DispatchQueue.main.async {
                self.playerListViewController?.view.needsDisplay = true
            }*/
            self.gameState = newState
            if !clientTypeSent {
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
                let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
                let data = MakePacket.cpMessage(message: "I am using the Swift Netrek Client version \(appVersion) build \(buildVersion) on MacOS", team: .ogg, individual: 0)
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


