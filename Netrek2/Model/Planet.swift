//
//  Planet.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

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
    @Published private(set) var agri: Bool = false {
        didSet {
            updateImage()
        }
    }
    @Published private(set) var fuel: Bool = false {
        didSet {
            updateImage()
        }
    }
    @Published private(set) var repair: Bool = false {
        didSet {
            updateImage()
        }
    }
    @Published var armies: Int = 0 {
        didSet {
            updateImage()
        }
    }
    @Published private(set) var image: Image = Image("planet-empty")
    
    @Published private(set) var imageName: String = "planet-empty"
    
    func updateImage() {
        var imageName: String
        switch (repair, fuel, armies > 4) {
            case (false, false, false):
            imageName = "planet-empty"
            case (false, false, true):
            imageName = "planet-army"
            case (false, true, false):
            imageName = "planet-fuel"
            case (false, true, true):
            imageName = "planet-fuel-army"
            case (true, false, false):
            imageName = "planet-repair"
            case (true, false, true):
            imageName = "planet-repair-army"
            case (true, true, false):
            imageName = "planet-repair-fuel"
            case (true, true, true):
            imageName = "planet-repair-fuel-army"
        }
        DispatchQueue.main.async {
            self.imageName = imageName
            self.image = Image(imageName)
        }
        debugPrint("planet \(self.name) image \(imageName)")
    }
    
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
        self.name = "unknown"
        self.positionX = 0
        self.positionY = 0
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
    }

    public func update(name: String, positionX: Int, positionY: Int) {
        DispatchQueue.main.async {
            self.name = name
            self.positionX = positionX
            self.positionY = positionY
        }
        
        //self.remakeNode()
    }
    public func update(owner: Int, info: Int, flags: UInt16, armies: Int) {
        DispatchQueue.main.async {
            self.agri = flags & PlanetFlags.agri.rawValue != 0
            self.fuel = flags & PlanetFlags.fuel.rawValue != 0
            self.repair = flags & PlanetFlags.repair.rawValue != 0
            self.flags = flags
            self.info = info
            self.armies = armies
            for team in Team.allCases {
                if owner == team.rawValue {
                    self.owner = team
                    //self.remakeNode()
                    return
                }
            }
        }
        //self.remakeNode()
    }
}
