//
//  PretixAPI.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 02.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

class PretixAPI {
    
    let configurationManager: PretixConfigurationManager
    var shared: PretixAPI?
    
    init(configurationManager: PretixConfigurationManager) {
        self.configurationManager = configurationManager
    }
    
    var downloadEndpointUrl: URL? {
        
        guard let urlString = self.configurationManager.currentAppConfiguration?.urlString, let secret = self.configurationManager.currentAppConfiguration?.secret else {
            return nil
        }
        
        let downloadURLString = urlString + "/download/?key=\(secret)"
        
        if let url = URL(string: downloadURLString) {
            return url
        }
     
        return nil
    }
    
    var uploadEndpointUrl: URL? {
        guard let urlString = self.configurationManager.currentAppConfiguration?.urlString, let secret = self.configurationManager.currentAppConfiguration?.secret else {
            return nil
        }
        
        let uploadURLString = urlString + "/redeem/?key=\(secret)"
        
        if let url = URL(string: uploadURLString) {
            return url
        }
        
        return nil
    }
        
}
