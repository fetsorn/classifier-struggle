//
//  MasterView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Game.name, ascending: false)],
        animation: .default)
    var games: FetchedResults<Game>
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    @State var addGameShowSheet = false
    @State var addGameShowActionSheet = false
    
    var body: some View {
        VStack {
            List {
                ForEach(games, id: \.self) { game in
                    NavigationLink(
                        destination: DetailView(viewModel: DetailViewModel(game: game))
                    ) {
                        MasterRowView(viewModel: MasterRowViewModel(game: game))
                    }
                }.onDelete { indices in
                    self.games.delete(at: indices, from: self.viewContext)
                }
            }
            masterSheetNavigator
        }
        .navigationBarTitle("My games")
        .navigationBarItems(trailing: addGameButton)
    }
}

extension MasterView {
    
    var addGameButton: some View {
        Button(
            action: {
                self.addGameShowSheet = true
        }
        ) {
            Image(systemName: "plus")
                .frame(width: 44, height: 44)
        }
    }
    
}

extension MasterView {
    
    var masterSheetNavigator: some View {
        HStack {
            VStack {EmptyView()}
            .sheet(isPresented: self.$addGameShowSheet) {
                AddGameView(viewModel: AddGameViewModel(),
                             showSheet: self.$addGameShowSheet,
                             showActionSheet: self.$addGameShowActionSheet)
                    .presentationBool(isModal: false) {
                        //runs instead of dismiss
                        self.addGameShowActionSheet = true
                }
                .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}


struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
