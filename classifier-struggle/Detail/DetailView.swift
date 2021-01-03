//
//  DetailView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    @State var viewModel: DetailViewModel
    
    @State var addGuessShowSheet = false
    @State var addGuessShowActionSheet = false
    @State var captureShowSheet = false
    
    var body: some View {
        ZStack {
            VStack {
                DetailHeaderView(viewModel: DetailHeaderViewModel(game: viewModel.origin))
                List {
                    ForEach(viewModel.guessArray, id: \.self) { guess in
                        DetailRowView(viewModel: DetailRowViewModel(guess: guess,
                                                                    origin: self.viewModel.origin),
                                      binding: self.$viewModel)
                    }.onDelete { indices in
                        self.viewModel.guessArray.delete(at: indices, from: self.viewContext)
                    }
                }
            }
            .navigationBarTitle(Text("Detail"))
            .navigationBarItems(trailing: addGuessButton)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    cameraButton
                    Spacer()
                    galleryButton
                    Spacer()
                }
            }
            if (self.captureShowSheet) {
                CaptureView(isShown: $captureShowSheet,
                            isModalShown: $addGuessShowSheet,
                            result: $viewModel.result,
                            sourceType: viewModel.camera ? .camera : .photoLibrary)
                    .opacity(0)
            }
            detailSheetNavigator
        }
    }
}

extension DetailView {
    
    var detailSheetNavigator: some View {
        HStack {
            VStack {EmptyView()}
            .sheet(isPresented: self.$addGuessShowSheet) {
                AddGuessView(viewModel: AddGuessViewModel(game: self.viewModel.origin, result: self.viewModel.result),
                               showSheet: self.$addGuessShowSheet,
                               showActionSheet: self.$addGuessShowActionSheet)
                    .presentationBool(isModal: false) {
                        //runs instead of dismiss
                        self.addGuessShowActionSheet = true
                }
                .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

extension DetailView {
    
    var addGuessButton: some View {
        Button(
            action: {
                //Guess.createRandom(origin: self.viewModel.origin, in: self.viewContext)
                self.addGuessShowSheet = true
        }
        ) {
            Image(systemName: "plus")
                .frame(width: 44, height: 44)
        }
    }
    
    var cameraButton: some View {
        Button(action: {
            viewModel.camera = true
            self.captureShowSheet = true
        }) {
            Image(systemName: "camera")
                .frame(width: 44, height: 44)
        }
        .foregroundColor(Color(.white))
        .background(Color("LaunchColor"))
        .cornerRadius(50)
        .padding()
    }
    
    var galleryButton: some View {
        Button(action: {
            viewModel.camera = false
            self.captureShowSheet = true
        }) {
            Image(systemName: "photo.on.rectangle")
                .frame(width: 44, height: 44)
        }
        .foregroundColor(Color(.white))
        .background(Color("LaunchColor"))
        .cornerRadius(50)
        .padding()
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let game: Game = Game()
        let viewModel = DetailViewModel(game: game)
        return DetailView(viewModel: viewModel)
    }
}
