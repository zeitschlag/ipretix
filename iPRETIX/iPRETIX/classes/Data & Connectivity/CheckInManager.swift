//
//  CheckInManager.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 02.02.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import Foundation
import CoreData

//?: A superclass/protocol might be a good idea here
class CheckInManager {
    
    let coreDataStack: CoreDataStack
    private let fetchCheckinRequest: NSFetchRequest<CheckIn> = CheckIn.fetchRequest()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getAllCheckIns() throws -> [CheckIn] {
        return try self.coreDataStack.persistentContainer.viewContext.fetch(self.fetchCheckinRequest)
    }
    
    func insertNewCheckIn(withDateTime date: Date, secret: String) throws -> CheckIn  {
        let newCheckIn = CheckIn(entity: CheckIn.entity(), insertInto: coreDataStack.persistentContainer.viewContext)
        
        newCheckIn.dateTime = date
        newCheckIn.secret = secret
        
        try coreDataStack.saveContext()
        
        return newCheckIn
    }
    
    func uploadedCheckIn(withSecret secret: String) throws {
        try self.delete(checkInWithSecret: secret)
    }
    
    private func delete(checkInWithSecret secret: String) throws {
        let fetchRequest: NSFetchRequest<CheckIn> = CheckIn.fetchRequest()
        
        let predicate = NSPredicate(format: "secret = %@", secret)
        fetchRequest.predicate = predicate
        
        for ticket in try coreDataStack.persistentContainer.viewContext.fetch(fetchRequest) {
            self.coreDataStack.persistentContainer.viewContext.delete(ticket)
        }
        
        try self.coreDataStack.saveContext()

    }
    
    func uploadBody(forCheckIn checkIn: CheckIn) -> Data? {
        
        guard let secret = checkIn.secret else {
            return nil
        }
        var uploadBody = ""
        uploadBody += "secret=\(secret)"
        
        return uploadBody.data(using: .utf8)
    }
}
