//
//  TractorView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/3/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TractorView: View, TacticalOffset {
    @ObservedObject var target: Player
    @ObservedObject var me: Player
    @State var phase: CGFloat = 0
    
    var body: some View {
        return GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.xOffset(positionX: self.target.positionX, myPositionX: self.me.positionX, tacticalWidth: geo.size.width),y: self.yOffset(positionY: self.target.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height)))
            }.offset(x: geo.size.width / 2, y: geo.size.height / 2)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: self.playerWidth(screenWidth: geo.size.width * 1.1),dash: [self.playerWidth(screenWidth: geo.size.width * 1.1)], dashPhase: self.phase))
                .opacity(0.5)
            .onAppear { self.phase = self.playerWidth(screenWidth: geo.size.width * 1.1) }
            .animation(Animation.linear.repeatForever(autoreverses: false))
        }
    }
}

/*struct TractorView_Previews: PreviewProvider {
    static var previews: some View {
        TractorView()
    }
}*/
