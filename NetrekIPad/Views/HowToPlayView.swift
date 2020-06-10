//
//  HowToPlay.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var displayHelp: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Select Server")
                }.onTapGesture {
                    self.displayHelp = false
                }
                Spacer()
                Text("How To Play")
                Spacer()
            }
        }
    }
}

struct HowToPlay_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView(displayHelp: .constant(true))
    }
}
