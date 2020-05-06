//
//  MetaServer.swift
//  Netrek
//
//  Created by Darrell Root on 3/1/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import AppKit

class MetaServer {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let hostname: String
    let port: Int
    let url: URL
    var dataTask: URLSessionDataTask?
    let defaultSession = URLSession(configuration: .default)
    let newlineCharacters = NSCharacterSet.newlines
    let whiteSpace = NSCharacterSet.whitespaces
    init?(hostname: String, port: Int) {
        self.hostname = hostname
        self.port = port
        let urlString = "http://\(hostname):3521"
        guard let urlComponents = URLComponents(string: urlString ) else { return nil }
        guard let url = urlComponents.url else { return nil }
        self.url = url
    }
    var servers: [MetaServerEntry] = []
    
    func update() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                debugPrint("MetaServer.update dataTask error when contacting metaserver url \(self.url) error \(error.localizedDescription)")
            } else if let data = data {
                //debugPrint("MetaServer data \(data)")
                if let dataString = String(data: data, encoding: .utf8) {
                    self.servers = []
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
                                            self.servers.append(server)
                                            debugPrint("MetaServer.update: found server \(server.description)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.appDelegate.metaserverUpdated()
                    }
                }
            }
        }
        dataTask?.resume()
    }
}
