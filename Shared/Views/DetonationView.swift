//
//  DetonationView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/31/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct DetonationView: View, TacticalOffset {
    @ObservedObject var torpedo: Torpedo
    @ObservedObject var me: Player
    @State var scale: CGFloat = 0.0
    @State var opacity: Double = 1.0
    
    var body: some View {
        return GeometryReader { geo in
            Circle()
                .scale(self.scale)
                .fill(Color.red)
                .opacity(self.opacity)
                .frame(width: self.torpedoWidth(screenWidth: geo.size.width * 1.1), height: self.torpedoWidth(screenWidth: geo.size.height * 1.1 ))
            .offset(x: self.xOffset(positionX: self.torpedo.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.torpedo.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
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
