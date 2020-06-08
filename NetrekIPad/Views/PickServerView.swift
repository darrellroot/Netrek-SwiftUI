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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        VStack {
            List {
                ForEach(metaServer.servers.keys.sorted(), id: \.self) { hostname in
                    Text("\(hostname) \(self.metaServer.servers[hostname]?.type.description ?? "Unknown") players \(self.metaServer.servers[hostname]?.players ?? 0)")
                        .onTapGesture {
                            debugPrint("server \(hostname) selected")
                            let success = self.appDelegate.selectServer(hostname: hostname)
                    }
                }
            }
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
