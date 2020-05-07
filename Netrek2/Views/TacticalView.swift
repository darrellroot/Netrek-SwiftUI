//
//  TacticalView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/5/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI


struct TacticalView: View, TacticalOffset {
    /*func updateNSView(_ nsView: RightClickableView, context: NSViewRepresentableContext<TacticalView>) {
        print("Update")
    }

    func makeNSView(context: Context) -> RightClickableView {
        RightClickableView()
    }*/

    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    //@EnvironmentObject var universe: Universe
    @ObservedObject var universe: Universe
    @State var pt: CGPoint = CGPoint() {
        didSet {
            debugPrint("point \(pt)")
        }
    }
    //@ObservedObject var players: [Player] = universe.players.values
    var body: some View {
        return GeometryReader { geo in
            ZStack {
                Rectangle().pointingMouse { event, location in
                    debugPrint("event \(event) location \(location)")
                    switch event.type {
                        
                    case .leftMouseDown:
                        appDelegate.keymapController.execute(.leftMouse,location: location)
                    case .rightMouseDown:
                        <#code#>
                    case .keyDown:
                        <#code#>
                    case .otherMouseDown:
                        <#code#>

                    default:
                        break
                    }
                }
                ForEach(0 ..< self.universe.maxPlanets) { planetId in
                    PlanetView(planet: self.universe.planets[planetId], me: self.universe.me)
                }
                ForEach(0 ..< self.universe.maxPlayers) { playerId in
                    PlayerView(player: self.universe.players[playerId], me: self.universe.me)
                }
            }
        }.frame(minWidth: 500, idealWidth: 800, maxWidth: nil, minHeight: 500, idealHeight: 800, maxHeight: nil, alignment: .center)
            /*.gesture(DragGesture(minimumDistance: 0.0)
                .onChanged { tap in
                    let location = tap.location
                    debugPrint("tap location \(location)")
                }
            )*/
    }
}
//.offset(x: CGFloat(Int.random(in: -200 ..< 200)), y: CGFloat(Int.random(in: -200 ..< 200)))

/*struct TacticalView_Previews: PreviewProvider {
    static var previews: some View {
        TacticalView()
    }
}*/
