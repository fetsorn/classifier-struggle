//
//  DetailRowView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct DetailRowView: View {
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    @State var viewModel: DetailRowViewModel
    @Binding var binding: DetailViewModel
    
    @State var editGuessShowSheet = false
    @State var editGuessShowActionSheet = false
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.date)
                        .font(.subheadline)
                }
                Spacer()
            }
            detailRowSheetNavigator
        }.contextMenu {
            editGuessButton
            shareGuessButton
            deleteGuessButton
        }
    }
}

extension DetailRowView {
    
    // update binding with parent view on dismiss to render changes
    var detailRowSheetNavigator: some View {
        HStack {
            VStack {EmptyView()}
                .sheet(isPresented: self.$editGuessShowSheet,
                       onDismiss: { self.binding = DetailViewModel(game: self.binding.origin) }) {
                    EditGuessView(viewModel: EditGuessViewModel(guess: self.viewModel.editedGuess,
                                                                    origin: self.viewModel.origin),
                                    showSheet: self.$editGuessShowSheet,
                                    showActionSheet: self.$editGuessShowActionSheet)
                        .presentationBool(isModal: false) {
                            //runs instead of dismiss
                            self.editGuessShowActionSheet = true
                    }
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

extension DetailRowView {
    
    var editGuessButton: some View {
        Button(
            action: {
                //self.viewModel.editedGuess.editRandom(in: self.viewContext)
                //self.binding = DetailViewModel(game: self.binding.origin)
                self.editGuessShowSheet = true
        }
        ) {
            HStack {
                Text("Edit")
                Image(systemName: "pencil.and.ellipsis.rectangle")
            }
        }
    }
    
    var shareGuessButton: some View {
        Button(
            action: {
                //TODO
        }
        ) {
            HStack {
                Text("Share")
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
    
    var deleteGuessButton: some View {
        Button(
            action: {
                self.viewModel.editedGuess.delete(in: self.viewContext)
        }
        ) {
            HStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
    
}

struct DetailRowView_Previews: PreviewProvider {
    
    @State static var binding: DetailViewModel = DetailViewModel(game: Game())
    
    static var previews: some View {
        DetailRowView(viewModel: DetailRowViewModel(guess: Guess(),
                                                    origin: Game()),
                      binding: $binding)
    }
}
