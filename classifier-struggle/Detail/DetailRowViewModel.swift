//
//  DetailRowViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation

class DetailRowViewModel: ObservableObject, Identifiable {
    
    private var guess: Guess
    var origin: Game

    var date: String {
        return guess.dateString
    }
    
    var editedGuess: Guess {
        return guess
    }

    init(guess: Guess,
         origin: Game) {
        self.guess = guess
        self.origin = origin
    }
    
}
