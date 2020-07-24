//
//  PlayerView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PlayerStrategicView: View, StrategicOffset {
    var player: Player
    @ObservedObject var updateCounter = Universe.universe.seconds
    var body: some View {
        return GeometryReader { geo in
            Text(self.playerText).foregroundColor(self.playerColor)
            .offset(x: self.screenX(netrekPositionX: self.player.positionX, screenWidth: geo.size.width), y: self.screenY(netrekPositionY: self.player.positionY, screenHeight: geo.size.height))
        }
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
    /*func screenX(netrekPositionX: Int,screenWidth: CGFloat) -> CGFloat {
        return (screenWidth * CGFloat(netrekPositionX) / CGFloat(NetrekMath.galacticSize)) - screenWidth / 2
    }
    func screenY(netrekPositionY: Int,screenHeight: CGFloat) -> CGFloat {
        return -(screenHeight * CGFloat(netrekPositionY) / CGFloat(NetrekMath.galacticSize)) + screenHeight / 2
    }*/

}

/*struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}*/
