//
//  PlanetView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PlanetView: View {
    @ObservedObject var planet: Planet
    @ObservedObject var me: Player
    var body: some View {
        GeometryReader { geo in
            VStack {
                Circle()
                    .foregroundColor(Color.red)
                Text(self.planet.name)
            }
            .frame(width: 40, height: 40, alignment: .center)
            .offset(x: self.xOffset(geo: geo), y: self.yOffset(geo: geo))

        }
    }
    func xOffset(geo: GeometryProxy) -> CGFloat {
        let viewPositionX: Int
        if me.positionX > -20000 && me.positionX < 20000 {
            viewPositionX = me.positionX
        } else {
            viewPositionX = 5000
        }
        let x = CGFloat(planet.positionX - viewPositionX) * (CGFloat(NetrekMath.displayDistance) / CGFloat(NetrekMath.galacticSize)) * geo.size.width / 1000
        debugPrint("planet \(planet.name) xpos \(planet.positionX) mx \(me.positionX) x \(x)")
        return x
    }
    func yOffset(geo: GeometryProxy) -> CGFloat {
        let viewPositionY: Int
        if me.positionY > -20000 && me.positionY < 20000 {
            viewPositionY = me.positionY
        } else {
            viewPositionY = 5000
        }
        let y = CGFloat(planet.positionY - viewPositionY) * (CGFloat(NetrekMath.displayDistance) / CGFloat(NetrekMath.galacticSize)) * geo.size.height / 1000
        debugPrint("planet \(planet.name) ypos \(planet.positionY) my \(me.positionY) y \(y)")
        return y
    }
}

/*struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}*/
