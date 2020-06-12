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

    var body: some View {
        return GeometryReader { geo in
            HStack {
                LeftTacticalControlView(me: self.universe.players[self.universe.me])
                    .frame(width: geo.size.width * 0.14, height: geo.size.height)
                    .border(Color.blue)
                VStack {
                    HStack {
                        Text("                                       ")
                            .overlay(Text("Speed \(self.me.speed) Fuel \(self.me.fuel)"))
                                .font(.system(.body, design: .monospaced))
                        TextField("New Message", text: self.$newMessage, onCommit: self.sendMessage)
                        
                            .border(Color.primary, width: 1)
                            
                        Toggle(self.sendToAll ? "Send To All" : "Send To My Team", isOn: self.$sendToAll).toggleStyle(SwitchToggleStyle())
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
                    .frame(width: geo.size.width * 0.84)
                    .padding(.top)

                    TacticalView(universe: self.universe, me: self.universe.players[self.universe.me], help: self.help)
                        .frame(width: geo.size.width * 0.84)
                    .clipped()
                }
            }
        }
    }
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
