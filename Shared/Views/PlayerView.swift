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
    @ObservedObject var universe: Universe
    var imageSize: CGFloat
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    
    #if os(macOS)
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif

    
    var body: some View {
        return GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke(Color.green)
                    .frame(width: self.imageSize, height: self.imageSize)
                    .opacity(self.player.shieldsUp ? 1.0 : 0.0)
                    .opacity(Double(self.player.shieldStrength) / 100.0)
                VStack {
                    //self.planet.image
                    Text(self.player.name).minimumScaleFactor(0.7).foregroundColor(NetrekMath.color(team: self.player.team))
                    Image(self.player.imageName)
                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.imageSize, height: self.imageSize)
                        .rotationEffect(Angle(radians: -self.player.direction))
                    Text("\(self.player.ship?.description ?? "") \(self.player.kills, specifier: "%.2f")").minimumScaleFactor(0.7).foregroundColor(NetrekMath.color(team: self.player.team))
                }
            }
            .opacity(self.player.cloak && self.me === self.player ? 0.4 : 1.0)
            .opacity(self.player.cloak && self.me !== self.player ? 0.1 : 1.0)
            //.offset(x: self.xOffset(positionX: self.player.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.player.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
                .offset(x: self.xOffset(positionX: self.player.positionX, myPositionX: self.me.positionX,tacticalWidth: self.screenWidth, visualWidth: self.universe.visualWidth), y: self.yOffset(positionY: self.player.positionY, myPositionY: self.me.positionY, tacticalHeight: self.screenHeight, visualHeight: self.universe.visualWidth * self.screenHeight / self.screenWidth))

            .animation(Animation.linear)

        }
    }
}

/*struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}*/
