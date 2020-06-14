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
    var distance: Double {
        let xDiff = Double(abs(me.positionX - player.positionX))
        let yDiff = Double(abs(me.positionY - player.positionY))
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
        if abs(me.positionX - player.positionX) > NetrekMath.visualDisplayDistance * 2 {
            return false
        }
        if abs(me.positionY - player.positionY) > NetrekMath.visualDisplayDistance * 2 {
            return false
        }

        if abs(me.positionX - player.positionX) > NetrekMath.visualDisplayDistance {
            return true
        }
        if abs(me.positionY - player.positionY) > NetrekMath.visualDisplayDistance {
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
