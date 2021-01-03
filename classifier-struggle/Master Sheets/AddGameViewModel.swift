//
//  AddGameViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 03.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class AddGameViewModel: ObservableObject, Identifiable {
    
    @Published var name: String = ""
    var nameValid = FieldChecker()
    
    var selectedGameType = Game.GameType.other
    
    var isEdited: Bool {name != ""}
    var isFilled: Bool {nameValid.valid}
    
    func checkUnique(filter: String) -> FetchedResults<Game> {
        return FetchRequest<Game>(
            entity: Game.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter)
        ).wrappedValue
    }
    
    var showActionSheet: Bool = false
    
    func create(in viewContext: NSManagedObjectContext) {
        
        Game.create(name: name,
                     type: selectedGameType.rawValue,
                     date: Date(),
                     in: viewContext)
    }
}
