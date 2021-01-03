//
//  ContentViewTab.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            FirstTabView()
                .tabItem {
                    VStack {
                        Image("tabFirst")
                        Text("First")
                    }
                }
                .tag(0)
            SecondTabView()
                .tabItem {
                    VStack {
                        Image("tabSecond")
                        Text("Second")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
