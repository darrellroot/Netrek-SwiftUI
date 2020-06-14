//
//  PickServer.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI
//import Speech
import Combine

struct PickServerView: View {
    @ObservedObject var metaServer: MetaServer
    @ObservedObject var universe: Universe

    @State var manualServer = "" // see serverBinding below
    
    @State private var keyboardHeight: CGFloat = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        let serverBinding = Binding<String> ( get: {
            self.manualServer
        }, set: {
            self.manualServer = $0.lowercased()
        })

        
        return VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Netrek").font(.largeTitle)
                Spacer()
            }
            Text("Pick Server").font(.title)
            VStack(alignment: .leading) {
                ForEach(metaServer.servers.keys.sorted(), id: \.self) { hostname in
                    Text("\(hostname) \(self.metaServer.servers[hostname]?.type.description ?? "Unknown") players \(self.metaServer.servers[hostname]?.players ?? 0)")
                            .onTapGesture {
                                debugPrint("server \(hostname) selected")
                                _ = self.appDelegate.selectServer(hostname: hostname)
                    }
                    .padding(8)
                }
            }.font(.title)
            Spacer()
            Text("We recommend \"Bronco\" servers for new Netrek players")
                .font(.title)
            Spacer()
            HStack {
                Text("Manually Enter Server Hostname or IP Address")
                TextField("servername", text: serverBinding)
                Button("Connect to Manual Server") {
                    _ = self.appDelegate.selectServer(hostname: self.manualServer)
                }
            }.font(.title)
            Spacer()
            HStack {
                Text("How To Play")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        self.appDelegate.gameScreen = .howToPlay
                }
                Spacer()
                Text("Preferences")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        self.appDelegate.gameScreen = .preferences
                }
                Spacer()
                Text("Credits")
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        self.appDelegate.gameScreen = .credits
                }
            }//bottom row Hstack
            /* speech commands did not work, may try again
            Button("Enable Speech Commands") {
                SFSpeechRecognizer.requestAuthorization { authStatus in
                    switch authStatus {
                    case .authorized:
                        self.appDelegate.enableSpeech()
                    case .restricted:
                        debugPrint("speech restricted")
                        break
                    case .notDetermined:
                        debugPrint("speech not determined")
                        break
                    case .denied:
                        debugPrint("speech denied")
                        break
                    }
                }
            }*/
            
        }// main Vstack
            .padding([.leading,.top,.trailing])
            .padding(.bottom, keyboardHeight)
            .onReceive(Publishers.keyboardHeight) {
                self.keyboardHeight = $0
        }
    }//var body
}

/*struct PickServer_Previews: PreviewProvider {
    static var previews: some View {
        PickServerView()
    }
}*/
