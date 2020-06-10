//
//  PlasmaView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PlasmaView: View, TacticalOffset {
    @ObservedObject var plasma: Plasma
    @ObservedObject var me: Player
    //@ViewBuilder
    var body: some View {
        //if torpedo.status == 1 {
            return GeometryReader { geo in
                self.plasma.color
                    .frame(width: self.plasmaWidth(screenWidth: geo.size.width), height: self.plasmaWidth(screenWidth: geo.size.height))
                        .contentShape(Rectangle())
                    .offset(x: self.xOffset(positionX: self.plasma.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.plasma.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
                .opacity(self.plasma.status == 1 ? 1 : 0)
                    //.animation(Animation.linear)
            }
        //}
    }
}

/*struct TorpedoView_Previews: PreviewProvider {
    static var previews: some View {
        TorpedoView()
    }
}*/
