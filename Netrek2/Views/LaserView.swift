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
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 100, y: 100))
                }.stroke(Color.red, lineWidth: 3)

            
                    //.frame(width: self.torpedoWidth(screenWidth: geo.size.width), height: self.torpedoWidth(screenWidth: geo.size.height))
                        .contentShape(Rectangle())
                .offset(x: self.sourceX(tacWidth: geo.size.width), y: self.sourceY(tacHeight: geo.size.height))
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
