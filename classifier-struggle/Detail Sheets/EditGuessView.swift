//
//  EditGuessView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 05.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct EditGuessView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var viewModel: EditGuessViewModel
    
    @Binding var showSheet: Bool
    @Binding var showActionSheet: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date")) {
                    DatePicker("", selection: $viewModel.date)
                }
            }
            .navigationBarTitle(Text("New Guess"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton,
                                trailing: doneButton.disabled(true))
                .actionSheet(isPresented: $showActionSheet) { AddGuessActionSheet }
        }
    }
}

extension EditGuessView {
    
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

extension EditGuessView {
    
    var AddGuessActionSheet: ActionSheet {
        ActionSheet(title: Text("Note: Name is required"),
                    buttons: saveActionSheet())
    }
    
    func saveActionSheet() -> [Alert.Button] {
        
            return [Alert.Button.destructive(Text("Don't save"),
                                             action: { self.showSheet = false }),
                    Alert.Button.cancel()]
        
    }
    
}

extension EditGuessView {
    
}

struct EditGuessView_Previews: PreviewProvider {
    @State static var editGuessShowSheet = false
    @State static var editGuessShowActionSheet = false
    
    static var previews: some View {
        EditGuessView(viewModel: EditGuessViewModel(guess: Guess(),
                                                        origin: Game()),
                        showSheet: $editGuessShowSheet,
                        showActionSheet: $editGuessShowActionSheet)
    }
}
