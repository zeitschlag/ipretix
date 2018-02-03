//
//  TicketDownloadContent.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 02.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

struct TicketDownloadContent: Codable {
    
    let secret: String
    let orderCode: String
    let item: String
    let attendeeName: String
    let redeemed: Bool
    let attention: Bool
    let paid: Bool
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        
        case secret = "secret"
        case orderCode = "order"
        case item = "item"
        case attendeeName = "attendee_name"
        case redeemed = "redeemed"
        case attention = "attention"
        case paid = "paid"
        
    }

}
