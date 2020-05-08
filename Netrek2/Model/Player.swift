//
//  Player.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

class Player: CustomStringConvertible, ObservableObject {
    //static let shieldFactory = ShieldFactory()
    


    static let SHIELDFLAG: UInt32 = 0x0001
    static let REPAIRFLAG: UInt32 = 0x0002
    static let BOMBFLAG: UInt32 = 0x0004
    static let ORBITFLAG: UInt32 = 0x0008
    static let CLOAKFLAG: UInt32 = 0x0010
    static let WEPFLAG: UInt32 = 0x0020
    static let ENGFLAG: UInt32 = 0x0040
    static let BEAMUPFLAG: UInt32 = 0x0100
    static let BEAMDOWNFLAG: UInt32 = 0x0200
    static let SELFDESTRUCTFLAG: UInt32 = 0x0400
    static let GREENFLAG: UInt32 = 0x0800
    static let YELLOWFLAG: UInt32 = 0x1000
    static let REDFLAG: UInt32 = 0x2000
    static let PLAYERLOCKFLAG: UInt32 = 0x4000
    static let PLANETLOCKFLAG: UInt32 = 0x8000
    static let WARSETFLAG: UInt32 = 0x10000
    static let DOCKFLAG: UInt32 = 0x80000
    static let REFITFLAG: UInt32 = 0x100000
    static let REFITTINGFLAG: UInt32 = 0x200000
    static let TRACTORFLAG: UInt32 = 0x400000
    static let PRESSORFLAG: UInt32 = 0x800000
    static let DOCKOKFLAG: UInt32 = 0x1000000

    lazy var appDelegate = NSApplication.shared.delegate as! AppDelegate

    var detonated = false //set to true when blowing up

    private(set) var playerId: Int = 0
    @Published private(set) var imageName: String = "mactrek-outlinefleet-ca"

    //private(set) var hostile = 0
    private(set) var hostile: [Team:Bool] = [:]
    private(set) var war: [Team:Bool] = [:]
    private(set) var armies = 0
    private(set) var tractor = 0
    private(set) var flags: UInt32 = 0
    private(set) var damage = 0
    private(set) var shieldStrength = 100
    private(set) var fuel = 10000
    private(set) var engineTemp = 0
    private(set) var weaponsTemp = 0
    private(set) var whyDead: Int?
    private(set) var whoDead: Int?
    
    private(set) var tournamentKills: Int = 0
    private(set) var tournamentLosses: Int = 0
    private(set) var tournamentTicks: Int = 0
    private(set) var tournamentPlanets: Int = 0
    private(set) var tournamentArmies: Int = 0
    
    private(set) var playing = false
    private(set) var team: Team = .independent {
        didSet {
            self.updateImage()
        }
    }
    @Published private(set) var ship: ShipType? {
        didSet {
            self.updateImage()
        }
    }
    @Published private(set) var positionX: Int = 0
    @Published private(set) var positionY: Int = 0
    private(set) var me: Bool = false
    private(set) var name: String = "nobody"
    //
    private(set) var lastAlivePositionX: Int = 0
    private(set) var lastAlivePositionY: Int = 0
    private(set) var lastUpdateTime = Date()
    private(set) var updateTime = Date()
    // from flags
    @Published private(set) var shieldsUp = false
    //
    // from packet type 24
    private(set) var rank: Rank = .ensign
    private(set) var login = "unknown"
    // from packet type 3
    private(set) var kills = 0.0
    private(set) var slotStatus: SlotStatus = .free //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
    // from packet type 4
    private(set) var lastSlotStatus: SlotStatus = .free //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
    // flags from packet type 12
    private(set) var repair = false
    private(set) var bomb = false
    private let cloakAction = SKAction.fadeOut(withDuration: 0.7)
    private let unCloakAction = SKAction.fadeIn(withDuration: 0.7)
    private let playerCloakAction = SKAction.fadeAlpha(to: 0.2, duration: 0.7)
    private(set) var orbit = false
    private(set) var cloak = false {
        didSet {
            if oldValue == false && cloak == true {
                if me == true {
                    playerTacticalNode.run(playerCloakAction)
                } else {
                    playerTacticalNode.run(cloakAction)
                }
            }
            if oldValue == true && cloak == false {
                playerTacticalNode.run(unCloakAction)
            }
        }
    }
    private(set) var weaponsOverheated = false
    private(set) var enginesOverheated = false
    private(set) var beamUp = false
    private(set) var beamDown = false
    private(set) var selfDestruct = false
    private(set) var alertCondition: AlertCondition = .green
    private(set) var playerLock = false
    private(set) var planetLock = false
    private(set) var settingWar = false
    private(set) var docked = false
    private(set) var tractorFlag = false
    private(set) var pressor = false
    private(set) var dockok = false
    

