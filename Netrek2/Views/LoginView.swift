//
//  LoginView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/1/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var playAsGuest = true
    @State var name = ""
    @State var password = ""
    @State var username = ""
    var body: some View {
        VStack {
            Picker(selection: $playAsGuest, label: EmptyView()) {
                Text("            Play as Guest            ").tag(true)
                Text("Specify Netrek Server Account").tag(false)
            }.pickerStyle(SegmentedPickerStyle())
            HStack {
                //Just to make big enough
                VStack {
                    ForEach (0..<13) {_ in
                        Text("")
                    }
                }
                VStack(alignment: .leading) {
                    Text("We recommend new players play as guest.  Your Name and Username will be visible to other players.")
                    Text("")
                    Text("If you don't already have an account on the server, one will be created for you (assuming your name and username are unique).  Make sure to remember your password.  This netrek client saves your network password in your keychain.")
                }//VStack left
                VStack(alignment: .leading){
                    HStack {
                        Text("Name")
                        TextField("",text: $name)
                    }
                    Text("Warning: Netrek servers use an old network protocol which is out of our control.  The password is not encrypted on the network.  We recommend you use a different/unique password than other accounts for your Netrek login.")
                    HStack {
                        Text("Password")
                        SecureField("",text: $password)
                    }
                    HStack {
                        Text("Username")
                        TextField("", text: $username)
                    }
                }
            }
        }.padding(8)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
