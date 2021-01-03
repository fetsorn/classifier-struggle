//
//  AddGuessView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 03.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct AddGuessView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var viewModel: AddGuessViewModel
    
    @Binding var showSheet: Bool
    @Binding var showActionSheet: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo")) {
                    PhotoImage
                }
                Section(header: Text("Guess")) {
                    InferenceList
                }
            }
            .navigationBarTitle(Text("New Guess"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton,
                                trailing: doneButton.disabled(true))
                .actionSheet(isPresented: $showActionSheet) { AddGuessActionSheet }
        }
    }
}

extension AddGuessView {
    
    var cancelButton: some View {
        Button("Cancel", action: { self.showSheet = false })
    }
    
    var doneButton: some View {
        Button("Done", action: {
            self.viewModel.create(in: self.viewContext)
            self.showSheet = false
        })
    }
}

extension AddGuessView {
    
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

extension AddGuessView {
    
    struct CustomImage: UIViewRepresentable {
        // wrap Photo in UIImageView to preserve aspect ratio when scaling
        var customImage: UIImage
        
        func makeUIView(context: Context) -> UIView {
            
            let customView = UIImageView()
            let constraints = [
                customView.widthAnchor.constraint(equalToConstant: 100),
                customView.heightAnchor.constraint(equalToConstant: 100)]
            NSLayoutConstraint.activate(constraints)
            
            customView.image = customImage
            
            return customView
            
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            // Update the view
        }
    }
    
    var PhotoImage: some View {
        Image(uiImage: viewModel.result?.photo ?? UIImage())
            .resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height/2)
    }
    
    var InferenceList: some View {
        List {
            ForEach(viewModel.result?.inferences ?? [], id: \.self) { inference in
                HStack{
                    Text(inference.label)
                    Spacer()
                    Text(String(inference.confidence))
                }
            }
        }
    }
    
}

struct AddGuessView_Previews: PreviewProvider {
    
    @State static var addGuessShowSheet = false
    @State static var addGuessShowActionSheet = false
    
    static var previews: some View {
        AddGuessView(viewModel: AddGuessViewModel(game: Game(), result: nil),
                       showSheet: $addGuessShowSheet,
                       showActionSheet: $addGuessShowActionSheet)
    }
}
