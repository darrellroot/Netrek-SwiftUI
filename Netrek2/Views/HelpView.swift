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
    @ObservedObject var preferencesController: PreferencesController
    
    var body: some View {
        !preferencesController.hideHints ? Text(help.currentTip).font(.largeTitle)
            : Text("")
        
    }
}

/*struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}*/
