//
//  EditGameView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 03.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct EditGameView: View {
    
    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Game.name, ascending: false)])
    var games: FetchedResults<Game>
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    @ObservedObject var viewModel: EditGameViewModel
    
    @Binding var showSheet: Bool
    @Binding var showActionSheet: Bool
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name (required):")) {
                    NameField
                }.onTapGesture(perform: {self.hideKeyboard()})
                Section(header: Text("Type")) {
                    ImagePicker
                    TextPicker
                }
            }
            .navigationBarTitle(Text("New Game"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton,
                                trailing: doneButton.disabled(!self.viewModel.nameValid.valid))
        }
        .actionSheet(isPresented: $showActionSheet) { AddGameActionSheet }
        .padding(.bottom, keyboard.currentHeight)
    }
}

extension EditGameView {
    
    var cancelButton: some View {
        Button("Cancel", action: { self.showSheet = false })
    }
    
    var doneButton: some View {
        Button("Done", action: {
            self.viewModel.edit(in: self.viewContext)
            self.showSheet = false
        })
    }
}

extension EditGameView {
    
    var AddGameActionSheet: ActionSheet {
        ActionSheet(title: Text("Note: Name is required"),
                    buttons: saveActionSheet())
    }
    
    func saveActionSheet() -> [Alert.Button] {
        if viewModel.isValid && viewModel.isChanged {
            return [Alert.Button.destructive(Text("Don't save"),
                                             action: { self.showSheet = false }),
                    Alert.Button.default(Text("Save"),
                                         action: { self.viewModel.edit(in: self.viewContext)
                                            self.showSheet = false }),
                    Alert.Button.cancel()]
        } else {
            return [Alert.Button.destructive(Text("Don't save"),
                                             action: { self.showSheet = false }),
                    Alert.Button.cancel()]
        }
    }
    
}

extension EditGameView {
    
    var NameField: some View {
        TextFieldWithValidator( title: "Enter name",
                                value: $viewModel.name,
                                checker: $viewModel.nameValid) { value in
                                    // validation closure where ‘v’ is the current value
                                    
                                    //validate if nothing changed to avoid checking for uniqueness
                                    if( self.viewModel.oldName == value ) {
                                        return nil
                                    }
                                    
                                    if( value.isEmpty ) {
                                        return "name cannot be empty"
                                    }
                                    
                                    if( self.games.contains { game in
                                        game.name == value
                                    }) {
                                        return "name must be unique"
                                    }
                                    
                                    return nil
        }
        .autocapitalization(.none)
        .padding( viewModel.nameValid.padding )
        .overlay( ValidatorMessageInline( message: viewModel.nameValid.errorMessageOrNilAtBeginning ),alignment: .bottom)
    }
    
    func imageSegment(type: String) -> some View {
        
        return Image(type)
            .resizable()
            .scaledToFit()
            .frame(width: 60)
            .onTapGesture {
                self.viewModel.selectedGameType = Game.GameType(rawValue: type) ?? .other
        }
        
    }
    
    var ImagePicker: some View {
        
        HStack{
            Spacer()
            imageSegment(type: "other")
            imageSegment(type: "other")
            imageSegment(type: "other")
            imageSegment(type: "other")
            imageSegment(type: "other")
            Spacer()
        }
    }
    
    var TextPicker: some View {
        Picker(selection: $viewModel.selectedGameType, label: Text("")) {
            ForEach(Game.GameType.allCases) { type in
                Text(NSLocalizedString(type.name, comment: "")).tag(type)
                    .foregroundColor(.red)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }

}

struct EditGameView_Previews: PreviewProvider {
    
    @State static var addGameShowSheet = false
    @State static var addGameShowActionSheet = false
    
    static var previews: some View {
        AddGameView(viewModel: AddGameViewModel(),
                     showSheet: $addGameShowSheet,
                     showActionSheet: $addGameShowActionSheet)
    }
}
