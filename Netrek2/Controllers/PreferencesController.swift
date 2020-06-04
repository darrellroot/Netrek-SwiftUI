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

    let showHintsKey = "showHints"
    let defaults: UserDefaults
    @Published var showHints = true {
        didSet {
            defaults.set(showHints, forKey: showHintsKey)
            debugPrint("set userdefaults showHints \(showHints)")
        }
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        self.showHints = defaults.bool(forKey: showHintsKey)
    }
    /*func setShowHints(_ newValue: Bool) {
        self.showHints = newValue
        defaults.set(newValue, forKey: showHintsKey)
        debugPrint("set userdefaults showHints \(newValue)")
    }*/
}
