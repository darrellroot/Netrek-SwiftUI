//
//  AlertCondition.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation
import SwiftUI

enum AlertCondition: CaseIterable {
    case green
    case yellow
    case red
    
    var color: Color {
        switch self {
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .red:
            return Color.red
        }
    }
}
