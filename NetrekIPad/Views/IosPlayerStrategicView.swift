//
//  IosPlayerStrategicView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/13/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct IosPlayerStrategicView: View {
    @ObservedObject var player: Player
    @ObservedObject var me: Player
    @ObservedObject var universe: Universe
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    static func xPos(me: Player, player: Player, size: CGSize) -> CGFloat {
        var angle: CGFloat
        if player.positionX - me.positionX == 0 {
            angle = 90
        } else {
            angle = atan(CGFloat(player.positionY - me.positionY) / CGFloat(player.positionX - me.positionX))
        }
        if me.positionX > player.positionX {
            angle = angle + CGFloat.pi
        }
        return (cos(angle) * size.width * 0.45)
    }
    static func yPos(me: Player, player: Player, size: CGSize) -> CGFloat {
        var angle: CGFloat
        if player.positionX - me.positionX == 0 {
            angle = 90
        } else {
            angle = atan(CGFloat(player.positionY - me.positionY) / CGFloat(player.positionX - me.positionX))
        }
        if me.positionX > player.positionX {
            angle = angle + CGFloat.pi
        }
        return (sin(angle) * size.height * -0.45)
    }

    var body: some View {
        VStack {
            Text(self.playerText)
                .fontWeight(self.visible && self.player.kills > 1.9 ? .bold : .regular)
        }.foregroundColor(self.playerColor)
            .opacity(self.opacity)
    }
    var distance: Double {  // returns distance in terms of "half visual display distance" units
        let xDiff = CGFloat(abs(me.positionX - player.positionX)) / (universe.visualWidth * 0.5)
        let yDiff = CGFloat(abs(me.positionY - player.positionY)) / (universe.visualWidth * 0.5 * screenHeight / screenWidth)
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
        if abs(me.positionX - player.positionX) > Int(self.universe.visualWidth * 2) {
            return false
        }
        if abs(me.positionY - player.positionY) > Int(self.universe.visualWidth * 2 * screenHeight / screenWidth) {
            return false
        }

        if abs(me.positionX - player.positionX) > Int(self.universe.visualWidth) / 2 {
            return true
        }
        if abs(me.positionY - player.positionY) > Int(self.universe.visualWidth * screenHeight / (screenWidth * 2)) {
            return true
        }
        return false
    }
    var playerColor: Color {
        if player.cloak == true {
            return Color.gray
        } else {
            return NetrekMath.color(team: self.player.team)
        }
    }
    var playerText: String {
        if player.cloak == true {
            return "??"
        } else {
            let playerLetter = NetrekMath.playerLetter(playerId: player.playerId)
            let teamLetter = NetrekMath.teamLetter(team: player.team)
            return teamLetter + playerLetter
        }
    }

}

/*struct IosPlayerStrategicView_Previews: PreviewProvider {
    static var previews: some View {
        IosPlayerStrategicView()
    }
}*/
