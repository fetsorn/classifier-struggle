//
//  GameRowViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation

class MasterRowViewModel: ObservableObject, Identifiable {
    
    private let game: Game
    
    var image: String {
        return game.imageName
    }
    
    var name: String {
        return game.wrappedName
    }
    
    var editedGame: Game {
        return game
    }
    
    init(game: Game) {
        self.game = game
    }
    
}
