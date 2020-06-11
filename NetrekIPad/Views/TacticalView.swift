//
//  TacticalView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TacticalView: View, TacticalOffset {
    
    #if os(macOS)
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    #elseif os(iOS)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    #endif
    
    //@EnvironmentObject var universe: Universe
    @ObservedObject var universe: Universe
    @ObservedObject var me: Player
    @ObservedObject var help: Help
    //@ObservedObject var preferencesController: PreferencesController
    @State var pt: CGPoint = CGPoint() {
        didSet {
            debugPrint("point \(pt)")
        }
    }
    var fakeTorpedo = Torpedo(torpedoId: 999)
    var fakeLaser = Laser(laserId: 999)
    var fakePlasma = Plasma(plasmaId: 999)
    
    //@ObservedObject var players: [Player] = universe.players.values
    var body: some View {
        return GeometryReader { geo in
            
            return ZStack {
                ZStack { //more than 10 items in function builder}
                    Rectangle().colorInvert()
                    HelpView(help: self.help)
                    VStack {
                        Spacer()
                        Text(self.universe.lastMessage)
                        .font(.headline)
                    }
                    BoundaryView(me: self.universe.players[self.universe.me])
                    
                    ForEach(self.universe.visibleTractors, id: \.playerId) { target in
                        TractorView(target: target, me: self.universe.players[self.universe.me])
                    }
                    
                    ForEach(self.universe.explodingPlayers, id: \.playerId) { player in
                        ExplosionView(player: player, me: self.universe.players[self.universe.me])
                    }
                }//extra zstack for 10
                ForEach(self.universe.visibleTorpedoes, id: \.torpedoId) { torpedo in
                    
                    TorpedoView(torpedo: torpedo, me: self.universe.players[self.universe.me])
                }
                ForEach(self.universe.explodingTorpedoes, id: \.torpedoId) { torpedo in
                    DetonationView(torpedo: torpedo, me: self.universe.players[self.universe.me])
                }
                ForEach(self.universe.visibleLasers, id: \.laserId) { laser in
                    LaserView(laser: laser, me: self.universe.players[self.universe.me])
                }
                ForEach(self.universe.visiblePlasmas, id: \.plasmaId) { plasma in
                    PlasmaView(plasma: plasma, me: self.universe.players[self.universe.me])
                }
                
                ForEach(self.universe.visibleFriendlyPlayers, id: \.playerId) { player in
                    PlayerView(player: player, me: self.universe.players[self.universe.me], imageSize: self.playerWidth(screenWidth: geo.size.width), screenWidth: geo.size.width, screenHeight: geo.size.height)
                        .frame(width: self.playerWidth(screenWidth: geo.size.width * 3), height: self.playerWidth(screenWidth: geo.size.height * 3))
                }

                //Rectangle().opacity(0.01).pointingMouse { event, location in
                Rectangle().opacity(0.01)
                    .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                        .onEnded { gesture in
                            let startLocation = gesture.startLocation
                            let endLocation = gesture.predictedEndLocation
                            debugPrint("drag gesture startLocation \(startLocation) endLocation \(endLocation)")
                            if abs(startLocation.x - endLocation.x) < geo.size.width / 20 && abs(startLocation.y - endLocation.y) < geo.size.height / 20 {
                                self.mouseDown(control: .leftMouse, eventLocation: startLocation, size: geo.size)
                            } else {
                                // treat as drag
                                self.mouseDown(control: .rightMouse, eventLocation: endLocation, size: geo.size)
                                let dragMagnitude = sqrt(gesture.translation.width * gesture.translation.width + gesture.translation.height * gesture.translation.height)
                                let screenMagnitude = (geo.size.width + geo.size.height) / 4
                                let requestedSpeed = min(Int(13 * dragMagnitude / screenMagnitude),12)
                                
                                debugPrint("dragMagnitude \(dragMagnitude) screenMagnitude \(screenMagnitude) requested speed \(requestedSpeed)")
                                guard requestedSpeed >= 0 && requestedSpeed < 13 else {
                                    debugPrint("invalid requested speed \(requestedSpeed)")
                                    return
                                }
                                self.appDelegate.keymapController.setSpeed(requestedSpeed)
                                
                            }
                        }
                )
                ForEach(self.universe.visiblePlanets, id: \.planetId) { planet in
                    PlanetView(planet: planet, me: self.universe.players[self.universe.me], imageSize: self.planetWidth(screenWidth: geo.size.width),screenWidth: geo.size.width, screenHeight: geo.size.height)
                    .frame(width: self.planetWidth(screenWidth: geo.size.width * 3), height: self.planetWidth(screenWidth: geo.size.height * 3))
                        .onTapGesture {
                            debugPrint("tap gesture planet lock on")
                            self.appDelegate.keymapController.execute(.lKey, location: CGPoint(x: planet.positionX, y: planet.positionY))
                    }

                }

                ForEach(self.universe.visibleEnemyPlayers, id: \.playerId) { player in
                    PlayerView(player: player, me: self.universe.players[self.universe.me], imageSize: self.playerWidth(screenWidth: geo.size.width), screenWidth: geo.size.width, screenHeight: geo.size.height)
                        .frame(width: self.playerWidth(screenWidth: geo.size.width * 3), height: self.playerWidth(screenWidth: geo.size.height * 3))
                        //.border(Color.orange)
                        .onTapGesture {
                            debugPrint("tap gesture laser")
                            if player.team != self.universe.players[self.universe.me].team {
                                self.appDelegate.keymapController.execute(.otherMouse, location: CGPoint(x: player.positionX, y: player.positionY))
                            }
                    }
                }

                
                /*debugPrint("event \(event) location \(location)")
                 switch event.type {
                 
                 case .leftMouseDown:
                 self.mouseDown(control: .leftMouse,eventLocation: location, size: geo.size)
                 //self.appDelegate.keymapController.execute(.leftMouse,location: location)
                 case .leftMouseDragged:
                 self.mouseDown(control: .leftMouse,eventLocation: location, size: geo.size)
                 case .rightMouseDragged:
                 self.mouseDown(control: .leftMouse,eventLocation: location, size: geo.size)
                 case .rightMouseDown:
                 self.mouseDown(control: .rightMouse,eventLocation: location, size: geo.size)
                 
                 //self.appDelegate.keymapController.execute(.rightMouse,location: location)
                 case .keyDown:
                 debugPrint("keydown not implemented")
                 self.keyDown(with: event, location: location)
                 //self.appDelegate.keymapController.execute(,location: location)
                 case .otherMouseDown:
                 self.mouseDown(control: .otherMouse,eventLocation: location, size: geo.size)
                 
                 //self.appDelegate.keymapController.execute(.otherMouse,location: location)
                 default:
                 break
                 }
                 }*/
                
                
            }
        }.frame(minWidth: 500, idealWidth: 800, maxWidth: nil, minHeight: 500, idealHeight: 800, maxHeight: nil, alignment: .center)
        .border(me.alertCondition.color)
        /*.gesture(DragGesture(minimumDistance: 0.0)
         .onChanged { tap in
         let location = tap.location
         debugPrint("tap location \(location)")
         }
         )*/
    }
    func netrekLocation(eventLocation: CGPoint, size: CGSize) -> CGPoint {
        let meX = universe.players[universe.me].positionX
        let meY = universe.players[universe.me].positionY
        let diffX = Int(eventLocation.x) - (Int(size.width) / 2)
        let diffY = Int(eventLocation.y) - (Int(size.height) / 2)
        let deltaX = NetrekMath.displayDistance * diffX / Int(size.width)
        let deltaY = NetrekMath.displayDistance * diffY / Int(size.height)
        let finalX = meX + deltaX
        let finalY = meY - deltaY
        return CGPoint(x: finalX, y: finalY)
    }
    func mouseDown(control: Control, eventLocation: CGPoint, size: CGSize) {
        let location = netrekLocation(eventLocation: eventLocation, size: size)
        self.appDelegate.keymapController.execute(control,location: location)
    }
    
    /*func mouseDown(control: Control, eventLocation: NSPoint, size: CGSize) {
     let meX = universe.players[universe.me].positionX
     let meY = universe.players[universe.me].positionY
     let diffX = Int(eventLocation.x) - (Int(size.width) / 2)
     let diffY = Int(eventLocation.y) - (Int(size.height) / 2)
     let deltaX = NetrekMath.displayDistance * diffX / Int(size.width)
     let deltaY = NetrekMath.displayDistance * diffY / Int(size.height)
     let finalX = meX + deltaX
     let finalY = meY - deltaY
     let location = CGPoint(x: finalX, y: finalY)
     self.appDelegate.keymapController.execute(control,location: location)
     }*/
    
    /*func keyDown(with event: NSEvent, location: CGPoint) {
     debugPrint("TacticalScene.keyDown characters \(String(describing: event.characters))")
     guard let keymap = appDelegate.keymapController else {
     debugPrint("TacticalScene.keyDown unable to find keymapController")
     return
     }
     
     switch event.characters?.first {
     case "0":
     keymap.execute(.zeroKey, location: location)
     case "1":
     keymap.execute(.oneKey, location: location)
     case "2":
     keymap.execute(.twoKey, location: location)
     case "3":
     keymap.execute(.threeKey, location: location)
     case "4":
     keymap.execute(.fourKey, location: location)
     case "5":
     keymap.execute(.fiveKey, location: location)
     case "6":
     keymap.execute(.sixKey, location: location)
     case "7":
     keymap.execute(.sevenKey, location: location)
     case "8":
     keymap.execute(.eightKey, location: location)
     case "9":
     keymap.execute(.nineKey, location: location)
     case ")":
     keymap.execute(.rightParenKey, location: location)
     case "!": keymap.execute(.exclamationMarkKey, location: location)
     case "@": keymap.execute(.atKey, location: location)
     case "%": keymap.execute(.percentKey,location: location)
     case "#": keymap.execute(.poundKey,location: location)
     case "<":
     keymap.execute(.lessThanKey,location: location)
     case ">":
     keymap.execute(.greaterThanKey,location: location)
     case "]":
     keymap.execute(.rightBracketKey,location: location)
     case "[":
     keymap.execute(.leftBracketKey, location: location)
     case "{":
     keymap.execute(.leftCurly, location: location)
     case "}":
     keymap.execute(.rightCurly, location: location)
     case "_":
     keymap.execute(.underscore, location: location)
     case "^":
     keymap.execute(.carrot, location: location)
     case "$":
     keymap.execute(.dollar, location: location)
     case ";":
     keymap.execute(.semicolon, location: location)
     case "a":
     keymap.execute(.aKey, location: location)
     case "b":
     keymap.execute(.bKey, location: location)
     case "c":
     keymap.execute(.cKey, location: location)
     case "d":
     keymap.execute(.dKey, location: location)
     case "e":
     keymap.execute(.eKey, location: location)
     case "f":
     keymap.execute(.fKey, location: location)
     case "g":
     keymap.execute(.gKey, location: location)
     case "h":
     keymap.execute(.hKey, location: location)
     case "i":
     keymap.execute(.iKey, location: location)
     case "j":
     keymap.execute(.jKey, location: location)
     case "k":
     keymap.execute(.kKey, location: location)
     case "l":
     keymap.execute(.lKey, location: location)
     case "m":
     keymap.execute(.mKey, location: location)
     case "n":
     keymap.execute(.nKey, location: location)
     case "o":
     keymap.execute(.oKey, location: location)
     case "p":
     keymap.execute(.pKey, location: location)
     case "q":
     keymap.execute(.qKey, location: location)
     case "r":
     keymap.execute(.rKey, location: location)
     case "s":
     keymap.execute(.sKey, location: location)
     case "t":
     keymap.execute(.tKey, location: location)
     case "u":
     keymap.execute(.uKey, location: location)
     case "v":
     keymap.execute(.vKey, location: location)
     case "w":
     keymap.execute(.wKey, location: location)
     case "x":
     keymap.execute(.xKey, location: location)
     case "y":
     keymap.execute(.yKey, location: location)
     case "z":
     keymap.execute(.zKey, location: location)
     case "A":
     keymap.execute(.AKey, location: location)
     case "B":
     keymap.execute(.BKey, location: location)
     case "C":
     keymap.execute(.CKey, location: location)
     case "D":
     keymap.execute(.DKey, location: location)
     case "E":
     keymap.execute(.EKey, location: location)
     case "F":
     keymap.execute(.FKey, location: location)
     case "G":
     keymap.execute(.GKey, location: location)
     case "H":
     keymap.execute(.HKey, location: location)
     case "I":
     keymap.execute(.IKey, location: location)
     case "J":
     keymap.execute(.JKey, location: location)
     case "K":
     keymap.execute(.KKey, location: location)
     case "L":
     keymap.execute(.LKey, location: location)
     case "M":
     keymap.execute(.MKey, location: location)
     case "N":
     keymap.execute(.NKey, location: location)
     case "O":
     keymap.execute(.OKey, location: location)
     case "P":
     keymap.execute(.PKey, location: location)
     case "Q":
     keymap.execute(.QKey, location: location)
     case "R":
     keymap.execute(.RKey, location: location)
     case "S":
     keymap.execute(.SKey, location: location)
     case "T":
     keymap.execute(.TKey, location: location)
     case "U":
     keymap.execute(.UKey, location: location)
     case "V":
     keymap.execute(.VKey, location: location)
     case "W":
     keymap.execute(.WKey, location: location)
     case "X":
     keymap.execute(.XKey, location: location)
     case "Y":
     keymap.execute(.YKey, location: location)
     case "Z":
     keymap.execute(.ZKey, location: location)
     case "*":
     keymap.execute(.asteriskKey, location: location)
     case " ":
     keymap.execute(.spacebarKey, location: location)
     default:
     debugPrint("TacticalScene.TacticalView.keyDown unknown key \(String(describing: event.characters))")
     }
     }*/
    
}
//.offset(x: CGFloat(Int.random(in: -200 ..< 200)), y: CGFloat(Int.random(in: -200 ..< 200)))

/*struct TacticalView_Previews: PreviewProvider {
 static var previews: some View {
 TacticalView()
 }
 }*/
