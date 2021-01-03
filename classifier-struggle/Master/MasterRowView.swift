//
//  GameRow.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct MasterRowView: View {
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    @State var viewModel: MasterRowViewModel
    
    @State var editGameShowSheet = false
    @State var editGameShowActionSheet = false
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Image(viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title)
                }.padding()
                Spacer()
            }
            masterRowSheetNavigator
        }.contextMenu {
            editGameButton
            deleteGameButton
        }
    }
}

extension MasterRowView {
    
    var masterRowSheetNavigator: some View {
        HStack {
            VStack{EmptyView()}
                .sheet(isPresented: self.$editGameShowSheet) {
                    EditGameView(viewModel: EditGameViewModel(game: self.viewModel.editedGame),
                                  showSheet: self.$editGameShowSheet,
                                  showActionSheet: self.$editGameShowActionSheet)
                        .presentationBool(isModal: false) {
                            //runs instead of dismiss
                            self.editGameShowActionSheet = true
                    }
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

extension MasterRowView {
    
    var editGameButton: some View {
        Button(
            action: {
                //self.viewModel.editedGame.editRandom(in: self.viewContext)
                //self.viewModel = MasterRowViewModel(game: self.viewModel.editedGame)
                self.editGameShowSheet = true
        }
        ) {
            HStack {
                Text("Edit")
                Image(systemName: "pencil.and.ellipsis.rectangle")
            }
        }
    }
    
    var deleteGameButton: some View {
        Button(
            action: {
                self.viewModel.editedGame.delete(in: self.viewContext)
        }) {
            HStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
    
}

struct MasterRowView_Previews: PreviewProvider {
    static var previews: some View {
        let game: Game = Game()
        let viewModel = MasterRowViewModel(game: game)
        return MasterRowView(viewModel: viewModel)
    }
}
