//
//  AppConfigurationManager.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 23.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

class AppConfigurationManager {

    private(set) var currentAppConfiguration: AppConfiguration?
    
    private struct UserDefaultKeys {
        static let allowSearchKey = "iPretixAllowSearchKey"
        static let showInfoKey = "iPretixShowInfoKey"
    }

    private struct KeyChainKey {
        static let account = "iPretixAccount"
        static let service = "iPretixService"
    }
    
    func loadAppConfiguration() {
        
        let showInfo = UserDefaults.standard.bool(forKey: UserDefaultKeys.showInfoKey)
        let allowSearch = UserDefaults.standard.bool(forKey: UserDefaultKeys.allowSearchKey)

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
        print("Found app configuration: allowSearch: \(allowSearch), showInfo: \(showInfo), urlString: \(urlString), secret: \(secret)")
        currentAppConfiguration = AppConfiguration(allowSearch: allowSearch, showInfo: showInfo, urlString: urlString, secret: secret)

    }
    
    private func saveCurrentAppConfiguration() {
        guard let currentAppConfiguration = self.currentAppConfiguration else {
            return
        }
        
        UserDefaults.standard.set(currentAppConfiguration.showInfo, forKey: UserDefaultKeys.showInfoKey)
        UserDefaults.standard.set(currentAppConfiguration.allowSearch, forKey: UserDefaultKeys.allowSearchKey)

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
                                        kSecReturnAttributes as String: false,
                                        kSecReturnData as String: false
        ]

        
        let attributesToUpdate: [String: Any] = [kSecAttrServer as String: currentAppConfiguration.urlString,
                                                 kSecValueData as String: secretData
        ]
        
        // we have to check: if the item already exists, we have to use SecItemUpdate instead of SecItemAdd
        if SecItemCopyMatching(dict as CFDictionary, nil) == errSecSuccess {
            let status = SecItemUpdate(queryDict as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                assertionFailure("Updating failed. Please check Keychain-thing, osstatus: \(status)")
            }
        } else {
            let status = SecItemAdd(dict as CFDictionary, nil)
            if status != errSecSuccess {
                assertionFailure("Creating failed. Please check Keychain-thing, osstatus: \(status)")
            }
            
        }
    }

    func newAppConfigurationAvailable(_ appConfiguration: AppConfiguration) {
        self.currentAppConfiguration = appConfiguration
        self.saveCurrentAppConfiguration()
    }
}
