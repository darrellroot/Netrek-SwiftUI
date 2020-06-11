//
//  MessagesView.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var universe: Universe
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(self.universe.recentMessages, id: \.self) { message in
                Text(message)
                    .font(.headline)
            }
        }
    }
}

/*struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}*/
