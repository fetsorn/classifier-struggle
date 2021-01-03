//
//  AddGuessViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 03.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class AddGuessViewModel: ObservableObject, Identifiable {
    
    private var game: Game
    
    var origin: Game {
        return game
    }
    
    var doSendEmail: Bool = true
    
    func create(in viewContext: NSManagedObjectContext) {
        Guess.create(date: Date(),
                       origin: game,
                       in: viewContext)
    }
    
    var result: Result? = nil
        
    init(game: Game, result: Result?) {
        self.game = game
        self.result = result
    }
    
}
