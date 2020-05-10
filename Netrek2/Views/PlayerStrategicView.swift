//
//  PlayerView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PlayerStrategicView: View, StrategicOffset {
    @ObservedObject var player: Player
    var body: some View {
        return GeometryReader { geo in
            Text(self.playerText).foregroundColor(NetrekMath.color(team: self.player.team))
            .offset(x: self.screenX(netrekPositionX: self.player.positionX, screenWidth: geo.size.width), y: self.screenY(netrekPositionY: self.player.positionY, screenHeight: geo.size.height))

        }
    }
    var playerText: String {
        let playerLetter = NetrekMath.playerLetter(playerId: player.playerId)
        let teamLetter = NetrekMath.teamLetter(team: player.team)
        return teamLetter + playerLetter
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
