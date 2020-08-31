//
//  Planet.swift
//  Netrek
//
//  Created by Darrell Root on 3/3/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
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
    @Published private(set) var name: String {
        didSet {
            if name.count >= 3 {
                let index3 = name.index(name.startIndex, offsetBy: 3)
                self.shortName = String(name[..<index3])
            }
        }
    }
    @Published private(set) var shortName: String
    @Published private(set) var positionX: Int
    @Published private(set) var positionY: Int
    @Published private(set) var owner: Team = .independent
    //private(set) var info: Int = 0  //shows which teams have seen the planet
    private(set) var seen: [Team:Bool] = [:]
    //calculated from info
    
    private(set) var flags: UInt16 = 0
    @Published private(set) var agri: Bool = false
    @Published private(set) var fuel: Bool = false
    @Published private(set) var repair: Bool = false
    @Published var armies: Int = 0
    @Published private(set) var image: Image = Image("planet-empty")
    
    //@Published private(set) var imageName: String = "planet-empty"
    
    func imageName(myTeam: Team) -> String {
        if !(seen[myTeam] ?? false) {
            return "planet-unknown"
        } else {
            let imageName: String
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
            return imageName
        }
    }
    
    /*func updateImage() {
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
    }*/
    

    var description: String {
        get {
            return "planet planetID: \(planetId) name: \(name) position: \(positionX) \(positionY)"
        }
    }
    init(planetId: Int) {
        self.planetId = planetId
        self.name = "Unknown"
        self.shortName = "Unk"
        self.positionX = 0
        self.positionY = 0
        
        for team in Team.allCases {
            seen[team] = false
        }
    }
    deinit {
        debugPrint("planet ID \(planetId) deinit")
    }

    public func reset() {
        self.name = "unknown"
        self.positionX = 0
        self.positionY = 0
    }
    public func showInfo(team: Team) {
        let infoString: String
        if seen[team] == false {
            infoString = "No scanner information on \(name)"
        } else {
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
        }
        debugPrint("\(self.name) \(infoString)")
        Universe.universe.gotMessage("\(self.name) \(infoString)")
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
            //self.info = info
            for team in Team.allCases {
                if info & team.rawValue != 0 {
                    self.seen[team] = true
                } else {
                    self.seen[team] = false
                }
            }
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
