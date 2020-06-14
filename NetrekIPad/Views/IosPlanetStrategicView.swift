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
            Text(self.planet.shortName).foregroundColor(NetrekMath.color(team: self.planet.owner)).fontWeight(self.planet.armies > 4 ? .heavy : .regular)
        }
            .opacity(self.opacity)
    }
    var distance: Double {
        let xDiff = Double(abs(me.positionX - planet.positionX))
        let yDiff = Double(abs(me.positionY - planet.positionY))
        let distance = sqrt(xDiff * xDiff + yDiff * yDiff)
        return 100 * distance / Double(NetrekMath.galacticSize)
    }
    var opacity: Double {
        if self.visible == false {
            return 0
        } else {
            switch self.distance {
            case 0..<100:
                return 1.0 - distance / 70
            case 100...:
                return 0.0
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
        if abs(me.positionX - planet.positionX) > NetrekMath.visualDisplayDistance * 2 {
            return false
        }
        if abs(me.positionY - planet.positionY) > NetrekMath.visualDisplayDistance * 2 {
            return false
        }

        if abs(me.positionX - planet.positionX) > NetrekMath.visualDisplayDistance {
            return true
        }
        if abs(me.positionY - planet.positionY) > NetrekMath.visualDisplayDistance {
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
