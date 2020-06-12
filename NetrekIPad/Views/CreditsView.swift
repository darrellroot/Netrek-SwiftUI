//
//  CreditsView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/12/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct CreditsView: View {
    var appDelegate: AppDelegate
    let helptext = """
The developer: Darrell Root / Network Mom LLC encourages feedback at feedback@networkmom.net

XTrek
XTrek was developed for Unix Workstations running the X Window system in 1986 by Chris Guthrie (only 3 years after IP version 4 was deployed on January 1st 1983, and long before the invention of the “graphical web browser”).  XTrek ran on one large server with multiple players “remote displayed” on Unix Workstations over a LAN.  WAN play was not practical because the entire graphical display was transmitted over the network.  XTrek had one ship type and up to 3 torpedoes per ship.

Netrek
Netrek was originally implemented in C for Unix Workstations  in 1989 by Kevin P Smith and Scott Silvey.  Netrek used a client-server model with a “Netrek Server” running on one workstation and multiple clients connecting to the server.  Netrek very efficiently minimized the amount of data to be transmitted over the network, allowing International network play over the Internet, despite the relatively small bandwidth WAN links of the time.
Both XTrek and Netrek had very lenient public domain copyright notices.  Over the years, Netrek was gradually improved (short and generic packets optimizations) and modified (Paradise and Sturgeon variants).  Netrek clients were implemented for different platforms (Microsoft Windows, Mac) and in different languages (Python, HTML5, and now Swift).  Many programmers learned network and game programming on Netrek and went on to program for some of the largest corporations on the planet.
While this Swift Netrek Client does not use source code from any prior client (wrong language) it uses the API’s from the original Netrek.  In accordance with our debt to this open source software, the Swift Netrek client is free to play and the code will be open sourced.

Netrek Servers
This client is only part of Netrek.  Playing the game would not be possible without the Netrek servers which are still running on the Internet.  As of April 2019, this includes pickled.netrek.org, continuum.us.netrek.org, and netrek.beesenterprises.com.

Programmer
This Swift Netrek Client is written by Darrell Root for Network Mom LLC.  Check out https://networkmom.net/netrek for more information.  While the client and source code are free, please considering thanking the developer with a positive review in the MacOS App Store or by leaving “tipping the developer” via in-app purchase.

Programming Language and Environment
This Swift Netrek client is written in……Swift!  The new programming language from Apple.  Chris Lattner was the originator and leader of the Swift project.  Thank you Chris!  We love this language.
Netrek uses the new “Network” framework from Apple.  This is a new API for handling TCP and UDP sockets.  It is noticeably easier to use than the old BSD socket API.
Netrek version 1 used SpriteKit for displaying graphics.
Netrek version 2.0 uses SwiftUI for displaying graphics in the tactical map!

Sounds
Our main sound collection is the “Dartoxian Space Weapons” sounds by jonccox from freesound.org under the Creative Commons Attribution License:
175262__jonccox__gun-cannon.wav
175265__jonccox__gun-thumper.wav (used for laser)
175266__jonccox__gun-spark.wav
175267__jonccox__gun-plasma.wav (used for plasma)
175269__jonccox__gun-zap2.wav (used for torpedo)
175270__jonccox__gun-zap.wav (used for detonate)

The following other sounds were used from freesound.org under the Creative Commons Attribution License or the Creative Commons 0 License:
Explosion from deleted user  399303__deleted-user-5405837__explosion-012.mp3
Shield sound from ludvique   71852__ludvique__digital-whoosh-soft.wav

Graphics
The planet icons were made by Darrell Root (Network Mom LLC) based on screenshots of the original COW Netrek Client from the 1990’s.
The Roman (red fleet), Kazari (green fleet), and Orion (blue fleet) ship icons came original from the artist Pascal Gagnon via the Gytha Netrek Client under the Creative Commons Attribution License.
The Federation (outline fleet) and Independent (also outline fleet) ship icons came from the MacTrek 1.5 client (written in Objective C in 2006) by Chris and Judith Lukassen.  Judith did the artwork.

Prior Netrek Client: MacTrek
Chris and Judith Lukassen wrote Mac Trek in Objective C around 2006.  While the Swift Netrek Client does not use any of their source code, I learned much about both Netrek and programming from their code.

Prior Netrek Client: Gytha
James Cameron (aka Quozl) wrote the Gytha netrek client in 2012.  Implemented in Python, we used the code as a resource during our development.  James Cameron helpfully answered several questions during our development.

Prior Netrek Client: BRMH
Developed in c in the 1990’s we also used this client as a resource during development.  There are too many developers of BRMH so we refer you to http://www.netrek.org/files/archive/BRMH/BRMH.html for more information.

Netrek Vanilla Server
We used the Netrek Vanilla Server (written in C, maintained by James Cameron) as a reference during development.  See https://github.com/quozl/netrek-server for more information.

Netrek Hints
Many of the advanced hints on the tactical screen came from the Windows netrek client courtesy of Bill Balcerski.
"""
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Select Server")
            }.font(.title)
                .onTapGesture {
                    self.appDelegate.gameScreen = .noServerSelected
                }
                Spacer()
            }
            ScrollView {
                Text(helptext)
            }
        }
    }
    
    
}


/*struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}*/
