//
//  IosPlanetStrategicView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/13/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct IosPlanetStrategicView: View {
    @ObservedObject var planet: Planet
    @ObservedObject var me: Player
    @ObservedObject var universe: Universe
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    
    static func xPos(me: Player, planet: Planet, size: CGSize) -> CGFloat {
        var angle: CGFloat
        if planet.positionX - me.positionX == 0 {
            angle = 90
        } else {
            angle = atan(CGFloat(planet.positionY - me.positionY) / CGFloat(planet.positionX - me.positionX))
        }
        if me.positionX > planet.positionX {
            angle = angle + CGFloat.pi
        }
        return (cos(angle) * size.width * 0.45)
    }
    static func yPos(me: Player, planet: Planet, size: CGSize) -> CGFloat {
        var angle: CGFloat
        if planet.positionX - me.positionX == 0 {
            angle = 90
        } else {
            angle = atan(CGFloat(planet.positionY - me.positionY) / CGFloat(planet.positionX - me.positionX))
        }
        if me.positionX > planet.positionX {
            angle = angle + CGFloat.pi
        }
        return (sin(angle) * size.height * -0.45)
    }

    var body: some View {
        VStack {
            //Text(self.planet.shortName).foregroundColor(NetrekMath.color(team: self.planet.owner)).fontWeight(self.planet.armies > 4 ? .heavy : .light)
            Text(self.planet.shortName).foregroundColor(self.planet.seen[self.me.team]! ? NetrekMath.color(team: self.planet.owner) : .gray).fontWeight((self.planet.armies > 4 && self.planet.seen[self.me.team]!) ? .heavy : .regular)
        }
            .opacity(self.opacity)
    }
    var distance: Double {  // returns distance in terms of "half visual display distance" units
        let xDiff = CGFloat(abs(me.positionX - planet.positionX)) / (universe.visualWidth * 0.5)
        let yDiff = CGFloat(abs(me.positionY - planet.positionY)) / (universe.visualWidth * 0.5 * screenHeight / screenWidth)
        let distance = sqrt(xDiff * xDiff + yDiff * yDiff)
        return Double(distance)
    }
    var opacity: Double {
        if self.visible == false {
            return 0
        } else {
            switch self.distance {
            case 0..<1:
                return 1.0
            case 1..<3:
                return 1 - ((self.distance - 1.0) / 2)
            case 3...:
                return 0
            case ...0:
                //should not get here
                return 1.0
            default:
                //should not get here
                debugPrint("invalid distance \(distance)")
                return 1.0
            }
        }
    }
    var visible: Bool {
        if abs(me.positionX - planet.positionX) > Int(self.universe.visualWidth * 2) {
            return false
        }
        if abs(me.positionY - planet.positionY) > Int(self.universe.visualWidth * 2 * screenHeight / screenWidth) {
            return false
        }

        if abs(me.positionX - planet.positionX) > Int(self.universe.visualWidth) / 2 {
            return true
        }
        if abs(me.positionY - planet.positionY) > Int(self.universe.visualWidth * screenHeight / (screenWidth * 2)) {
            return true
        }
        return false
    }

}

/*struct IosPlayerStrategicView_Previews: PreviewProvider {
    static var previews: some View {
        IosPlayerStrategicView()
    }
}*/
