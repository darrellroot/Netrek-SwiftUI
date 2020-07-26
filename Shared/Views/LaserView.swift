//
//  TorpedoView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct LaserView: View, TacticalOffset {
    @State var opacity = 1.0
    @ObservedObject var laser: Laser
    @ObservedObject var me: Player
    @ObservedObject var universe: Universe
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    //@ViewBuilder
    var body: some View {
        //if torpedo.status == 1 {
            return GeometryReader { geo in
                /*Path { path in
                    debugPrint("drawing laser")
                    path.move(to: CGPoint(x: 20, y: 20))
                    path.addLine(to: CGPoint(x:300, y: 300))*/
                Path { path in
                    path.move(to: CGPoint(x: self.xAbsolute(positionX: self.laser.positionX, myPositionX: self.me.positionX, tacticalWidth: self.screenWidth, visualWidth: self.universe.visualWidth), y: self.yAbsolute(positionY: self.laser.positionY, myPositionY: self.me.positionY, tacticalHeight: self.screenHeight, visualHeight: self.universe.visualWidth * self.screenHeight / self.screenWidth)))
                    path.addLine(to: CGPoint(x: self.xAbsolute(positionX: self.laser.targetPositionX, myPositionX: self.me.positionX, tacticalWidth: self.screenWidth, visualWidth: self.universe.visualWidth), y: self.yAbsolute(positionY: self.laser.targetPositionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height, visualHeight: self.universe.visualWidth * self.screenHeight / self.screenWidth)))
                }.stroke(Color.red, lineWidth: 3)

            
                        .contentShape(Rectangle())
                    .opacity(self.opacity)
                    .onAppear() {
                        self.opacity = 0.0
                }
                .animation(Animation.linear(duration: 1.0))
            }
        //}
    }
    func sourceX(tacWidth: CGFloat) -> CGFloat {
        guard let netrekSourceX = Universe.universe.players[safe: self.laser.laserId]?.positionX else { return 0.0 }
        //guard let netrekSourceY = appDelegate.universe.players[safe: self.laser.laserId]?.positionY else { return }
        let screenSourceX = self.xOffset(positionX: netrekSourceX, myPositionX: self.me.positionX,tacticalWidth: tacWidth, visualWidth: self.universe.visualWidth)
        if laser.laserId == Universe.universe.me { debugPrint("laser positionX \(self.laser.positionX) myPositionX \(self.me.positionX) tacWidth \(tacWidth) x \(screenSourceX)")
        }
        return screenSourceX
    }
    func sourceY(tacHeight: CGFloat) -> CGFloat {
        //guard let netrekSourceX = Universe.universe.players[safe: self.laser.laserId]?.positionX else { return 0.0 }
        guard let netrekSourceY = Universe.universe.players[safe: self.laser.laserId]?.positionY else { return 0.0 }
        let screenSourceY = self.yOffset(positionY: netrekSourceY, myPositionY: self.me.positionY,tacticalHeight: tacHeight, visualHeight: self.universe.visualWidth * self.screenHeight / self.screenWidth)
        if laser.laserId == Universe.universe.me {
            debugPrint("laser positionY \(self.laser.positionY) myPositionY \(self.me.positionY) tacWidth \(tacHeight) x \(screenSourceY)")
        }

        return screenSourceY
    }

}

/*struct TorpedoView_Previews: PreviewProvider {
    static var previews: some View {
        TorpedoView()
    }
}*/
