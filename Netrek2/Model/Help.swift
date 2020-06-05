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
        
        If that doesn't work, you may need to switch your "preferred team"

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
    ,
        """
        a++ means that player a is carrying armies
        """
    ,
        """
        You can turn off these hints using the Netrek -> Preferences menu
        """
    ,
        """
        You can map different controls to different commands using the Netrek -> Preferences menu
        """
    ,
        """
        Agricultural planets create armies faster
        """
        ,
        """
        When orbiting a planet, use z to beam up armies and x to beam down armies.  You can carry 2 armies per kill.
        """
        ,
        """
        The object of the game is to capture all enemy planets.
        """
        ,
        """
        T activates your tractor beam
        y activates your pressor beam
        """
        ,
        """
        When switching windows, you must press the left mouse button to set the "window focus".
        """
        ,
        """
        l locks onto a planet for direction and (once you get there) orbit.
        """
        ,
        """
        If you are going speed 0-2 over a planet, you can hit o to enter orbit.
        """
        ,
        """
        Netrek was originally implemented around 1990.  It is the original multiplayer Internet game.
        """
        ,
        """
        Hitting R will stop your ship, lower your shields, and improve your repair speed.
        """
        ,
        """
        Orbit a planet with fuel to refuel faster
        """
        ,
        """
        Your ship repairs whenever shields are down.
        """
        ,
        """
        Orbit a planet with repair facilities to repair quickly
        """
        ,
        """
        Netrek is a team game.  Use the messages window to play as a team.
        """
        ,
        """
        If "launch ship" does not work, check the communications window.  You may need to switch teams.
        """
        ,
        """
        Hit i in the tactical or strategic windows near a planet to show information about the planet in the communications window.
        """
        ,
        """
        Join the "netrek-forever" Google Group to receive notifications of recommended gametimes.
        """
    ]
    
}
