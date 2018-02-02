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
    
    let coreDataStack: CoreDataStack
    
    private let fetchTicketRequest: NSFetchRequest<Ticket> = Ticket.fetchRequest()
    
    init(withCoreDataStack: CoreDataStack) {
        self.coreDataStack = withCoreDataStack
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
        
        do {
            try coreDataStack.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func redeemTicket(withOrderCode orderCode: String) {
        //TODO: get ticket with a certain order code
        // redeem it
        // save it
    }
    
    func deleteTicket(withOrderCode orderCode: String) {
        //TODO: Implement
    }
    
}
