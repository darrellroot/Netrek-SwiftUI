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
    
    let numButtons: CGFloat = 12.0
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Button("Captain: Self Destruct") {
                        self.captainSelfDestruct.toggle()
                        if self.captainSelfDestruct && self.firstSelfDestruct {
                            self.appDelegate.newGameState(.noServerSelected)
                        } else {
                            self.appDelegate.universe.gotMessage("You notice everyone on the bridge looking at you")
                        }
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .background(self.captainSelfDestruct ? Color.red : Color.black)
                    .border(Color.blue)
                    Spacer()
                    Button("Beam Up") {
                        self.appDelegate.keymapController?.execute(.beamUp, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .border(Color.blue)
                    Spacer()
                    Button("Beam Down (\(self.me.armies) armies)") {
                        self.appDelegate.keymapController?.execute(.beamDown, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .border(Color.blue)
                    Spacer()
                    Button("Bomb") {
                        self.appDelegate.keymapController?.execute(.bomb, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .border(Color.blue)
                    Spacer()
                }
                VStack {
                    Button("Cloak") {
                        self.appDelegate.keymapController?.execute(.cloak, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .background(self.me.cloak ? Color.red : Color.black)
                    .border(Color.blue)
                    Spacer()
                    Button("Detonate Enemy Torps") {
                        self.appDelegate.keymapController?.execute(.detEnemy, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .border(Color.blue)
                    Spacer()
                    Button("Detonate Own Torps") {
                        self.appDelegate.keymapController?.execute(.detOwn, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .border(Color.blue)
                    
                }//Extra VStack exceeding 10
                VStack {
                    Spacer()
                    //TODO: Tractor,Pressor
                    
                    Button("Repair\nDamage: \(self.me.damage)") {
                        self.appDelegate.keymapController?.execute(.repair, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .background(self.me.repair ? Color.red : Color.black)
                    .border(Color.blue)
                    Spacer()
                    Button("Shield \(self.me.shieldStrength)") {
                        self.appDelegate.keymapController?.execute(.toggleShields, location: CGPoint(x: 0, y: 0))
                    }
                    .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                    .background(self.me.shieldsUp ? Color.green : Color.black)
                    .border(Color.blue)
                } // VStack for 10
                Spacer()
                Button("1st Officer: Self Destruct") {
                    self.firstSelfDestruct.toggle()
                    if self.captainSelfDestruct && self.firstSelfDestruct {
                        self.appDelegate.newGameState(.noServerSelected)
                    } else {
                        self.appDelegate.universe.gotMessage("You notice everyone on the bridge looking at the First Officer")
                    }
                }
                .frame(width: geo.size.width,height: geo.size.height / self.numButtons)
                .background(self.firstSelfDestruct ? Color.red : Color.black)
                .border(Color.blue)
            }//Main VStack
        }//Geometry Reader
    }
}

/*struct LeftTacticalControlView_Previews: PreviewProvider {
 static var previews: some View {
 LeftTacticalControlView()
 }
 }*/
