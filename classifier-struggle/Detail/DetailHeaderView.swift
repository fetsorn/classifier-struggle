//
//  DetailHeaderView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct DetailHeaderView: View {
    
    @State var viewModel: DetailHeaderViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title)
                    Divider()
                }
                Spacer()
            }
            HStack {
                Text("My score: \(viewModel.score)")
                Spacer()
            }
        }.padding().background(Color(.secondarySystemBackground))
    }
}

struct DetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeaderView(viewModel: DetailHeaderViewModel(game: Game()))
    }
}
