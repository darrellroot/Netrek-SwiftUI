//
//  ManualServerView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/1/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct ManualServerView: View {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    @State var server: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                TextField("Input server name or IP", text: $server,onCommit: self.commit).frame(width: 350)
                Button("Connect") {
                    self.commit()
                }
            }
            Text("pickled.netrek.org is a well-known Netrek server")
        }.padding(20)
    }
    func commit() -> Void {
        if self.server != "" {
            self.appDelegate.connectToServer(server: self.server)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ManualServerView_Previews: PreviewProvider {
    static var previews: some View {
        ManualServerView()
    }
}
