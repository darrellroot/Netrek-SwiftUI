//
//  TorpedoView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct LaserView: View, TacticalOffset {
    let appDelegate = NSApplication.shared.delegate! as! AppDelegate
    
    @ObservedObject var laser: Laser
    @ObservedObject var me: Player
    //@ViewBuilder
    var body: some View {
        //if torpedo.status == 1 {
            return GeometryReader { geo in
                /*Path { path in
                    debugPrint("drawing laser")
                    path.move(to: CGPoint(x: 20, y: 20))
                    path.addLine(to: CGPoint(x:300, y: 300))*/
                Path { path in
                    path.move(to: CGPoint(x: self.xAbsolute(positionX: self.laser.positionX, myPositionX: self.me.positionX, tacticalWidth: geo.size.width), y: self.yAbsolute(positionY: self.laser.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height)))
                    path.addLine(to: CGPoint(x: self.xAbsolute(positionX: self.laser.targetPositionX, myPositionX: self.me.positionX, tacticalWidth: geo.size.width), y: self.yAbsolute(positionY: self.laser.targetPositionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height)))
                    /*if self.laser.laserId == self.appDelegate.universe.me && self.laser.status != 0 {
                        debugPrint("laser my position \(self.me.positionX) \(self.me.positionY)")
                        debugPrint("laser start \(self.laser.positionX) \(self.laser.positionY)")
                        debugPrint("laser end \(self.laser.targetPositionX) \(self.laser.targetPositionY)")
                        debugPrint("laser stats \(self.laser.status) \(self.xAbsolute(positionX: self.laser.positionX, myPositionX: self.me.positionX, tacticalWidth: geo.size.width)) \(self.yAbsolute(positionY: self.laser.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height)) \(self.xAbsolute(positionX: self.laser.targetPositionX, myPositionX: self.me.positionX, tacticalWidth: geo.size.width))  \(self.yAbsolute(positionY: self.laser.targetPositionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))")
                    }*/
                }.stroke(Color.red, lineWidth: 3)

            
                    //.frame(width: self.torpedoWidth(screenWidth: geo.size.width), height: self.torpedoWidth(screenWidth: geo.size.height))
                        .contentShape(Rectangle())
                    //.offset(x: self.viewXOffset(positionX: self.laser.positionX, myPositionX: self.me.positionX, tacticalWidth: geo.size.width), y: self.viewYOffset(positionY: self.laser.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
                    //.offset(x: self.xOffset(positionX: self.laser.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.laser.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
                .opacity(self.laser.status != 0 ? 1 : 0)
                    //.animation(Animation.linear)
            }
        //}
    }
    func sourceX(tacWidth: CGFloat) -> CGFloat {
        guard let netrekSourceX = appDelegate.universe.players[safe: self.laser.laserId]?.positionX else { return 0.0 }
        //guard let netrekSourceY = appDelegate.universe.players[safe: self.laser.laserId]?.positionY else { return }
        let screenSourceX = self.xOffset(positionX: netrekSourceX, myPositionX: self.me.positionX,tacticalWidth: tacWidth)
        if laser.laserId == appDelegate.universe.me { debugPrint("laser positionX \(self.laser.positionX) myPositionX \(self.me.positionX) tacWidth \(tacWidth) x \(screenSourceX)")
        }
        return screenSourceX
    }
    func sourceY(tacHeight: CGFloat) -> CGFloat {
        //guard let netrekSourceX = appDelegate.universe.players[safe: self.laser.laserId]?.positionX else { return 0.0 }
        guard let netrekSourceY = appDelegate.universe.players[safe: self.laser.laserId]?.positionY else { return 0.0 }
        let screenSourceY = self.yOffset(positionY: netrekSourceY, myPositionY: self.me.positionY,tacticalHeight: tacHeight)
        if laser.laserId == appDelegate.universe.me {
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
