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

    let hideHintsKey = "showHints"
    let defaults: UserDefaults
    @Published var hideHints = false {
        didSet {
            defaults.set(hideHints, forKey: hideHintsKey)
            debugPrint("set userdefaults hideHints \(hideHints)")
        }
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        self.hideHints = defaults.bool(forKey: hideHintsKey)
    }
    /*func setShowHints(_ newValue: Bool) {
        self.showHints = newValue
        defaults.set(newValue, forKey: showHintsKey)
        debugPrint("set userdefaults showHints \(newValue)")
    }*/
}
