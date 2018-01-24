//
//  AppConfiguration.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 17.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

class AppConfiguration {
    
    var urlString: String
    var showInfo: Bool
    var secret: String
    var allowSearch: Bool
    
    init(allowSearch: Bool, showInfo: Bool, urlString: String, secret: String) {
        self.allowSearch = allowSearch
        self.showInfo = showInfo
        self.urlString = urlString
        self.secret = secret
    }
    
}
