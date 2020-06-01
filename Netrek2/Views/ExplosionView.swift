//
//  ExplosionView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/31/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct ExplosionView: View, TacticalOffset {
    @ObservedObject var player: Player
    @ObservedObject var me: Player
    @State var scale: CGFloat = 0.0
    @State var opacity: Double = 1.0
    
    var body: some View {
        return GeometryReader { geo in
            Circle()
                .scale(self.scale)
                .fill(Color.orange)
                .opacity(self.opacity)
                .frame(width: self.playerWidth(screenWidth: geo.size.width * 1.1), height: self.playerWidth(screenWidth: geo.size.height * 1.1 ))
            .offset(x: self.xOffset(positionX: self.player.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.player.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
        }.onAppear {
            return withAnimation(.linear(duration: 1.0)) {
                self.scale = 3
                self.opacity = 0.0
            }
        }
    }
}

/*struct ExplosionView_Previews: PreviewProvider {
    static var previews: some View {
        ExplosionView()
    }
}*/
