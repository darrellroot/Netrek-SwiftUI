//
//  Help.swift
//  Netrek2
//
//  Created by Darrell Root on 6/4/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

class Help: ObservableObject {
    
    @Published var currentTip = Help.tips[0]

    var tipCount = 0
    
    func nextTip() {
        tipCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.tipCount > 3 {
                self.currentTip = Help.tips.randomElement()!
            } else {
                self.currentTip = Help.tips[0]
            }
        }
    }
    func noTip() {
        DispatchQueue.main.async {
            self.currentTip = ""
        }
        // preventing race conditions if user reenters game
        // in less than 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.currentTip = ""
        }
    }
    static let tips = [
        """
        To play:
        1) Choose "Select Server -> [server]"
            (pickled.netrek.org is a good beginner server)
        2) Choose "Launch Ship -> cruiser"

        Left mouse button fires torpedoes.
        Right mouse button changes direction.
        Center mouse button fires lasers.
        Number keys change speed
        s key toggles shields
        """
    ,
        """
        Left mouse button fires torpedoes.
        Right mouse button changes direction.
        Center mouse button fires lasers.
        """
    ,
        """
        Check out Netrek documentation at
        https://www.netrek.org/
        """
    ,
        """
        Fuel is your friend.
        Conserve your fuel!
        """
    ]
    
}
