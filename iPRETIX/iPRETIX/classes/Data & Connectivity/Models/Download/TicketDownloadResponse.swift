//
//  TicketDownloadResponse.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 02.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

struct TicketDownloadResponse: Codable {

    let version: Int
    let results: [TicketDownloadContent]

}

