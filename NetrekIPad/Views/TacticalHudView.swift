//
//  TacticalHudView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TacticalHudView: View {
    #if os(macOS)
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif
    
    //@EnvironmentObject var universe: Universe
    @ObservedObject var universe: Universe
    @ObservedObject var help: Help

    var body: some View {
        return GeometryReader { geo in
            HStack {
                LeftTacticalControlView(me: self.universe.players[self.universe.me])
                    .frame(width: geo.size.width * 0.14, height: geo.size.height)
                    .border(Color.blue)
                TacticalView(universe: self.universe, me: self.universe.players[self.universe.me], help: self.help)
                    .frame(width: geo.size.width * 0.84, height: geo.size.height)
                .clipped()
            }
        }
    }
}

struct TacticalHudView_Previews: PreviewProvider {
    static var previews: some View {
        TacticalHudView(universe: Universe(), help: Help())
    }
}
