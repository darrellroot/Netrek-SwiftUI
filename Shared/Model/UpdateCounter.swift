//
//  TimerCount.swift
//  Netrek2
//
//  Created by Darrell Root on 7/24/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

class UpdateCounter: ObservableObject {
    @Published var count: Int = 0
}
