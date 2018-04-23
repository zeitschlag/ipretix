//
//  AppSettings.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 23.04.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

class LocalAppSettings {

    private struct UserDefaultKeys {
        static let uploadImmediately = "iPretixUploadImmediatelyKey"
    }
    
    var uploadImmediately: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultKeys.uploadImmediately)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.uploadImmediately)
        }
    }
}
