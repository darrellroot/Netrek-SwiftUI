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
                    .frame(width: geo.size.width * 0.1, height: geo.size.height)
                TacticalView(universe: self.universe, help: self.help)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height)
            }
        }
    }
}

struct TacticalHudView_Previews: PreviewProvider {
    static var previews: some View {
        TacticalHudView(universe: Universe(), help: Help())
    }
}
