//
//  BoundaryView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/4/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct BoundaryView: View, TacticalOffset {
    @ObservedObject var me: Player
    
    var body: some View {
        return GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: self.xOffset(positionX: 0, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: 0 ,myPositionY: self.me.positionY, tacticalHeight: geo.size.width)))
                path.addLine(to: CGPoint(x: self.xOffset(positionX: NetrekMath.galacticSize, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: 0 ,myPositionY: self.me.positionY, tacticalHeight: geo.size.width)))
                path.addLine(to: CGPoint(x: self.xOffset(positionX: NetrekMath.galacticSize, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: NetrekMath.galacticSize ,myPositionY: self.me.positionY, tacticalHeight: geo.size.width)))
                path.addLine(to: CGPoint(x: self.xOffset(positionX: 0, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: NetrekMath.galacticSize ,myPositionY: self.me.positionY, tacticalHeight: geo.size.width)))
                path.addLine(to: CGPoint(x: self.xOffset(positionX: 0, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: 0,myPositionY: self.me.positionY, tacticalHeight: geo.size.width)))
            }.offset(x: geo.size.width / 2, y: geo.size.height / 2)
            .stroke(Color.blue,style:  StrokeStyle(lineWidth: self.playerWidth(screenWidth: geo.size.width * 1.1)))
                .opacity(0.5)
        }
    }
}

/*struct BoundaryView_Previews: PreviewProvider {
    static var previews: some View {
        BoundaryView()
    }
}*/
