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
    @ObservedObject var universe: Universe
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    @State var phase: CGFloat = 0
    
    var body: some View {
        return GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.xOffset(positionX: self.target.positionX, myPositionX: self.me.positionX, tacticalWidth: self.screenWidth, visualWidth: self.universe.visualWidth),y: self.yOffset(positionY: self.target.positionY, myPositionY: self.me.positionY, tacticalHeight: self.screenHeight, visualHeight: self.universe.visualWidth * self.screenHeight / self.screenWidth)))
            }.offset(x: geo.size.width / 2, y: geo.size.height / 2)
                .stroke(self.me.pressor ? Color.blue : Color.green, style: StrokeStyle(lineWidth: self.playerWidth(screenWidth: geo.size.width, visualWidth: self.universe.visualWidth),dash: [self.playerWidth(screenWidth: geo.size.width, visualWidth: self.universe.visualWidth)], dashPhase: self.phase))
                .opacity(0.5)
                .onAppear { self.phase = self.me.pressor ? self.playerWidth(screenWidth: geo.size.width,visualWidth: self.universe.visualWidth) : self.playerWidth(screenWidth: geo.size.width * -1, visualWidth: self.universe.visualWidth) }
            .animation(Animation.linear.repeatForever(autoreverses: false))
        }
    }
}

/*struct TractorView_Previews: PreviewProvider {
    static var previews: some View {
        TractorView()
    }
}*/
