//
//  EditGameViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 03.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class EditGameViewModel: ObservableObject, Identifiable {
    
    private var editedGame: Game
    
    @Published var name: String = ""
    var nameValid = FieldChecker()
    var selectedGameType = Game.GameType.other
    
    var isEdited: Bool {name != ""}
    var isValid: Bool {nameValid.valid}
    var isChanged: Bool {name != editedGame.wrappedName }
    
    var oldName: String { editedGame.wrappedName }
    
    func edit(in viewContext: NSManagedObjectContext) {
        editedGame.edit(name: name,
                         type: selectedGameType.rawValue,
                         in: viewContext)
    }
    
    init(game: Game) {
        self.editedGame = game
        self.name = game.wrappedName
        self.selectedGameType = game.wrappedType
    }
    
}
