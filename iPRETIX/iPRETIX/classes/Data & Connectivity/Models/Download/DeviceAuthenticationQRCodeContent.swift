//
//  DeviceAuthentication.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 04.11.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

struct DeviceAuthenticationQRCodeContent: Codable {
    var handshakeVersion: Int
    var url: String
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case handshakeVersion = "handshake_version"
        case url = "url"
        case token = "token"
    }
}
