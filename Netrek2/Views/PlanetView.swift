//
//  PlanetView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PlanetView: View, TacticalOffset {
    @ObservedObject var planet: Planet
    @ObservedObject var me: Player
    var body: some View {
        GeometryReader { geo in
            VStack {
                Circle()
                    .foregroundColor(Color.red)
                    .frame(width: 40, height: 40, alignment: .center)
                Text(self.planet.name)
            }
            .offset(x: self.xOffset(positionX: self.planet.positionX, myPositionX: self.me.positionX,geo: geo), y: self.yOffset(positionY: self.planet.positionY, myPositionY: self.me.positionY, geo: geo))
        }
    }
}

/*struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}*/
