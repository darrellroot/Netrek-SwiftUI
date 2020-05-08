//
//  TorpedoView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TorpedoView: View, TacticalOffset {
    @ObservedObject var torpedo: Torpedo
    @ObservedObject var me: Player
    //@ViewBuilder
    var body: some View {
        //if torpedo.status == 1 {
            return GeometryReader { geo in
                Color.red
                    .frame(width: self.torpedoWidth(screenWidth: geo.size.width), height: self.torpedoWidth(screenWidth: geo.size.height))
                        .colorMultiply(Color.red)
                        .contentShape(Rectangle())
                .offset(x: self.xOffset(positionX: self.torpedo.positionX, myPositionX: self.me.positionX,geo: geo), y: self.yOffset(positionY: self.torpedo.positionY, myPositionY: self.me.positionY, geo: geo))
                .opacity(self.torpedo.status == 1 ? 1 : 0)
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
