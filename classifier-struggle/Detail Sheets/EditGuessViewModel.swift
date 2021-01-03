//
//  EditGuessViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 05.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class EditGuessViewModel: ObservableObject, Identifiable {

    private var editedGuess: Guess
    private var origin: Game
    
    var date: Date = Date()
    
    func edit(in viewContext: NSManagedObjectContext) {
        editedGuess.edit(date: date,
                           in: viewContext)
    }
    
    init(guess: Guess,
         origin: Game) {
        self.editedGuess = guess
        self.date = guess.wrappedDate
        self.origin = origin
    }
}
