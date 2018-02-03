//
//  SyncManager.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 02.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation

class SyncManager {
    
    struct Notifications {
        static let TicketDownloadStarted = Notification.Name("SyncManager.TicketDownloadStartedNotification")
        static let TicketDownloadFailed = Notification.Name("SyncManager.TicketDownloadFailedNotification")
        static let TicketDownloadSucceed = Notification.Name("SyncManager.TicketDownloadSucceededNotification")
        
        struct UserInfo {
            static let ErrorDescriptionKey = "UserInfo.ErrorDescriptionKey"
        }
        
    }
    
    let ticketManager: TicketManager
    let api: PretixAPI
    
    init(withTicketManager: TicketManager, andAPI: PretixAPI) {
        self.ticketManager = withTicketManager
        self.api = andAPI
    }
    
    func downloadTickets() {
        guard let downloadURL = self.api.downloadEndpointUrl else {
            assertionFailure("Please check Donwload URL")
            return
        }
        
        NotificationCenter.default.post(name: Notifications.TicketDownloadStarted, object: self)
        
        URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
            guard error == nil else {
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: error?.localizedDescription ?? "no error message"]
                NotificationCenter.default.post(name: Notifications.TicketDownloadFailed, object: self, userInfo: userInfo)
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                //TODO: Error Handling
                return
            }
            
            guard response.statusCode == 200 else {
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: NSLocalizedString("Server responded with Status Code \(response.statusCode)", comment: "")]
                NotificationCenter.default.post(name: Notifications.TicketDownloadFailed, object: self, userInfo: userInfo)
                return
            }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                let ticketDownloadResponse = try jsonDecoder.decode(TicketDownloadResponse.self, from: data)
                
                // use ticket manager to parse tickets
                // add new ones, delete deleted ones, update existing ones
                var existingOrderCodes = try self.ticketManager.getAllTickets().map({ (ticket) -> String in
                    return ticket.orderCode!
                })
                
                for downloadedTicket in ticketDownloadResponse.results {
                    
                    if existingOrderCodes.contains(downloadedTicket.orderCode) == true {
                       
                        // update existing one
                        self.ticketManager.deleteTicket(withOrderCode: downloadedTicket.orderCode)
                        try self.ticketManager.insertNewTicket(withOrderCode: downloadedTicket.orderCode,
                                                           itemName: downloadedTicket.item,
                                                           attendeeName: downloadedTicket.attendeeName,
                                                           needsAttention: downloadedTicket.attention,
                                                           isRedeemed: downloadedTicket.redeemed,
                                                           isPaid: downloadedTicket.paid,
                                                           secret: downloadedTicket.secret)
                        
                        if let index = existingOrderCodes.index(of: downloadedTicket.orderCode) {
                            existingOrderCodes.remove(at: index)
                        }
                    } else {
                        // add new one
                        try self.ticketManager.insertNewTicket(withOrderCode: downloadedTicket.orderCode,
                                                               itemName: downloadedTicket.item,
                                                               attendeeName: downloadedTicket.attendeeName,
                                                               needsAttention: downloadedTicket.attention,
                                                               isRedeemed: downloadedTicket.redeemed,
                                                               isPaid: downloadedTicket.paid,
                                                               secret: downloadedTicket.secret)
                    }
                    
                }
                
                // delete the rest
                for removedTicketCode in existingOrderCodes {
                    self.ticketManager.deleteTicket(withOrderCode: removedTicketCode)
                }
                
                NotificationCenter.default.post(name: Notifications.TicketDownloadSucceed, object: self)
                
                
            } catch {
                //TODO: Error Handling
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: error.localizedDescription]
                NotificationCenter.default.post(name: Notifications.TicketDownloadFailed, object: self, userInfo: userInfo)
                return
            }
            
        }.resume()
        
    }
    
    
    // download conference status
    
    // upload checkins
    // use the result to remove checkins
    
    // sync on a regular basis
    
}
