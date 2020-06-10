//
//  LoginView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/1/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    @State var loginName: String
    @State var loginPassword: String
    @State var loginUsername: String
    @ObservedObject var loginInformationController: LoginInformationController
    
    var validInfo: Bool {
        if loginName.count == 0 {
            return false
        }
        if loginPassword.count == 0 {
            return false
        }
        if loginUsername.count == 0 {
            return false
        }
        return true
    }
    var body: some View {
        VStack {
            Picker(selection: $loginInformationController.loginAuthenticated, label: EmptyView()) {
                Text("            Play as Guest            ").tag(false)
                Text("Specify Netrek Server Account").tag(true)
            }.pickerStyle(SegmentedPickerStyle())
                
            HStack {
                //Just to make big enough
                VStack {
                    ForEach (0..<17) {_ in
                        Text("")
                    }
                }
                VStack(alignment: .leading) {
                    Text("We recommend new players play as guest.  Your Name and Username will be visible to other players.")
                    Text("")
                    Text("If you don't already have an account on the server, one will be created for you (assuming your name and username are unique).  Make sure to remember your password.  This netrek client saves your network password in your keychain.")
                    Spacer()
                }//VStack left
                VStack(alignment: .leading){
                    HStack {
                        Text("Name")
                        TextField(loginInformationController.loginName,text: $loginName)
                    }
                    Text("Warning: Netrek servers use an old network protocol which is out of our control.  The password is not encrypted on the network.  We recommend you use a different/unique password than other accounts for your Netrek login.")
                    HStack {
                        Text("Password")
                        SecureField(loginInformationController.securePassword,text: $loginPassword)
                    }
                    HStack {
                        Text("Username")
                        TextField(loginInformationController.loginUsername, text: $loginUsername)
                    }
                    Button("Save Login Information") {
                        self.saveInfo()
                    }.disabled(self.validInfo ? false : true)
                    Button("Clear Login Information") {
                        self.loginName = ""
                        self.loginPassword = ""
                        self.loginUsername = ""
                        self.loginInformationController.loginAuthenticated = false
                        self.saveInfo()
                    }
                    Spacer()
                }//VStack Right
            }
        }.padding(8)
    }
    func saveInfo() {
        self.loginInformationController.updateUsername(username: self.loginUsername)
        self.loginInformationController.updatePassword(password: self.loginPassword)
        self.loginInformationController.updateName(name: self.loginName)
    }
}

/*struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}*/
