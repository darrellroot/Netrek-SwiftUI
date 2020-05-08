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
            VStack {
                //self.planet.image
                Image(self.player.imageName)
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.playerWidth(screenWidth: geo.size.width), height: self.playerWidth(screenWidth: geo.size.height))
                    .rotationEffect(Angle(radians: self.player.direction))
                Text(self.player.name)
            }
            .offset(x: self.xOffset(positionX: self.player.positionX, myPositionX: self.me.positionX,geo: geo), y: self.yOffset(positionY: self.player.positionY, myPositionY: self.me.positionY, geo: geo))
            //.animation(Animation.linear)

        }
    }
}

/*struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}*/