    private(set) var direction: Double = 0.0 // 2 * Double.pi = 360 degrees
    private(set) var speed = 0
    var playerTacticalNode = SKSpriteNode()
    let playerInfoAction = SKAction.sequence([SKAction.fadeOut(withDuration: 3.0),SKAction.removeFromParent()])
    
    
    init(playerId: Int) {
        self.playerId = playerId
        self.remakeNode()
    }
    
    deinit {
        debugPrint("player ID \(playerId) deinit")
    }
    public func reset() {
        if playerTacticalNode.parent != nil {
            playerTacticalNode.removeAllActions()
            playerTacticalNode.removeFromParent()
        }
    }

    public var description: String {
        get {
            return "Player \(String(describing: playerId)) name \(name) armies \(armies) damage \(damage) shield \(shieldStrength) fuel \(fuel) eTmp \(engineTemp) ship \(String(describing: ship)) team \(String(describing: team)) wTmp \(weaponsTemp) playing \(playing) positionX \(positionX) positionY \(positionY) login \(login) rank \(rank)"
        }
    }
    public func showInfo() {
        if self.cloak == true { return }
        let infoString: String = "\(self.name) \(self.ship?.description ?? "??") \(self.kills) kills"
        let playerLetter = NetrekMath.playerLetter(playerId: self.playerId)
        //appDelegate.messageViewController?.gotMessage("\(self.team.letter)\(playerLetter) \(infoString)")
        let playerInfoLabel = SKLabelNode(text: infoString)
        playerInfoLabel.fontSize = NetrekMath.planetFontSize
        playerInfoLabel.fontName = "Courier"
        playerInfoLabel.position = CGPoint(x: self.positionX, y: self.positionY - 2 * NetrekMath.playerSize)
        playerInfoLabel.zPosition = ZPosition.ship.rawValue
        //playerInfoLabel.fontColor = NetrekMath.color(team: self.team)
        playerInfoLabel.run(playerInfoAction)
    }

