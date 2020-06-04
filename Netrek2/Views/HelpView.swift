//
//  HelpView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/4/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject var help: Help
    
    var body: some View {
        Text(help.currentTip)
        .font(.largeTitle)
    }
}

/*struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}*/
