//
//  LeftTacticalControlView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct LeftTacticalControlView: View {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @ObservedObject var me: Player
    @State var captainSelfDestruct = false
    @State var firstSelfDestruct = false
    var body: some View {
        VStack {
            Button("Captain: Self Destruct") {
                self.captainSelfDestruct.toggle()
                if self.captainSelfDestruct && self.firstSelfDestruct {
                    self.appDelegate.newGameState(.noServerSelected)
                }
            }.background(captainSelfDestruct ? Color.red : Color.black)
            Spacer()
            Button("Cloak") {
                self.appDelegate.keymapController?.execute(.cloak, location: CGPoint(x: 0, y: 0))
            }
            Button("Repair \(me.damage)") {
                self.appDelegate.keymapController?.execute(.repair, location: CGPoint(x: 0, y: 0))
            }
            Button("Shield \(me.shieldStrength)") {
                self.appDelegate.keymapController?.execute(.toggleShields, location: CGPoint(x: 0, y: 0))
            }.background(me.shieldsUp ? Color.green : Color.black)
            Spacer()
            Button("1st Officer: Self Destruct") {
                self.firstSelfDestruct.toggle()
                if self.captainSelfDestruct && self.firstSelfDestruct {
                    self.appDelegate.newGameState(.noServerSelected)
                }
            }.background(firstSelfDestruct ? Color.red : Color.black)
        }
    }
}

/*struct LeftTacticalControlView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTacticalControlView()
    }
}*/
