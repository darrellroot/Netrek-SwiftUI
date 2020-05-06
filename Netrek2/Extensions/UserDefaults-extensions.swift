//
//  UserDefaults-extension.swift
//  Netrek
//
//  Created by Darrell Root on 3/14/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
extension UserDefaults {
    func setString(string: String, forKey: String) {
        set(string, forKey: forKey)
    }
}
