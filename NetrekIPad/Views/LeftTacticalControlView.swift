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
            VStack {
                Button("Captain: Self Destruct") {
                    self.captainSelfDestruct.toggle()
                    if self.captainSelfDestruct && self.firstSelfDestruct {
                        self.appDelegate.newGameState(.noServerSelected)
                    }
                }.background(captainSelfDestruct ? Color.red : Color.black)
                .border(Color.blue)
                Spacer()
                Button("Beam Up") {
                    self.appDelegate.keymapController?.execute(.beamUp, location: CGPoint(x: 0, y: 0))
                }.border(Color.blue)
                Spacer()
                Button("Beam Down (\(me.armies) armies on board))") {
                    self.appDelegate.keymapController?.execute(.beamDown, location: CGPoint(x: 0, y: 0))
                }.border(Color.blue)
                Spacer()
                Button("Bomb") {
                    self.appDelegate.keymapController?.execute(.bomb, location: CGPoint(x: 0, y: 0))
                }.border(Color.blue)
                Spacer()
            }
            VStack {
                Button("Cloak") {
                    self.appDelegate.keymapController?.execute(.cloak, location: CGPoint(x: 0, y: 0))
                }.background(me.cloak ? Color.red : Color.black)
                .border(Color.blue)
                Spacer()
                Button("Detonate Enemy Torps") {
                    self.appDelegate.keymapController?.execute(.detEnemy, location: CGPoint(x: 0, y: 0))
                }.border(Color.blue)
                Spacer()
                Button("Detonate Own Torps") {
                    self.appDelegate.keymapController?.execute(.detOwn, location: CGPoint(x: 0, y: 0))
                }.border(Color.blue)
                
            }//Extra VStack exceeding 10
            Spacer()
            //TODO: Tractor,Pressor
            
            Button("Repair \(me.damage)") {
                self.appDelegate.keymapController?.execute(.repair, location: CGPoint(x: 0, y: 0))
            }.background(me.repair ? Color.red : Color.black)
            .border(Color.blue)
            Spacer()
            Button("Shield \(me.shieldStrength)") {
                self.appDelegate.keymapController?.execute(.toggleShields, location: CGPoint(x: 0, y: 0))
            }.background(me.shieldsUp ? Color.green : Color.black)
            .border(Color.blue)
            Spacer()
            Button("1st Officer: Self Destruct") {
                self.firstSelfDestruct.toggle()
                if self.captainSelfDestruct && self.firstSelfDestruct {
                    self.appDelegate.newGameState(.noServerSelected)
                }
            }.background(firstSelfDestruct ? Color.red : Color.black)
            .border(Color.blue)
        }//Main VStack
            
    }
}

/*struct LeftTacticalControlView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTacticalControlView()
    }
}*/
