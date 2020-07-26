//
//  TimerCount.swift
//  Netrek2
//
//  Created by Darrell Root on 7/24/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

class UpdateCounter: ObservableObject {
    @Published private (set) var count: Int = 0
    let name: String
    init(name: String) {
        self.name = name
    }
    public func increment() {
        DispatchQueue.main.async {
            self.count += 1
            debugPrint("counter \(self.name) \(self.count)")
        }
    }
}
