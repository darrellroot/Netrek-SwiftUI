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
        return GeometryReader { geo in
            VStack {
                //self.planet.image
                Image(self.planet.imageName)
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.planetWidth(screenWidth: geo.size.width), height: self.planetWidth(screenWidth: geo.size.height))
                    .colorMultiply(Color.red)
                    .contentShape(Rectangle())
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
