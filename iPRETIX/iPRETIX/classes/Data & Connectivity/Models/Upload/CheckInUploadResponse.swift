//
//  CheckInUploadResponse.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 25.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

struct CheckInUploadResponse: Codable {
    
    enum Status: String, Codable {
        case ok
        case incomplete
        case error
    }

    let version: Int
    let status: CheckInUploadResponse.Status
    let data: TicketDownloadContent
    
}
