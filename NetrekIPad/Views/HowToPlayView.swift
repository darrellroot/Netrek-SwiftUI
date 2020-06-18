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
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    var bigText: Font {
        guard let vSizeClass = vSizeClass else {
            return Font.headline
        }
        switch vSizeClass {
        case .regular:
            return .title
        case .compact:
            return .headline
        }
    }
    var regularText: Font {
        guard let vSizeClass = vSizeClass else {
            return Font.body
        }
        switch vSizeClass {
            
        case .regular:
            return .headline
        case .compact:
            return Font.body
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Select Server")
                }.font(bigText)
                .foregroundColor(Color.blue)
                .onTapGesture {
                    self.appDelegate.gameScreen = .noServerSelected
                }
                Spacer()
                Text("How To Play").font(bigText)
                Spacer()
                Text("          ")
            }
            ScrollView {
                HStack { //extra hstack and spacer to enforce leading position (bug?)
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Tapping on screen near center fires torpedoes").padding(.bottom)
                            Text("Tapping on screen near center fires torpedoes").padding(.bottom)
                            Text("Tapping on screen near edge sets course").padding(.bottom)
                            Text("Stepper at bottom right sets desired speed").padding(.bottom)
                            Text("First tap on enemy ship fires laser").padding(.bottom)
                            Text("More taps on enemy ship fires torpedoes").padding(.bottom)
                            Text("Pinch tactical screen to zoom in or out").padding(.bottom)
                        }
                        VStack(alignment: .leading) {
                            Text("Lasers recharge in 1 second").padding(.bottom)
                            Text("Tapping on planet locks onto planet for orbit").padding(.bottom)
                            Text("\"Circle\" of planet and player indicators show long-range scans").padding(.bottom)
                            Text("Long range scans in BOLD have extra armies or 2+ kills").padding(.bottom)
                            Text("To exit, click on both \"Captain: Self Destruct\" and \"1st Officer: Self Destruct\"").padding(.bottom)
                            Text("See www.netrek.org to learn about Netrek strategy")
                        }
                    }
                    Spacer()
                }
            }
            .font(regularText)
        }//VStack
        .padding()
    }
}

struct HowToPlay_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
