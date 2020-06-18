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
    @ObservedObject var me: Player
    @ObservedObject var help: Help
    
    @State var newMessage: String = ""
    @State var sendToAll = true
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass

    var bigText: Font {
        guard let vSizeClass = vSizeClass else {
            return Font.headline
        }
        switch vSizeClass {
        case .regular:
            return .title
        case .compact:
            return .headline
        }
    }
    var regularText: Font {
        guard let vSizeClass = vSizeClass else {
            return Font.body
        }
        switch vSizeClass {
            
        case .regular:
            return .headline
        case .compact:
            return Font.body
        }
    }
    
    var SendToAll: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "All"
        case .pad:
            return "Send To All"
        default:
            return "Send To All"
        }
    }
    var SendToMyTeam: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "Team"
        case .pad:
            return "Send To My Team"
        default:
            return "Send To My Team"
        }
    }
    var Speed: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "S"
        case .pad:
            return "Speed"
        default:
            return "Speed"
        }
    }
    var Fuel: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "F"
        case .pad:
            return "Fuel"
        default:
            return "Fuel"
        }
    }



    var body: some View {
        return GeometryReader { geo in
            HStack {
                LeftTacticalControlView(me: self.universe.players[self.universe.me])
                    .frame(width: geo.size.width * 0.15, height: geo.size.height)
                    .border(Color.blue)
                VStack {
                    HStack {
                        Text("                                       ")
                            .overlay(Text("\(self.Speed) \(self.me.speed) \(self.Fuel) \(self.me.fuel)"))
                                .font(.system(.body, design: .monospaced))
                        TextField("New Message", text: self.$newMessage, onCommit: self.sendMessage)
                        
                            .border(Color.primary, width: 1)
                        
                        Toggle(self.sendToAll ? self.SendToAll : self.SendToMyTeam, isOn: self.$sendToAll).toggleStyle(SwitchToggleStyle())
                            .frame(width: geo.size.width * 0.20)
                        Button("Escort") {
                            self.appDelegate.messagesController?.sendEscort()
                        }
                    .padding(4)
                        .border(Color.blue)
                        Button("MAYDAY") {
                            self.appDelegate.messagesController?.sendMayday()
                        }
                    .padding(4)
                        .border(Color.blue)

                    }
                    .frame(width: geo.size.width * 0.77)
                    .layoutPriority(1)

                    TacticalView(universe: self.universe, me: self.universe.players[self.universe.me], help: self.help)
                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                    .clipped()
                    HStack {
                        Stepper(
                            onIncrement: {
                                self.me.throttle += 1
                                self.appDelegate.keymapController.setSpeed(Int(self.me.throttle))
                        },
                            onDecrement: {
                                self.me.throttle -= 1
                                self.appDelegate.keymapController.setSpeed(Int(self.me.throttle))
                        }) {
                            Text("Requested Speed \(self.me.throttle)")
                        }//end Stepper
                            .padding([.leading,.trailing])
                    }// HStack
                        /*Slider(value: self.$me.throttle, in: 0...12,step: 1) { onEditingChanged in
                            debugPrint("slider \(onEditingChanged)")
                            //slider closure is called with true while dragging, then false when dragging done
                            if !onEditingChanged {
                                self.appDelegate.keymapController.setSpeed(Int(self.me.throttle))
                            }
                        }
                        Text("\(Int(self.me.throttle))").padding(.trailing)*/
                }//VStack tactical
            }//HStack
        }//Geo Reader
    }// var body
    func sendMessage() {
        debugPrint("sending message \(newMessage)")
        self.sendMessage(message: newMessage, sendToAll: self.sendToAll)
    }
    func sendMessage(message: String, sendToAll: Bool) {
        if message == "" {
            return
        }
        if sendToAll {
            let data = MakePacket.cpMessage(message: message, team: .independent, individual: 0)
            self.appDelegate.reader?.send(content: data)
            self.newMessage = ""
        } else {
            let data = MakePacket.cpMessage(message: message, team: self.universe.players[self.universe.me].team, individual: 0)
            self.appDelegate.reader?.send(content: data)
            self.newMessage = ""
        }
    }

}

/*struct TacticalHudView_Previews: PreviewProvider {
    static var previews: some View {
        TacticalHudView(universe: Universe(), help: Help())
    }
}*/
