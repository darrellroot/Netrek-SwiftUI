//
//  LoginInformationController.swift
//  Netrek
//
//  Created by Darrell Root on 3/14/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
import Security

// The ViewController stuff here may no longer be necessary, but static functions still used 5/5/20

class LoginInformationController: NSViewController {

    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    //let keychainService = KeychainService()
    static let keychainService = "NetrekService"
    static let keychainAccount = "NetrekAccount"
    
    @IBOutlet weak var segmentedControlOutlet: NSSegmentedControl!
    
    @IBOutlet weak var nameOutlet: NSTextField!
    @IBOutlet weak var passwordOutlet: NSSecureTextField!
    @IBOutlet weak var userNameOutlet: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let name = appDelegate.loginName {
            nameOutlet.stringValue = name
        }
        if let userName = appDelegate.loginUserName {
            userNameOutlet.stringValue = userName
        }
        if let loginPassword = appDelegate.loginPassword {
            passwordOutlet.stringValue = loginPassword
        }
        if appDelegate.loginAuthenticated {
            segmentedControlOutlet.selectedSegment = 1
        } else {
            segmentedControlOutlet.selectedSegment = 0
        }
    }
    
    override func viewWillDisappear() {
        self.updateName()
        self.updatePassword()
        self.updateUsername()
    }
    private func updateName() {
        if nameOutlet.stringValue != "" {
            appDelegate.loginName = nameOutlet.stringValue
            defaults.setString(string: nameOutlet.stringValue, forKey: LoginDefault.loginName.rawValue)
        } else {
            appDelegate.loginName = nil
            defaults.removeObject(forKey: LoginDefault.loginName.rawValue)
        }
    }
    private func updatePassword() {
        if passwordOutlet.stringValue != "" {
            appDelegate.loginPassword = passwordOutlet.stringValue
            KeychainService.removePassword(service: LoginInformationController.keychainService, account: LoginInformationController.keychainAccount)
            KeychainService.savePassword(service: LoginInformationController.keychainService, account: LoginInformationController.keychainAccount, data: passwordOutlet.stringValue)
            //self.clearPasswordKeychain()
            //self.savePasswordKeychain(password: passwordOutlet.stringValue)
        } else {
            appDelegate.loginPassword = nil
            KeychainService.removePassword(service: LoginInformationController.keychainService, account: LoginInformationController.keychainAccount)
            //self.clearPasswordKeychain()
        }
    }
    static func getPasswordKeychain() -> String? {
        return KeychainService.loadPassword(service: keychainService, account: keychainAccount)
    }
    private func updateUsername() {
        if userNameOutlet.stringValue != "" {
            appDelegate.loginUserName = userNameOutlet.stringValue
            defaults.setString(string: userNameOutlet.stringValue, forKey: LoginDefault.loginUserName.rawValue)
        } else {
            appDelegate.loginPassword = nil
            defaults.removeObject(forKey: LoginDefault.loginUserName.rawValue)
        }
    }
    @IBAction func segmentedControlSelected(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            appDelegate.loginAuthenticated = false
            defaults.set(false, forKey: LoginDefault.loginAuthenticated.rawValue)
        }
        if sender.selectedSegment == 1 {
            appDelegate.loginAuthenticated = true
            defaults.set(true, forKey: LoginDefault.loginAuthenticated.rawValue)
        }
    }
    @IBAction func nameTextFieldAction(_ sender: NSTextField) {
        self.updateName()
    }
    @IBAction func passwordTextFieldAction(_ sender: NSSecureTextField) {
        self.updatePassword()
    }
    @IBAction func usernameTextFieldAction(_ sender: NSTextField) {
        self.updateUsername()
    }
    /*func clearPasswordKeychain() {
        var statusString = ""
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrApplicationTag as String: "SwiftNetrekKey"]
        let status = SecItemDelete(query as CFDictionary)
        if let cfStatusString = SecCopyErrorMessageString(status, nil) {
            statusString = String(cfStatusString)
            if status == 0 {
                statusString = "success"
            }
        } else {
            statusString = status.description
        }
        debugPrint("LoginInformationController.clearPasswordKeychain status \(statusString)")
    }
    func savePasswordKeychain(password: String) {
        var statusString = ""
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrApplicationTag as String: "SwiftNetrekKey", kSecValueData as String: password.utf8]
        let status = SecItemAdd(query as CFDictionary, nil)
        if let cfStatusString = SecCopyErrorMessageString(status, nil) {
            statusString = String(cfStatusString)
            if status == 0 {
                statusString = "success"
            }
        }
        debugPrint("LoginInformationController.savePasswordKeychain status \(statusString)")
    }
    static func getPasswordKeychain() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrApplicationTag as String: "SwiftNetrekKey", kSecMatchLimit as String: kSecMatchLimitOne, kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        let statusString: String
        if let cfStatusString = SecCopyErrorMessageString(status, nil) {
            statusString = String(cfStatusString)
        } else {
            statusString = status.description
        }
        guard status == errSecSuccess else {
            debugPrint("LoginInformationController.getPasswordKeychain netrek password not found status \(statusString)")
            return nil
        }
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let keychainPassword = String(data: passwordData, encoding: String.Encoding.utf8) else {
                debugPrint("LoginInformationController.getPasswordKeychain netrek password could not be decoded")
                return nil
        }
        debugPrint("LoginInformationController.getPasswordKeychain successfull decoded password \(keychainPassword)")
        return keychainPassword
        
    }*/
}
