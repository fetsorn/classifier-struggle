//
//  Guess.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import CoreData

extension Guess {
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
    public var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dateString = formatter.string(from: wrappedDate)
        return dateString
    }

}

extension Guess {
    static func createRandom(origin: Game,
                       in managedObjectContext: NSManagedObjectContext){
        let newGuess = self.init(context: managedObjectContext)
        
        newGuess.date = Date()
        newGuess.origin = origin
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }

    static func create(date: Date,
                       origin: Game,
                       in managedObjectContext: NSManagedObjectContext){
        let newGuess = self.init(context: managedObjectContext)
        
        newGuess.date = date
        newGuess.origin = origin
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    func editRandom(in managedObjectContext: NSManagedObjectContext){
        
        guard let origin = self.origin else {
            print("Failed to find origin to edit this guess")
            return
        }
        
        self.date = Date()
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    func edit(date: Date,
              in managedObjectContext: NSManagedObjectContext) {

        self.date = date
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    func delete(in managedObjectContext: NSManagedObjectContext){
        
        managedObjectContext.delete(self)
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
}

extension Collection where Element == Guess, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
        
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
