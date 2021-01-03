//
//  Game.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import CoreData

extension Game {
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedType: GameType {
        GameType(rawValue: type ?? "other") ?? .other
    }
    
    public var guessArray: [Guess] {
        let set = guess as? Set<Guess> ?? []
        return set.sorted {
            $0.wrappedDate > $1.wrappedDate
        }
    }
    
    public var imageName: String {
        switch wrappedType.rawValue {
        case "other1":
            return "other1"
        case "other2":
            return "other2"
        case "other3":
            return "other3"
        case "other4":
            return "other4"
        case "other":
            return "other"
        default:
            return "other"
        }
    }
    
    public enum GameType: String, CaseIterable, Hashable, Identifiable {
        case other2
        case other1
        case other4
        case other3
        case other
        
        var name: String {
            return "\(self)".map {
                $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
        }
        
        public var id: GameType {self}
    }
}

extension Game {
    static func createRandom(in managedObjectContext: NSManagedObjectContext){
        let newGame = self.init(context: managedObjectContext)
        
        // generate random name
        let length = 5
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name = String((0..<length).map{ _ in letters.randomElement()! })
        
        newGame.name = name
        newGame.type = "other2"
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    static func create(name: String,
                       type: String,
                       date: Date,
                       in managedObjectContext: NSManagedObjectContext){
        let newGame = self.init(context: managedObjectContext)
        
        newGame.name = name
        newGame.type = type
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    func editRandom(in managedObjectContext: NSManagedObjectContext){
        
        // generate random name
        let length = 5
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name = String((0..<length).map{ _ in letters.randomElement()! })
        
        self.name = name
        self.type = "other1"
        
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    func edit(name: String,
              type: String,
              in managedObjectContext: NSManagedObjectContext) {
        
        self.name = name
        self.type = type
        
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

extension Collection where Element == Game, Index == Int {
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
