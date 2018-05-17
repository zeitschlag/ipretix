//
//  TicketManager.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 30.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation
import CoreData

class TicketManager {
    
    enum TicketRedeemingResult {
        case valid
        case validWithRequirements
        case alreadyRedeemed
        case error(localizedDescription: String)
    }
    
    let coreDataStack: CoreDataStack
    
    private let fetchTicketRequest: NSFetchRequest<Ticket> = Ticket.fetchRequest()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getAllTickets() throws -> [Ticket] {
        return try coreDataStack.persistentContainer.viewContext.fetch(self.fetchTicketRequest)
    }
    
    func insertNewTicket(withOrderCode orderCode: String, itemName: String, attendeeName: String, needsAttention attention: Bool, isRedeemed redeemed: Bool, isPaid paid: Bool, secret: String) throws {
        
        let newTicket = Ticket(entity: Ticket.entity(), insertInto: coreDataStack.persistentContainer.viewContext)
        
        newTicket.orderCode = orderCode
        newTicket.itemName = itemName
        newTicket.attendeeName = attendeeName
        newTicket.attention = attention
        newTicket.redeemed = redeemed
        newTicket.paid = paid
        newTicket.secret = secret
        
        try coreDataStack.saveContext()
    }
    
    func deleteTicket(withOrderCode orderCode: String) throws {
        let fetchRequest: NSFetchRequest<Ticket> = Ticket.fetchRequest()
        
        let predicate = NSPredicate(format: "orderCode = %@", orderCode)
        fetchRequest.predicate = predicate
        
        for ticket in try coreDataStack.persistentContainer.viewContext.fetch(fetchRequest) {
            self.coreDataStack.persistentContainer.viewContext.delete(ticket)
        }
        
        try self.coreDataStack.saveContext()
        
    }
    
    func redeemTicket(_ ticket: Ticket) -> TicketRedeemingResult {
        // redeem it
        // save it

        do {
            
            guard ticket.redeemed == false else {
                return .alreadyRedeemed
            }
            
            ticket.redeemed = true
            
            try self.coreDataStack.saveContext()
            
            if ticket.attention == true {
                return .validWithRequirements
            }
            
            return .valid
        } catch {
            return .error(localizedDescription: error.localizedDescription)
        }
        
        
    }
    
    func ticket(withSecret secret: String) throws -> Ticket? {
        
        let filteredTicket = try getAllTickets().filter({ (ticket) -> Bool in
            return ticket.secret == secret
        })
        
        guard filteredTicket.count <= 1, let ticket = filteredTicket.first else {
            return nil
        }
        
        return ticket
        
    }
    
}
