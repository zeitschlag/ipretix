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
        //MARK: - Ticket Download
        static let TicketDownloadStarted = Notification.Name("SyncManager.TicketDownloadStartedNotification")
        static let TicketDownloadFailed = Notification.Name("SyncManager.TicketDownloadFailedNotification")
        static let TicketDownloadSucceed = Notification.Name("SyncManager.TicketDownloadSucceededNotification")
        
        //MARK: - CheckIn aka Upload
        static let CheckInUploadStarted = Notification.Name("SyncManager.CheckInUploadStartedNotification")
        static let CheckInUploadFailed = Notification.Name("SyncManager.CheckInUploadFailedNotification")
        static let CheckInUploadSucceeded = Notification.Name("SyncManager.CheckInUploadSucceededNotification")
        static let CheckInUploadIncomplete = Notification.Name("SyncManager.CheckInUploadIncompleteNotification")
        
        struct UserInfo {
            static let ErrorDescriptionKey = "UserInfo.ErrorDescriptionKey"
        }
        
    }
    
    let ticketManager: TicketManager
    let checkInManager: CheckInManager
    let api: PretixAPI
    
    init(withTicketManager: TicketManager, andCheckInManager: CheckInManager, andAPI: PretixAPI) {
        self.ticketManager = withTicketManager
        self.checkInManager = andCheckInManager
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
                        try self.ticketManager.deleteTicket(withOrderCode: downloadedTicket.orderCode)
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
                    try self.ticketManager.deleteTicket(withOrderCode: removedTicketCode)
                }
                
                NotificationCenter.default.post(name: Notifications.TicketDownloadSucceeded, object: self)
                
                
            } catch {
                //TODO: Error Handling
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: error.localizedDescription]
                NotificationCenter.default.post(name: Notifications.TicketDownloadFailed, object: self, userInfo: userInfo)
                return
            }
            
            }.resume()
        
    }
    
    func applicationDidFinishLaunching() {
        self.downloadTickets()
    }
    
    func upload(checkIn: CheckIn) {
        guard let uploadUrl = self.api.uploadEndpointUrl else {
            assertionFailure("Please check Upload URL")
            return
        }
        
        guard let httpBody = self.checkInManager.uploadBody(forCheckIn: checkIn) else {
            assertionFailure("Please check Upload Body")
            return
        }
        
        var uploadRequest = URLRequest(url: uploadUrl)
        uploadRequest.httpMethod = "POST"
        uploadRequest.httpBody = httpBody
        
        NotificationCenter.default.post(name: Notifications.CheckInUploadStarted, object: self)
        
        URLSession.shared.dataTask(with: uploadRequest) { (data, response, error) in
            guard error == nil else {
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: error?.localizedDescription ?? "no error message"]
                NotificationCenter.default.post(name: Notifications.CheckInUploadFailed, object: self, userInfo: userInfo)
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                //TODO: Error Handling
                return
            }
            
            guard response.statusCode == 200 else {
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: NSLocalizedString("Server responded with Status Code \(response.statusCode)", comment: "")]
                NotificationCenter.default.post(name: Notifications.CheckInUploadFailed, object: self, userInfo: userInfo)
                return
            }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                let checkInUploadResponse = try jsonDecoder.decode(CheckInUploadResponse.self, from: data)
                
                switch checkInUploadResponse.status {
                case .ok:
                    try self.checkInUploadOk(checkInUploadResponse: checkInUploadResponse)
                case .incomplete:
                    self.checkinUploadIncomplete(checkInUploadResponse: checkInUploadResponse)
                case .error:
                    self.checkInUploadError(checkInUploadResponse: checkInUploadResponse)
                }
                
            } catch {
                //TODO: Error Handling
                let userInfo = [Notifications.UserInfo.ErrorDescriptionKey: error.localizedDescription]
                NotificationCenter.default.post(name: Notifications.CheckInUploadFailed, object: self, userInfo: userInfo)
                return
            }
            
            }.resume()
    }
    
    private func checkInUploadOk(checkInUploadResponse: CheckInUploadResponse) throws {
        try self.checkInManager.uploadedCheckIn(withSecret: checkInUploadResponse.data.secret)
        NotificationCenter.default.post(name: Notifications.CheckInUploadSucceeded, object: self)
    }
    
    private func checkinUploadIncomplete(checkInUploadResponse: CheckInUploadResponse) {
        NotificationCenter.default.post(name: Notifications.CheckInUploadIncomplete, object: self)
    }
    
    private func checkInUploadError(checkInUploadResponse: CheckInUploadResponse) {
        NotificationCenter.default.post(name: Notifications.CheckInUploadFailed, object: self)
    }
    
    // download conference status
    // sync on a regular basis
    
}
