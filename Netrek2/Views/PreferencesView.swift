//
//  PreferencesView.swift
//  Netrek2
//
//  Created by Darrell Root on 6/1/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import SwiftUI

class ActivePreference: ObservableObject {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate

    @Published var currentControl: Control = Control.allCases.first! {
        didSet {
            debugPrint("current control updated")
            self.readCommand()
            //self.currentCommand = appDelegate.keymapController.keymap[currentControl] ?? Command.nothing
        }
    }
    @Published var currentCommand: Command = Command.allCases.first! {
        didSet {
            debugPrint("considering whether keymap update is necessary")
            if currentCommand != appDelegate.keymapController.keymap[currentControl] {
                debugPrint("current control \(currentControl.rawValue) updated to \(currentCommand.rawValue)")
                appDelegate.keymapController.setKeymap(control: currentControl, command: currentCommand)
            }
        }
    }
    
    init() {
        currentCommand = appDelegate.keymapController.keymap[currentControl] ?? Command.nothing
    }
    public func readCommand() {
        self.currentCommand = appDelegate.keymapController.keymap[currentControl] ?? Command.nothing
    }
}
struct PreferencesView: View {

    @ObservedObject var activePreference = ActivePreference()
    
    var keymapController: KeymapController
        
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Control")
                    Picker(selection: $activePreference.currentControl, label: EmptyView()) {
                        ForEach(Control.allCases, id: \.self) { control in
                            Text(control.rawValue)
                        }
                    }
                }//VStack
                VStack {
                    Text("")
                    Text("->").font(.headline)
                }//VStack
                VStack {
                    Text("Command")
                    Picker(selection: $activePreference.currentCommand, label: EmptyView()) {
                        ForEach(Command.allCases, id: \.self) { command in
                            Text(command.rawValue)
                        }
                    }
                }//VStack
            }//HStack
            Button("Reset All To Defaults") {
                self.keymapController.resetKeymaps()
                self.activePreference.readCommand()
            }
        }//VStack
        .padding(8)
    }//var body
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(keymapController: KeymapController())
    }
}
