//
//  PickServer.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct PickServerView: View {
    @ObservedObject var metaServer: MetaServer
    @ObservedObject var universe: Universe
    
    var body: some View {
        List {
            ForEach(metaServer.servers.keys.sorted(), id: \.self) { hostname in
                Text("\(hostname) \(self.metaServer.servers[hostname]?.type.description ?? "Unknown") players \(self.metaServer.servers[hostname]?.players ?? 0)")
                    .onTapGesture {
                        debugPrint("server \(hostname) selected")
                }
            }
        }
    }
}

/*struct PickServer_Previews: PreviewProvider {
    static var previews: some View {
        PickServerView()
    }
}*/