    func updateImage() {
        switch (self.team, self.ship ?? .cruiser) {
        case (.federation,.scout):
            self.imageName = "mactrek-outlinefleet-sc"
        case (.federation,.destroyer):
            self.imageName = "mactrek-outlinefleet-dd"
        case (.federation,.cruiser):
            self.imageName = "mactrek-outlinefleet-ca"
        case (.federation,.battleship):
            self.imageName = "mactrek-outlinefleet-bb"
        case (.federation,.assault):
            self.imageName = "mactrek-outlinefleet-as"
        case (.federation,.starbase):
            self.imageName = "mactrek-outlinefleet-sb"
        case (.federation,.battlecruiser):
            self.imageName = "mactrek-outlinefleet-ca"
        case (.roman,.scout):
            self.imageName = "mactrek-redfleet-sc"
        case (.roman,.destroyer):
            self.imageName = "mactrek-redfleet-dd"
        case (.roman,.cruiser):
            self.imageName = "mactrek-redfleet-ca"
        case (.roman,.battleship):
            self.imageName = "mactrek-redfleet-bb"
        case (.roman,.assault):
            self.imageName = "mactrek-redfleet-bb"
        case (.roman,.starbase):
            self.imageName = "mactrek-redfleet-sb"
        case (.roman,.battlecruiser):
            self.imageName = "mactrek-redfleet-ca"
        case (.kazari,.scout):
            self.imageName = "kli-sc"
        case (.kazari,.destroyer):
            self.imageName = "kli-dd"
        case (.kazari,.cruiser):
            self.imageName = "kli-ca"
        case (.kazari,.battleship):
            self.imageName = "kli-bb"
        case (.kazari,.assault):
            self.imageName = "kli-as"
        case (.kazari,.starbase):
            self.imageName = "kli-sb"
        case (.kazari,.battlecruiser):
            self.imageName = "kli-ca"
        case (.orion,.scout):
            self.imageName = "ori-sc"
        case (.orion,.destroyer):
            self.imageName = "ori-dd"
        case (.orion,.cruiser):
            self.imageName = "ori-ca"
        case (.orion,.battleship):
            self.imageName = "ori-bb"
        case (.orion,.assault):
            self.imageName = "ori-as"
        case (.orion,.starbase):
            self.imageName = "ori-sb"
        case (.orion,.battlecruiser):
            self.imageName = "ori-ca"

        case (.independent,.scout), (.ogg, .scout):
            self.imageName = "mactrek-outlinefleet-sc"
        case (.independent,.destroyer), (.ogg, .destroyer):
            self.imageName = "mactrek-outlinefleet-dd"
        case (.independent,.cruiser), (.ogg, .cruiser):
            self.imageName = "mactrek-outlinefleet-ca"
        case (.independent,.battleship), (.ogg, .battleship):
            self.imageName = "mactrek-outlinefleet-bb"
        case (.independent,.assault), (.ogg, .assault):
            self.imageName = "mactrek-outlinefleet-as"
        case (.independent,.starbase), (.ogg, .starbase):
            self.imageName = "mactrek-outlinefleet-sb"
        case (.independent,.battlecruiser), (.ogg, .battlecruiser):
            self.imageName = "mactrek-outlinefleet-ca"
            }
    }
    public func remakeNode() {
        //private(set) var status = 0  //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
        /*if self.shieldNode.parent != nil {
            self.shieldNode.removeFromParent()
        }*/
        if self.playerTacticalNode.parent != nil {
            self.playerTacticalNode.removeFromParent()
        }
        
        let playerSize = CGSize(width: NetrekMath.playerSize, height: NetrekMath.playerSize)
        let playerColor = NetrekMath.color(team: self.team)
        
        self.updateNode()
    }
    private func updateNode() {
        //    private(set) var status = 0  //free=0 outfit=1 alive=2 explode=3 dead=4 observe=5
        
        if self.slotStatus != self.lastSlotStatus {
            
        switch self.slotStatus {
            case .free:
                break
            case .outfit:
                break
            case .alive:
                break
            case .explode:
                //self.playerTacticalNode.isHidden = true
                if me && self.lastSlotStatus == .alive {
                    appDelegate.newGameState(.loginAccepted)
            }
            case .dead:
                //self.playerTacticalNode.isHidden = true
                if me && self.lastSlotStatus == .alive {
                    appDelegate.newGameState(.loginAccepted)
            }
            case .observe:
                //self.playerTacticalNode.isHidden = true
                break
            }
            self.lastSlotStatus = self.slotStatus
        }
        /*if shieldsUp {
            self.shieldNode.isHidden = false
        } else {
            self.shieldNode.isHidden = true
        }*/
        if self.slotStatus == .alive && self.positionX > 0 && self.positionX < NetrekMath.galacticSize && self.positionY > 0 && self.positionY < NetrekMath.galacticSize {
            self.playerTacticalNode.position = CGPoint(x: positionX, y: positionY)
            //self.playerTacticalNode.zRotation = self.direction
            /*let deltaX = self.positionX - self.lastPositionX
            let deltaY = self.positionY - self.lastPositionY
            let deltaTime = self.updateTime.timeIntervalSince(self.lastUpdateTime)
            if deltaX < NetrekMath.actionThreshold && deltaY < NetrekMath.actionThreshold && deltaTime < 2.0 && deltaTime > 0.04 {
                let action = SKAction.moveBy(x: CGFloat(deltaX), y: CGFloat(deltaY), duration: deltaTime)
                DispatchQueue.main.async {
                    self.playerTacticalNode.removeAllActions()
                    self.playerTacticalNode.run(action)
                }
                debugPrint("running action player \(playerID) deltaX \(deltaX) deltaY \(deltaY) deltaTime \(deltaTime)")
            } else {
                debugPrint("Player.update.noAction playerID \(String(describing: playerID)) deltaX \(deltaX) deltaY \(deltaY) deltaT \(deltaTime)")
            }*/
            if self.me {
                /*if self.shieldStrength < 20 {
                    self.shieldNode.alpha = 0.2
                } else if shieldStrength > 100 {
                    self.shieldNode.alpha = 1.0
                } else {
                    self.shieldNode.alpha = CGFloat(self.shieldStrength) / 100.0
                }*/
                /*if let defaultCamera = appDelegate.tacticalViewController?.defaultCamera {
                    defaultCamera.position = CGPoint(x: self.positionX, y: self.positionY)
                    /*let action = SKAction.moveBy(x: CGFloat(deltaX), y: CGFloat(deltaY), duration: deltaTime)
                    DispatchQueue.main.async {
                        defaultCamera.removeAllActions()
                        defaultCamera.run(action)*/
                }*/
            }
        }
    }
    
    public func updateMe(myPlayerId: Int, hostile: UInt32, war: UInt32, armies: Int, tractor: Int, flags: UInt32, damage: Int, shieldStrength: Int, fuel: Int, engineTemp: Int, weaponsTemp: Int, whyDead: Int, whoDead: Int) {
        if self.playerId != myPlayerId {
            debugPrint("Player.updateMe: ERROR: inconsistent player ID \(myPlayerId) versus \(String(describing: self.playerId))")
        }
        self.me = true
        //self.hostile = hostile //TODO break this up
        for team in Team.allCases {
            if UInt32(team.rawValue) & hostile != 0 {
                self.hostile[team] = true
            } else {
                self.hostile[team] = false
            }
        }
        //self.war = war // TODO break this up
        for team in Team.allCases {
            if UInt32(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }
        self.armies = armies
        self.tractor = tractor
        self.damage = damage
        self.shieldStrength = shieldStrength
        self.fuel = fuel
        self.engineTemp = engineTemp
        self.weaponsTemp = weaponsTemp
        self.whyDead = whyDead
        self.whoDead = whoDead
        DispatchQueue.main.async {
            if flags & PlayerStatus.shield.rawValue != 0 {
                self.shieldsUp = true
            } else {
                self.shieldsUp = false
            }
        }
        if flags & PlayerStatus.repair.rawValue != 0 {
            self.repair = true
        } else {
            self.repair = false
        }
        if flags & PlayerStatus.bomb.rawValue != 0 {
            self.bomb = true
        } else {
            self.bomb = false
        }
        if flags & PlayerStatus.weaponTemp.rawValue != 0 {
            self.weaponsOverheated = true
        } else {
            self.weaponsOverheated = false
        }
        if flags & PlayerStatus.engineTemp.rawValue != 0 {
            self.enginesOverheated = true
        } else {
            self.enginesOverheated = false
        }

        if flags & PlayerStatus.tractor.rawValue != 0 {
            self.tractorFlag = true
        } else {
            self.tractorFlag = false
        }
        if flags & PlayerStatus.pressor.rawValue != 0 {
            self.pressor = true
        } else {
            self.pressor = false
        }
        //self.flags = flags

        //if flags & UInt32(0x0002) != 0 { repair = true } else { repair = false }
        //if flags & UInt32(0x0004) != 0 { bomb = true } else { bomb = false }
        if flags & UInt32(0x0008) != 0 { orbit = true } else { orbit = false }
        if flags & UInt32(0x0010) != 0 { cloak = true } else { cloak = false }
        //if flags & UInt32(0x0020) != 0 { weaponsOverheated = true } else { weaponsOverheated = false }
        //if flags & UInt32(0x0040) != 0 { enginesOverheated = true } else { enginesOverheated = false }
        if flags & UInt32(0x0100) != 0 { beamUp = true } else { beamUp = false }
        if flags & UInt32(0x0200) != 0 { beamDown = true } else { beamDown = false }
        if flags & UInt32(0x0400) != 0 { selfDestruct = true } else { selfDestruct = false }
        if flags & UInt32(0x0800) != 0 { alertCondition = .green }
        if flags & UInt32(0x1000) != 0 { alertCondition = .yellow }
        if flags & UInt32(0x2000) != 0 { alertCondition = .red }
        if flags & UInt32(0x4000) != 0 { playerLock = true } else { playerLock = false }
        if flags & UInt32(0x8000) != 0 { planetLock = true } else { planetLock = false }
        if flags & UInt32(0x10000) != 0 { settingWar = true } else { settingWar = false }
        if flags & UInt32(0x80000) != 0 { docked = true } else { docked = false }

        if flags & UInt32(0x400000) != 0 { tractorFlag = true } else { tractorFlag = false }
        
        if flags & UInt32(0x800000) != 0 { pressor = true } else { pressor = false }
        if flags & UInt32(0x1000000) != 0 { dockok = true } else { dockok = false }
        self.updateNode()
    }
    public func update(shipType: Int) {
        for shipCase in ShipType.allCases {
            if shipCase.rawValue == shipType {
                if shipCase != self.ship {
                    self.ship = shipCase
                    self.remakeNode()
                }
                return
            }
        }
        debugPrint("Player.update invalid shipType \(shipType)")
    }
    public func update(team: Int) {
        for teamCase in Team.allCases {
            if teamCase.rawValue == team {
                if self.team != teamCase {
                    self.team = teamCase
                    self.remakeNode()
                }
                return
            }
        }
        debugPrint("Player.update invalid team \(team)")
    }
    public func update(kills: Double) {
        self.kills = kills
    }
    // from SP_PLAYER 4
    public func update(directionNetrek: UInt8, speed: Int, positionX: Int, positionY: Int) {
        self.direction = NetrekMath.directionNetrek2radian(UInt8(directionNetrek))
        self.speed = speed
        if self.slotStatus == .alive {
            self.lastAlivePositionX = positionX
            self.lastAlivePositionY = positionY
        }
        self.lastUpdateTime = self.updateTime
        self.updateTime = Date()
        DispatchQueue.main.async {
            self.positionX = positionX
            self.positionY = positionY
        }
        self.updateNode()
        /* for debugging only
         if me && self.direction < CGFloat.pi {
            // do nothing
            debugPrint("self.direction \(self.direction)")
        }*/
    }
    // from SP_FLAGS_18
    public func update(tractor: Int, flags: UInt32) {
        self.tractor = tractor
        self.flags = flags
        DispatchQueue.main.async {
            if flags & PlayerStatus.shield.rawValue != 0 {
                self.shieldsUp = true
            } else {
                self.shieldsUp = false
            }
            if flags & PlayerStatus.cloak.rawValue != 0 {
                self.cloak = true
            } else {
                self.cloak = false
            }
        }
    }
    // from SP_PSTATUS_20
    public func update(sp_pstatus: Int) {
        switch sp_pstatus {
        case 0:
            self.slotStatus = .free
        case 1:
            self.slotStatus = .outfit
        case 2:
            self.slotStatus = .alive
            self.detonated = false
            self.updateNode()
        case 3:
            self.slotStatus = .explode
            self.updateNode()
        case 4:
            self.slotStatus = .dead
        case 5:
            self.slotStatus = .observe
        default:
            debugPrint("Player.update.SP_PSTATUS invalid slot status \(sp_pstatus)")
        }
    }

    // from SP_HOSTILE_22
    public func update(war: UInt32, hostile: UInt32) {
        for team in Team.allCases {
            if UInt32(team.rawValue) & hostile != 0 {
                self.hostile[team] = true
            } else {
                self.hostile[team] = false
            }
        }
        //self.war = war // TODO break this up
        for team in Team.allCases {
            if UInt32(team.rawValue) & war != 0 {
                self.war[team] = true
            } else {
                self.war[team] = false
            }
        }
        /*for team in Team.allCases {
            debugPrint("player \(String(describing: playerID)) is on team \(self.team) and is hostile:\(self.hostile) with team \(team)" )
            debugPrint("player \(String(describing: playerID)) is on team \(self.team) and is war:\(self.war) with team \(team)" )
        }*/
    }
    // from SP_STATS 23
    public func updatePlayer(playerId: Int, tournamentKills: Int, tournamentLosses: Int, tournamentTicks: Int, tournamentPlanets: Int, tournamentArmies: Int) {
        self.tournamentKills = tournamentKills
        self.tournamentLosses = tournamentLosses
        self.tournamentTicks = tournamentTicks
        self.tournamentPlanets = tournamentPlanets
        self.tournamentArmies = tournamentArmies
    }

    public func update(rank: Int, name: String, login: String) {
        for netrekRank in Rank.allCases {
            if netrekRank.rawValue == rank {
                self.rank = netrekRank
            }
        }
        self.name = name
        self.login = login
    }
}

