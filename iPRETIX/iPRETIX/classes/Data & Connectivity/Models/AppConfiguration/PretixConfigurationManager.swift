//
//  AppConfigurationManager.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 23.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

class PretixConfigurationManager {

    private(set) var currentAppConfiguration: PretixConfiguration?
    
    private struct UserDefaultKeys {
        static let allowSearch = "iPretixAllowSearchKey"
        static let showInfo = "iPretixShowInfoKey"
    }

    private struct KeyChainKey {
        static let account = "iPretixAccount"
        static let service = "iPretixService"
    }
    
    func loadAppConfiguration() {
        
        let showInfo = UserDefaults.standard.bool(forKey: UserDefaultKeys.showInfo)
        let allowSearch = UserDefaults.standard.bool(forKey: UserDefaultKeys.allowSearch)

        let queryDict: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecMatchLimit as String: kSecMatchLimitOne,
                                        kSecAttrAccount as String: KeyChainKey.account,
                                        kSecReturnAttributes as String: true,
                                        kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let queryStatus = SecItemCopyMatching(queryDict as CFDictionary, &item)
        
        if queryStatus != errSecSuccess {
            if queryStatus == errSecItemNotFound {
                NSLog("Not found")
            } else {
                assertionFailure("Check query!")
            }
            return
        }
        
        guard let existingItem = item as? [String: Any],
            let secretData = existingItem[kSecValueData as String] as? Data,
            let secret = String(data: secretData, encoding: .utf8),
            let urlString = existingItem[kSecAttrServer as String] as? String else {
                assertionFailure("No item found")
                return
        }
        
        //print("Found app configuration: allowSearch: \(allowSearch), showInfo: \(showInfo), urlString: \(urlString), secret: \(secret), uploadImmediately: \(uploadImmediately)")
        currentAppConfiguration = PretixConfiguration(allowSearch: allowSearch, showInfo: showInfo, urlString: urlString, secret: secret)

    }
    
    private func saveCurrentAppConfiguration() {
        guard let currentAppConfiguration = self.currentAppConfiguration else {
            return
        }
        
        UserDefaults.standard.set(currentAppConfiguration.showInfo, forKey: UserDefaultKeys.showInfo)
        UserDefaults.standard.set(currentAppConfiguration.allowSearch, forKey: UserDefaultKeys.allowSearch)

        guard let secretData = currentAppConfiguration.secret.data(using: .utf8) else {
            assertionFailure("Please check key")
            return
        }
        
        // you save dictionaries to the keychain, sometimes, they have certain attributes
        let dict: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrServer as String: currentAppConfiguration.urlString,
                                   kSecAttrAccount as String: KeyChainKey.account,
                                   kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
                                   kSecValueData as String: secretData
        ]
        
        let queryDict: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecMatchLimit as String: kSecMatchLimitOne,
                                        kSecAttrAccount as String: KeyChainKey.account,
        ]

        
        let attributesToUpdate: [String: Any] = [kSecAttrServer as String: currentAppConfiguration.urlString,
                                                 kSecValueData as String: secretData
        ]
        
        // we have to check: if the item already exists, we have to use SecItemUpdate instead of SecItemAdd
        if SecItemCopyMatching(dict as CFDictionary, nil) == errSecSuccess {
            let status = SecItemUpdate(queryDict as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                assertionFailure("Creating failed. Please check Keychain-thing, https://www.osstatus.com/search/results?platform=all&framework=all&search=\(status)")
            }
        } else {
            let status = SecItemAdd(dict as CFDictionary, nil)
            if status != errSecSuccess {
                assertionFailure("Creating failed. Please check Keychain-thing, https://www.osstatus.com/search/results?platform=all&framework=all&search=\(status)")
            }
        }
    }

    func newAppConfigurationAvailable(_ appConfiguration: PretixConfiguration) {
        self.currentAppConfiguration = appConfiguration
        self.saveCurrentAppConfiguration()
    }
    
    func deleteCurrentAppConfiguration() {
        guard let currentAppConfiguration = self.currentAppConfiguration else {
            return
        }
        
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.showInfo)
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.allowSearch)
        
        let queryDict: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: KeyChainKey.account,
                                        kSecAttrServer as String: currentAppConfiguration.urlString
        ]
        
        let status = SecItemDelete(queryDict as CFDictionary)
        
        if status != errSecSuccess {
            print("Deleting failed. Please check Keychain-thing, https://www.osstatus.com/search/results?platform=all&framework=all&search=\(status)")
            assertionFailure()
            return
        } else {
            self.currentAppConfiguration = nil
        }
    }
}
