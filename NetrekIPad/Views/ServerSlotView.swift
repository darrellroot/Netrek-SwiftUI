//
//  ServerSlotView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/11/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct ServerSlotView: View {
    var appDelegate: AppDelegate
    //var universe: Universe
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Disconnect From Server")
                }.onTapGesture {
                    self.appDelegate.newGameState(.noServerSelected)
                }
                Spacer()
            }//HStack
            Spacer()
            Text("Server Slot Found")
            appDelegate.loginInformationController.loginAuthenticated ? Text("Attempting to login as user \(appDelegate.loginInformationController.loginName)") : Text("Attempting to login as guest")
            Spacer()
        }//VStack
    }//var body
}

/*struct ServerConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        ServerConnectedView()
    }
}*/
