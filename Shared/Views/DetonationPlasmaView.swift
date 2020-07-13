//
//  DetonationPlasmaView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/31/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct DetonationPlasmaView: View, TacticalOffset {
    @ObservedObject var plasma: Plasma
    @ObservedObject var me: Player
    @ObservedObject var universe: Universe
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    @State var scale: CGFloat = 0.0
    @State var opacity: Double = 1.0
    
    var body: some View {
        return GeometryReader { geo in
            Circle()
                .scale(self.scale)
                .fill(Color.red)
                .opacity(self.opacity)
                .frame(width: self.plasmaWidth(screenWidth: geo.size.width,visualWidth: self.universe.visualWidth), height: self.plasmaWidth(screenWidth: geo.size.height, visualWidth: self.universe.visualWidth))
                .offset(x: self.xOffset(positionX: self.plasma.positionX, myPositionX: self.me.positionX,tacticalWidth: self.screenWidth, visualWidth: self.universe.visualWidth), y: self.yOffset(positionY: self.plasma.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height, visualHeight: self.universe.visualWidth * self.screenHeight / self.screenWidth))
        }.onAppear {
            return withAnimation(.linear(duration: 1.0)) {
                self.scale = 6
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
