//
//  ServerConnectedView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/11/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct ServerConnectedView: View {
    var appDelegate: AppDelegate
    var universe: Universe
    
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
            Text("Server Connected")
            Text("Wait Queue \(universe.waitQueue)")
            Spacer()
        }//VStack
    }//var body
}

/*struct ServerConnectedView_Previews: PreviewProvider {
    static var previews: some View {
        ServerConnectedView()
    }
}*/
