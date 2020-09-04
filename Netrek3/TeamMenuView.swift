//
//  TeamMenuView.swift
//  Netrek3
//
//  Created by Darrell Root on 9/4/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct TeamMenuView: View {
    let team: Team
    @ObservedObject var universe: Universe
    
    var body: some View {
        team == universe.preferredTeam ?
            HStack {
                Image(systemName: "checkmark")
                Text(" \(team.description)")
            } :
            HStack {
                Image(systemName: "nosuchimage")
                Text("      \(team.description)")
            }
    }
}

/*struct TeamMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TeamMenuView()
    }
}*/
