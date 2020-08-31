//
//  MetaServer.swift
//  Netrek
//
//  Created by Darrell Root on 3/1/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#endif
import SwiftUI

class MetaServer: ObservableObject {
    let metahosts: [String]  //primary server hostname
    let port: Int
    //let url: URL
    var dataTasks: [String:URLSessionDataTask] = [:] // hostname:URLSessionDataTask
    let defaultSession = URLSession(configuration: .default)
    let newlineCharacters = NSCharacterSet.newlines
    let whiteSpace = NSCharacterSet.whitespaces
    
    @Published var servers: [String:MetaServerEntry] = [:]  // hostname:MetaServerEntry
    
    init?(primary: String, backup: String, port: Int) {
        self.metahosts = [primary,backup]
        self.port = port
        //let primaryUrlString = "http://\(primary):\(port)"
        //guard let urlComponents = URLComponents(string: urlString ) else { return nil }
        //guard let url = urlComponents.url else { return nil }
        //self.url = url
        let pickled = MetaServerEntry(hostname: "pickled.netrek.org", port: 2592, age: 1000, players: 0, type: .bronco)
        let continuum = MetaServerEntry(hostname: "continuum.us.netrek.org", port: 2592, age: 1000, players: 0, type: .bronco)
        let networkmom = MetaServerEntry(hostname: "netrek.networkmom.net", port: 2592, age: 1000, players: 0, type: .empire)
        self.servers[networkmom.hostname] = networkmom
        self.servers[pickled.hostname] = pickled
        self.servers[continuum.hostname] = continuum
    }

    func update() {
        for host in metahosts {
            update(metahost: host)
        }
    }
    func update(metahost: String) {
        let urlString = "http://\(metahost):\(self.port)"
        guard let urlComponents = URLComponents(string: urlString ) else {
            debugPrint("Failed to get url components from \(urlString) in MetaServer.swift")
            return
        }
        guard let url = urlComponents.url else {
            debugPrint("MetaServer.swift: error computing url components")
            return
        }

        if let dataTask = dataTasks[metahost] {
            dataTask.cancel()
        }
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTasks[metahost] = nil
            }
            if let error = error {
                debugPrint("MetaServer.update dataTask error when contacting metaserver url \(url) error \(error.localizedDescription)")
            } else if let data = data {
                //debugPrint("MetaServer data \(data)")
                if let dataString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.servers = [:]
                        let lines = dataString.components(separatedBy: self.newlineCharacters)
                        for line in lines {
                            //debugPrint("\(line) length \(line.count)")
                            if line.count == 79 {  // this length line has a metaserver entry
                                //let components = line.components(separatedBy: self.whiteSpace)
                                let allComponents = line.components(separatedBy: " ")
                                let components = allComponents.filter { $0 != ""}
                                //debugPrint("components \(components.count)")
                                if components.count > 6 {
                                    let hostname = components[1]
                                    let portString = components[3]
                                    let ageString = components[4]
                                    //let status = components[5]
                                    let possiblePlayers = components[6]
                                    let port = Int(portString)
                                    let age = Int(ageString)
                                    
                                    let players = Int(possiblePlayers) ?? 0
                                    let possibleType = components.last
                                    if let port = port, let age = age, let possibleType = possibleType {
                                        for type in MetaServerType.allCases {
                                            if possibleType == type.rawValue {
                                                let server = MetaServerEntry(hostname: hostname, port: port, age: age, players: players, type: type)
                                                self.servers[server.hostname] = server
                                                debugPrint("MetaServer.update: found server \(server.description)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    #if os(macOS)
                    DispatchQueue.main.async {
                        Universe.universe.metaserverUpdated()
                    }
                    #endif
                }
            }
        }
        dataTasks[metahost] = dataTask
        dataTask.resume()
    }
}
