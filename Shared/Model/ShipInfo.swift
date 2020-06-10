//
//  Ship.swift
//  Netrek
//
//  Created by Darrell Root on 3/9/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

class ShipInfo {
    var shipType: ShipType
    var torpSpeed: Int
    var phaserRange: Int
    var maxSpeed: Int
    var maxFuel: Int
    var maxShield: Int
    var maxDamage: Int
    var maxWpnTmp: Int
    var maxEngTmp: Int
    var width: Int
    var height: Int
    var maxArmies: Int
    //var letter: String
    //var shipName: String
    //var designator: String
    //var bitmap: Int
    
    init(shipType: ShipType, torpSpeed: Int, phaserRange: Int, maxSpeed: Int, maxFuel: Int, maxShield: Int, maxDamage: Int, maxWpnTmp: Int, maxEngTmp: Int, width: Int, height: Int, maxArmies: Int) {
        self.shipType = shipType
        self.torpSpeed = torpSpeed
        self.phaserRange = phaserRange
        self.maxSpeed = maxSpeed
        self.maxFuel = maxFuel
        self.maxShield = maxShield
        self.maxDamage = maxDamage
        self.maxWpnTmp = maxWpnTmp
        self.maxEngTmp = maxEngTmp
        self.width = width
        self.height = height
        self.maxArmies = maxArmies
        
    }
}
