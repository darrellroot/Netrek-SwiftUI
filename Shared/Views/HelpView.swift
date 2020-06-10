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
    #if os(macOS)
    @ObservedObject var preferencesController: PreferencesController
    #endif
    
    var body: some View {
        #if os(macOS)
        return !preferencesController.hideHints ? Text(help.currentTip).font(.largeTitle) : Text("")
        #elseif os(iOS)
        return Text(help.currentTip).font(.largeTitle)
        #endif
    }
}

/*struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}*/
