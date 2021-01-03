//
//  DetailViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation

class DetailViewModel: ObservableObject, Identifiable {
    
    private var game: Game
    
    var guessArray: [Guess] {
        return game.guessArray
    }
    
    var origin: Game {
        return game
    }
    
    var camera = false
    
    var result: Result?
    
    init(game: Game) {
        self.game = game
    }
    
}
