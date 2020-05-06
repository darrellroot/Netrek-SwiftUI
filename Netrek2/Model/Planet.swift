//
//  Planet.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit

enum PlanetFlags: UInt16 {
    case repair = 0x010
    case fuel = 0x020
    case agri = 0x040
}

class Planet: CustomStringConvertible, ObservableObject, Identifiable {
    private(set) var planetId: Int
    var id: Int {
        return self.planetId
    }
    @Published private(set) var name: String
    @Published private(set) var positionX: Int
    @Published private(set) var positionY: Int
    private(set) var owner: Team = .independent
    private(set) var info: Int = 0
    private(set) var flags: UInt16 = 0
    private(set) var agri: Bool = false
    private(set) var fuel: Bool = false
    private(set) var repair: Bool = false
    static let planetEmptyTexture = SKTexture(imageNamed: "planet-empty")
    static let planetArmyTexture = SKTexture(imageNamed: "planet-army")
    static let planetFuelTexture = SKTexture(imageNamed: "planet-fuel")
    static let planetFuelArmyTexture = SKTexture(imageNamed: "planet-fuel-army")
    static let planetRepairTexture = SKTexture(imageNamed: "planet-repair")
    static let planetRepairArmyTexture = SKTexture(imageNamed: "planet-repair-army")
    static let planetRepairFuelTexture = SKTexture(imageNamed: "planet-repair-fuel")
    static let planetRepairFuelArmyTexture = SKTexture(imageNamed: "planet-repair-fuel-army")
    
    var armies: Int = 0
    var planetTacticalNode = SKSpriteNode(imageNamed: "planet-unknown")
    let planetTacticalLabel = SKLabelNode()
    //var planetInfoLabel = SKLabelNode()
    //let planetInfoFade = SKAction.fadeOut(withDuration: 3.0)
    //let planetInfoRemove = SKAction.removeFromParent()
    let planetInfoAction = SKAction.sequence([SKAction.fadeOut(withDuration: 3.0),SKAction.removeFromParent()])
    
    lazy var appDelegate = NSApplication.shared.delegate as! AppDelegate

    var description: String {
        get {
            return "planet planetID: \(planetId) name: \(name) position: \(positionX) \(positionY)"
        }
    }
    init(planetId: Int) {
        self.planetId = planetId
        self.name = "unknown"
        self.positionX = 0
        self.positionY = 0
    }
    deinit {
        debugPrint("planet ID \(planetId) deinit")
    }

    public func reset() {
        if planetTacticalLabel.parent != nil {
            planetTacticalLabel.removeFromParent()
        }
        if planetTacticalNode.parent != nil {
            planetTacticalNode.removeFromParent()
        }
    }
    public func showInfo() {
        let infoString: String
        switch (self.agri, self.fuel, self.repair) {
            
        case (false, false, false):
            infoString = "\(armies) armies"
        case (false, false, true):
            infoString = "REPAIR \(armies) armies"
        case (false, true, false):
            infoString = "FUEL \(armies) armies"
        case (false, true, true):
            infoString = "FUEL REPAIR \(armies) armies"
        case (true, false, false):
            infoString = "AGRI \(armies) armies"
        case (true, false, true):
            infoString = "AGRI REPAIR \(armies) armies"
        case (true, true, false):
            infoString = "AGRI FUEL \(armies) armies"
        case (true, true, true):
            infoString = "AGRI FUEL REPAIR\(armies) armies"
        }
        debugPrint("\(self.name) \(infoString)")

        let planetInfoLabel = SKLabelNode(text: infoString)
        planetInfoLabel.fontSize = NetrekMath.planetFontSize
        planetInfoLabel.fontName = "Courier"
        planetInfoLabel.position = CGPoint(x: 0, y: -3 * NetrekMath.planetDiameter)
        planetInfoLabel.zPosition = ZPosition.planet.rawValue
        planetInfoLabel.fontColor = NetrekMath.color(team: self.owner)
        planetTacticalNode.addChild(planetInfoLabel)
        //this action includes fading and removing from parent
        planetInfoLabel.run(planetInfoAction)
    }
    private func remakeNode() {
        planetTacticalLabel.removeFromParent()
        planetTacticalNode.removeFromParent()
        // no need to re-add after: scene controller will handle it after any packet arrives
        switch (repair,fuel,armies > 4) {
        case (false, false, false):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetEmptyTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (false, false, true):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetArmyTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (false, true, false):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetFuelTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (false, true, true):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetFuelArmyTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (true, false, false):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetRepairTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (true, false, true):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetRepairArmyTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (true, true, false):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetRepairFuelTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        case (true, true, true):
            planetTacticalNode = SKSpriteNode(texture: Planet.planetRepairFuelArmyTexture, color: NetrekMath.color(team: self.owner), size: CGSize(width: NetrekMath.planetDiameter, height: NetrekMath.planetDiameter))
        }
        planetTacticalNode.colorBlendFactor = 1.0
        planetTacticalNode.name = self.name
        planetTacticalLabel.fontSize = NetrekMath.planetFontSize
        planetTacticalLabel.fontName = "Courier"
        planetTacticalLabel.position = CGPoint(x: 0, y: -2 * NetrekMath.planetDiameter)
        planetTacticalLabel.zPosition = ZPosition.planet.rawValue
        planetTacticalLabel.fontColor = NetrekMath.color(team: self.owner)
        planetTacticalNode.position = CGPoint(x: self.positionX, y: self.positionY)
        planetTacticalNode.zPosition = ZPosition.planet.rawValue
        planetTacticalLabel.text = self.name
        planetTacticalNode.addChild(planetTacticalLabel)
        // add child not needed, tactical scene handles that
        // if planet within required distance
        //appDelegate.tacticalViewController?.scene.addChild(planetTacticalNode)
    }
    public func update(name: String, positionX: Int, positionY: Int) {
        self.name = name
        self.positionX = positionX
        self.positionY = positionY
        self.remakeNode()
    }
    public func update(owner: Int, info: Int, flags: UInt16, armies: Int) {
        self.agri = flags & PlanetFlags.agri.rawValue != 0
        self.fuel = flags & PlanetFlags.fuel.rawValue != 0
        self.repair = flags & PlanetFlags.repair.rawValue != 0
        self.flags = flags
        self.info = info
        self.armies = armies
        for team in Team.allCases {
            if owner == team.rawValue {
                self.owner = team
                self.remakeNode()
                return
            }
        }
        self.remakeNode()
    }
}
