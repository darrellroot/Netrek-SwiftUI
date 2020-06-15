//
//  HowToPlay.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

struct HowToPlayView: View {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Select Server")
                }.font(.title)
                .foregroundColor(Color.blue)
                .onTapGesture {
                    self.appDelegate.gameScreen = .noServerSelected
                }
                Spacer()
                Text("How To Play").font(.largeTitle)
                Spacer()
                Text("          ")
            }
            VStack(alignment: .leading) {
                Text("Tapping on screen fires torpedoes").padding(.bottom)
                Text("Dragging on screen sets course to end of drag").padding(.bottom)
                Text("Dragging on screen sets speed to magnitude of drag").padding(.bottom)
                Text("First tap on enemy ship fires laser").padding(.bottom)
                Text("More taps on enemy ship fires torpedoes").padding(.bottom)
            }
            VStack(alignment: .leading) {
                Text("Lasers recharge in 1 second").padding(.bottom)
                Text("Tapping on planet locks onto planet for orbit")
                Spacer()
                Text("To exit, click on both \"Captain: Self Destruct\" and \"1st Officer: Self Destruct\"")
                Spacer()
                Text("See www.netrek.org to learn about Netrek strategy")
            }
        }.font(.title)
        .padding()
    }
}

struct HowToPlay_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
