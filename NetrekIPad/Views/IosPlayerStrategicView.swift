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
        Text(self.playerText)
            .foregroundColor(self.playerColor)
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
