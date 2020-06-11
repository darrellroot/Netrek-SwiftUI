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

    #if os(macOS)
    var tipCount = 0
    #elseif os(iOS)
    var tipCount = 4
    #endif
    
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
        // The following tips come from the Windows client via Bill Balcerski
        ,
        """
        When you are low on planets, you should let the more experienced players pick the armies. Those should not be wasted.
        """
        ,
        """
        When you are in doubt, you should ask a Commodore, Rear Adm. or Admiral for advice.
        """
        ,
        """
        When your team has lots of armies, you should not be afraid to pick them. They'll get bombed anyway.
        """
        ,
        """
        Just because you carry armies, that doesn't mean you can't fight.
        """
        ,
        """
        The team that delivers the most armies wins.
        """
        ,
        """
        You should have flexible goals.
        """
        ,
        """
        Killing an opponent with a buddy is easier then doing it on your own.
        """
        ,
        """
        You should always go for the open planet when you are carrying.
        """
        ,
        """
        It's dangerous to underestimate opponents or overestimate teammates.
        """
        ,
        """
        Sometimes you just have to hope that they miss.
        """
        ,
        """
        You should not cloak in your own backfield; you will only fool your teammates.
        """
        ,
        """
        You should send a single distress call after you pick up armies to let your team know that you carry.
        """
        ,
        """
        Escorts should stay between the ogger and the carrier.
        """
        ,
        """
        You should never kill an ogger who is out of fuel or crippled.
        """
        ,
        """
        You should get near their planets.
        """
        ,
        """
        You should use the space people give away when running.
        """
        ,
        """
        You should think globally and act locally.
        """
        ,
        """
        You're not pac-man: do not eat the dots.
        """
        ,
        """
        You should always shoot at cloakers.
        """
        ,
        """
        You should watch the galactic map at all times.
        """
        ,
        """
        You should always tractor enemies off planets.
        """
        ,
        """
        You should never pass up an opportunity to bomb.
        """
        ,
        """
        You can't be everywhere at once.
        """
        ,
        """
        You should not fixate on one target.
        """
        ,
        """
        Planning is good, but opportunism is better.
        """
        ,
        """
        If an enemy is annoying you by what he is doing, you should consider adopting his strategy.
        """
        ,
        """
        You should not argue about which planet to take.
        """
        ,
        """
        Nobody completely understands the game. Certainly not you.
        """
        ,
        """
        You should not tell others what to do.
        """
        ,
        """
        You should fly at maximum warp to your destination unless you need to turn.
        """
        ,
        """
        "Shut up and play" often is a wise tactic.
        """
        ,
        """
        You should not waste your fuel firing torpedos that the enemy will dodge.
        """
        ,
        """
        Nobody can dodge phasers.
        """
        ,
        """
        Instead of flying in circles, you should stop and repair; you'll save fuel.
        """
        ,
        """
        You should do the easy things first.
        """
        ,
        """
        You should always shoot the escort first.
        """
        ,
        """
        You should try to fight past the enemy's front-line planets.
        """
        ,
        """
        Death is only a temporary setback.
        """
        ,
        """
        The lines are better than the dots, but the dots go farther.
        """
        ,
        """
        You should not keep beating your head against the same wall.
        """
        ,
        """
        You can run from multiple oggers almost as easily as from one.
        """
        ,
        """
        You should never go out to third space to escort.
        """
        ,
        """
        You can't make your teammates more clueful, no matter what you type.
        """
        ,
        """
        You should not chase ships. Be content to occupy the space they left you.
        """
        ,
        """
        You should not fly to lost plays. You're too late, do something more useful instead.
        """
        ,
        """
        If you carry armies, you should not go to the same planet another carrier on your team already called.
        """
        ,
        """
        You should not react to their game, but play your own game.
        """
        ,
        """
        Plasma is for twinks.
        """
        ,
        """
        You should use the dots to make your lines hit.
        """
        ,
        """
        You can fire torps in the path of your opponent to force them to slow down.
        """
        ,
        """
        If you phaser every second you'll win most dogfights.
        """
        ,
        """
        All the experts fire their next phaser right after the last phaser died away for maximum efficiency.
        """
        ,
        """
        Phasers have a constant cycle time. Learn this and laser faster than your opponent.
        """
        ,
        """
        Skill does not equal clue.
        """
        ,
        """
        You should not celebrate dooshes when you are on the team that is cored.
        """
        ,
        """
        Cloaking does not make you invincible.
        """
        ,
        """
        Fuel is your friend. Treasure it.
        """
        ,
        """
        You can det for a carrier even if you are almost out of fuel.
        """
        ,
        """
        Detting only takes 100 fuel. Spending that 100 fuel on a det can make your carrier very happy.
        """
        ,
        """
        Dying is the fastest way of repairing and refueling.
        """
        ,
        """
        The best way to defend a starbase is to aggressively attack the enemy oggers.
        """
        ,
        """
        You should attack them. Yes, you.
        """
        ,
        """
        Buttorping is stupid, unless you are the carrier.
        """
        ,
        """
        Rank does not equal clue.
        """
        ,
        """
        You should 1) Maxwarp to the front. 2) Face forward. 3) Attack. 4) Do not buttorp. 5) Die. 6) Goto 1).
        """
        ,
        """
        Practice makes perfect.
        """
        ,
        """
        Nobody said this was easy.
        """
        ,
        """
        There is no I in team.
        """
        ,
        """
        It is always a good idea to fly into enemy space.
        """
        ,
        """
        You should never let an enemy CA live in your backfield.
        """
        ,
        """
        You should never chase a SC bomber with 0 kills. You can't catch it.
        """
        ,
        """
        If you feel useless, you can always grab a SC and start SC bombing. People will love you for it.
        """
        ,
        """
        When you are SC bombing, your job is not to engage enemy ships, but solely trying to bomb as many armies as possible.
        """
        ,
        """
        Starbases are not toys. Do not fly one if you do not know how to fly one. Ask your team if it's ok for you to try one out.
        """
        ,
        """
        If a starbase dies, it takes 30 minutes to get a new one. Ask your team if it's ok for you to try one out.
        """
        ,
        """
        Information is the most valuable commodity in netrek. Use the teamboard. Read it. Write to it.
        """
        ,
        """
        You should not be afraid to admit that you screwed up. Trust us, everyone else knows you did.
        """
        ,
        """
        Having a thick skin helps. Saying "sorry, I'm new" if you're being yelled at can work wonders.
        """
        ,
        """
        Everyone has a bad day, try not to take things personally.
        """
        ,
        """
        You should learn to recognize the good players by their login IDs and player handles. They are the best way to get better at this game. Watch them and/or talk to them.
        """
        ,
        """
        Dying is a good thing (in netrek anyways).
        """
        ,
        """
        If you are down to 5 planets or less, you should only bomb the planets outside of your core five. Let the more experienced players decide when to bomb the other ones.
        """
        ,
        """
        A cruiser (CA), can fly up to warp 9, has 10,000 fuel, 100 hull, 100 shields, 40 pt torps and can do up to 100 pt maximum phaser damage.
        """
        ,
        """
        An assault ship (AS), can fly up to warp 8, has 6,000 fuel, 200 hull, 80 shields, 30 pt torps and can do up to 80 pt maximum phaser damage.
        """
        ,
        """
        A battle ship (BB), can fly up to warp 8, has 14,000 fuel, 130 hull, 130 shields, 40 pt torps and can do up to 105 pt maximum phaser damage.
        """
        ,
        """
        A scout (SC), can fly up to warp 12, has 5,000 fuel, 75 hull, 75 shields, 25 pt torps and can do up to 75 pt maximum phaser damage.
        """
        ,
        """
        A destroyer (DD), can fly up to warp 10, has 7,000 fuel, 85 hull, 85 shields, 30 pt torps and can do up to 85 pt maximum phaser damage.
        """
        ,
        """
        A starbase (SB), can fly up to warp 2, has 60,000 fuel, 600 hull, 500 shields, 30 pt torps and can do up to 120 pt maximum phaser damage.
        """
        ,
        """
        Assault ships have the best cloaking capabilities in the game and are mainly used for taking heavily guarded planets.
        """
        ,
        """
        Battleships have the strongest fire power of non-star bases, but they must operate near a fuel planet to be effective.
        """
        ,
        """
        Cruisers are the most well rounded ship, having high firepower and good maneuverability.
        """
        ,
        """
        Destroyers are best used only by experienced players. In most situations, a cruiser is the right ship choice.
        """
        ,
        """
        Scouts offer the fastest speed and maneuverability, but are best used for bombing or taking. They are too brittle to be used for space controlling.
        """
        ,
        """
        Starbases are the strongest ships in terms of fire power and can only be killed by a concentrated team effort.
        """
        ,
        """
        Starbases can fire phasers more than twice as fast as any other ship.
        """
        ,
        """
        "To ogg" means, the process of cloaking and appearing adjacent to an enemy while firing torps and tractoring on to him, with the purpose to kill that player, without caring about dying in the process.
        """
        ,
        """
        "To doosh" means, killing an enemy ship which is carrying armies. People often yell "doosh!" after they kill a huge carrier.
        """
        ,
        """
        A "planet scum" is someone who only cares about taking planets so he gets good ratings. This often hurts the team because the wrong planets are taken, or the planets are taken with little armies and easily captured back.
        """
    ]
    
}
