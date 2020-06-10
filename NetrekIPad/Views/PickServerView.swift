//
//  PickServer.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI
import Speech

struct PickServerView: View {
    @ObservedObject var metaServer: MetaServer
    @ObservedObject var universe: Universe
    @State var manualServer: String = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Netrek").font(.largeTitle)
                Spacer()
            }
            Text("Pick Server").font(.title)
            List {
                ForEach(metaServer.servers.keys.sorted(), id: \.self) { hostname in
                    Text("\(hostname) \(self.metaServer.servers[hostname]?.type.description ?? "Unknown") players \(self.metaServer.servers[hostname]?.players ?? 0)")
                        .onTapGesture {
                            debugPrint("server \(hostname) selected")
                            _ = self.appDelegate.selectServer(hostname: hostname)
                    }
                }
            }
            Spacer()
            HStack {
                Text("Manually Enter Server Hostname or IP Address").font(.title)
                TextField("servername", text: $manualServer).font(.title)
                Button("Connect to Manual Server") {
                    _ = self.appDelegate.selectServer(hostname: self.manualServer)
                }
            }
            Spacer()
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
        }
    }
}

/*struct PickServer_Previews: PreviewProvider {
    static var previews: some View {
        PickServerView()
    }
}*/
