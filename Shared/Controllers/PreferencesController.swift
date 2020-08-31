//
//  PreferencesController.swift
//  Netrek2
//
//  Created by Darrell Root on 6/4/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation
import SwiftUI

class PreferencesController: ObservableObject {
    //let appDelegate = NSApplication.shared.delegate as! AppDelegate

    static let hideHintsKey = "showHints"
    static let preferUdpKey = "preferUdp"

    let defaults: UserDefaults
    @Published var hideHints = false {
        didSet {
            defaults.set(hideHints, forKey: PreferencesController.hideHintsKey)
            debugPrint("set userdefaults hideHints \(hideHints)")
        }
    }
    @Published var preferUdp = false {
        didSet {
            defaults.set(preferUdp, forKey: PreferencesController.preferUdpKey)
            debugPrint("set userdefaults preferUdp \(preferUdp)")
        }
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        self.hideHints = defaults.bool(forKey: PreferencesController.hideHintsKey)
        self.preferUdp = defaults.bool(forKey: PreferencesController.preferUdpKey)
    }
    /*func setShowHints(_ newValue: Bool) {
        self.showHints = newValue
        defaults.set(newValue, forKey: showHintsKey)
        debugPrint("set userdefaults showHints \(newValue)")
    }*/
}
