//
//  StrategicView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct StrategicView: View {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    @ObservedObject var universe: Universe
    
    var body: some View {
        return GeometryReader { geo in
            ZStack {
                Rectangle().colorInvert()
                ForEach(0 ..< self.universe.maxPlanets) { planetId in
                    PlanetStrategicView(planet: self.universe.planets[planetId])
                }
                ForEach(0 ..< self.universe.maxPlayers) { playerId in
                    PlayerStrategicView(player: self.universe.players[playerId])
                }
                Rectangle().opacity(0.01).pointingMouse { event, location in
                    debugPrint("event \(event) location \(location)")
                    switch event.type {
                        
                    case .leftMouseDown:
                        self.mouseDown(control: .leftMouse,eventLocation: location, size: geo.size)
                    case .leftMouseDragged:
                        self.mouseDown(control: .leftMouse,eventLocation: location, size: geo.size)
                    case .rightMouseDragged:
                        self.mouseDown(control: .leftMouse,eventLocation: location, size: geo.size)
                    case .rightMouseDown:
                        self.mouseDown(control: .rightMouse,eventLocation: location, size: geo.size)
                    case .keyDown:
                        self.keyDown(with: event, location: location)
                    case .otherMouseDown:
                        self.mouseDown(control: .otherMouse,eventLocation: location, size: geo.size)
                    default:
                        break
                    }
                }
            }//ZStack
        }//Body
        .frame(minWidth: 500, idealWidth: 800, maxWidth: nil, minHeight: 500, idealHeight: 800, maxHeight: nil, alignment: .center)
        
    }
    func mouseDown(control: Control, eventLocation: NSPoint, size: CGSize) {
        
        let netrekX = CGFloat(NetrekMath.galacticSize) * eventLocation.x / size.width
        let netrekY = CGFloat(NetrekMath.galacticSize) -  (CGFloat(NetrekMath.galacticSize) * eventLocation.y / size.height)
        let location = CGPoint(x: netrekX, y: netrekY)
        self.appDelegate.keymapController.execute(control,location: location)
    }
    func keyDown(with event: NSEvent, location: CGPoint) {
        debugPrint("StrategicScene.keyDown characters \(String(describing: event.characters))")
        guard let keymap = appDelegate.keymapController else {
            debugPrint("StrategicScene.keyDown unable to find keymapController")
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
        default:
            debugPrint("StrategicScene.keyDown unknown key \(String(describing: event.characters))")
        }
        
    }
    
}

/*struct StrategicView_Previews: PreviewProvider {
 static var previews: some View {
 StrategicView()
 }
 }*/
