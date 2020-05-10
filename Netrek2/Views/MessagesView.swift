//
//  MessagesView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var universe: Universe
    @State var newMessage: String = ""
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("New Message", text: $newMessage)
                Button("Send To All") {
                    let data = MakePacket.cpMessage(message: self.newMessage, team: .independent, individual: 0)
                    self.appDelegate.reader?.send(content: data)
                    self.newMessage = ""
                }
                Button("Send To My Team") {
                    let data = MakePacket.cpMessage(message: self.newMessage, team: self.universe.players[self.universe.me].team, individual: 0)
                    self.appDelegate.reader?.send(content: data)
                    self.newMessage = ""
                }
            }
            ForEach (universe.activeMessages, id: \.self) { message in
                Text(message).foregroundColor(.black)
            }
        }
    }
}

/*struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}*/
