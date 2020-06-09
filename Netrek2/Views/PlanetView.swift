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
    var imageSize: CGFloat
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    var body: some View {
        return GeometryReader { geo in
            VStack {
                Text(" ")
                Image(self.planet.imageName)
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(width: self.planetWidth(screenWidth: geo.size.width), height: self.planetWidth(screenWidth: geo.size.height))
                    .colorMultiply(NetrekMath.color(team: self.planet.owner))
                    .contentShape(Rectangle())
                Text(self.planet.name)
            }
            //.offset(x: self.xOffset(positionX: self.planet.positionX, myPositionX: self.me.positionX,tacticalWidth: geo.size.width), y: self.yOffset(positionY: self.planet.positionY, myPositionY: self.me.positionY, tacticalHeight: geo.size.height))
            .offset(x: self.xOffset(positionX: self.planet.positionX, myPositionX: self.me.positionX,tacticalWidth: self.screenWidth), y: self.yOffset(positionY: self.planet.positionY, myPositionY: self.me.positionY, tacticalHeight: self.screenHeight))

            .animation(Animation.linear)
        }
        
    }
    
}

/*struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}*/
