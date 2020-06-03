//
//  PlayerView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PlayerView: View, TacticalOffset {
    @ObservedObject var player: Player
    @ObservedObject var me: Player
    var body: some View {
        return GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(Color.green)
                    .frame(width: self.playerWidth(screenWidth: geo.size.width * 1.1), height: self.playerWidth(screenWidth: geo.size.height * 1.1 ))
                    .opacity(self.player.shieldsUp ? 1.0 : 0.0)
                VStack {
                    //self.planet.image
                    Text(self.player.name).foregroundColor(NetrekMath.color(team: self.player.team))
                    Image(self.player.imageName)
                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.playerWidth(screenWidth: geo.size.width), height: self.playerWidth(screenWidth: geo.size.height))
                        .rotationEffect(Angle(radians: -self.player.direction))
                    Text("\(self.player.ship?.description ?? "") \(self.player.kills, specifier: "%.2f")").foregroundColor(NetrekMath.color(team: self.player.team))
                }
            }
            .opacity(self.player.cloak && self.me === self.player ? 0.4 : 1.0)
            .opacity(self.player.cloak && self.me !== self.player ? 0.0 : 1.0)
            .offset(x: self.xOffset(positionX: self.player.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.player.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
            .animation(Animation.linear)

        }
    }
}

/*struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}*/
