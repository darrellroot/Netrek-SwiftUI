//
//  LoginInformationController.swift
//  Netrek
//
//  Created by Darrell Root on 3/14/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import SwiftUI
import Security

// The ViewController stuff here may no longer be necessary, but static functions still used 5/5/20

class LoginInformationController: ObservableObject {

    @Published var loginName: String = ""
    @Published var loginPassword: String = ""
    @Published var userInfo: String = ""
    @Published var loginAuthenticated = false {
        didSet {
            self.updateLoginAuthenticated(loginAuthenticated: loginAuthenticated)
        }
    }
    var validInfo: Bool {
        if loginName.count == 0 {
            return false
        }
        if loginPassword.count == 0 {
            return false
        }
        if userInfo.count == 0 {
            return false
        }
        return true
    }

    
    var securePassword: String {
        var retval = ""
        for _ in 0 ..< loginPassword.count {
            retval.append("•")
        }
        return retval
    }


    //let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    //let keychainService = KeychainService()
    static let keychainService = "NetrekService"
    static let keychainAccount = "NetrekAccount"

    init() {
        if let loginName = defaults.string(forKey: LoginDefault.loginName.rawValue) {
            self.loginName = loginName
        }
        if let userInfo = defaults.string(forKey: LoginDefault.userInfo.rawValue) {
            self.userInfo = userInfo
        }
        self.loginAuthenticated = defaults.bool(forKey: LoginDefault.loginAuthenticated.rawValue)
            
        if let loginPassword = LoginInformationController.getPasswordKeychain() {
            self.loginPassword = loginPassword
        }
    }
    
    func updateName(name: String) {
        self.loginName = name
        if name != "" {
            //appDelegate.loginName = name
            defaults.setString(string: name, forKey: LoginDefault.loginName.rawValue)
        } else {
            //appDelegate.loginName = nil
            defaults.removeObject(forKey: LoginDefault.loginName.rawValue)
        }
    }
    func updatePassword(password: String) {
        self.loginPassword = password
        if password != "" {
            //appDelegate.loginPassword = passwordOutlet.stringValue
            KeychainService.removePassword(service: LoginInformationController.keychainService, account: LoginInformationController.keychainAccount)
            KeychainService.savePassword(service: LoginInformationController.keychainService, account: LoginInformationController.keychainAccount, data: password)
            //self.clearPasswordKeychain()
            //self.savePasswordKeychain(password: passwordOutlet.stringValue)
        } else {
            //appDelegate.loginPassword = nil
            KeychainService.removePassword(service: LoginInformationController.keychainService, account: LoginInformationController.keychainAccount)
            //self.clearPasswordKeychain()
        }
    }
    static func getPasswordKeychain() -> String? {
        return KeychainService.loadPassword(service: keychainService, account: keychainAccount)
    }
    func updateUserInfo(userInfo: String) {
        self.userInfo = userInfo
        if userInfo != "" {
            //appDelegate.loginUserName = username
            defaults.setString(string: userInfo, forKey: LoginDefault.userInfo.rawValue)
        } else {
            //appDelegate.loginPassword = nil
            defaults.removeObject(forKey: LoginDefault.userInfo.rawValue)
        }
    }
    func updateLoginAuthenticated(loginAuthenticated: Bool) {
        if loginAuthenticated {
            defaults.set(true, forKey: LoginDefault.loginAuthenticated.rawValue)
        } else {
            defaults.set(false, forKey: LoginDefault.loginAuthenticated.rawValue)
        }
    }
}
