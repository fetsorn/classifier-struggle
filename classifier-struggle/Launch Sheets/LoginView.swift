//
//  LoginView.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 05.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    @Binding var showSheet: Bool
    @Binding var showActionSheet: Bool
    
    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                LogoImage
                Spacer()
                footerFactory()
                Spacer()
            }.padding().onTapGesture { self.hideKeyboard() }
            .padding(.bottom, keyboard.currentHeight)
        }
    }
}

extension LoginView {
    
    var LogoImage: some View {
        Image("logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 200)
    }
    
    func footerFactory() -> some View {
        switch viewModel.auth {
        case .welcome:
            return welcomeFooter
        case .login:
            return welcomeFooter
        case .signup:
            return welcomeFooter
        }
    }
    
    
    var welcomeFooter: some View {
        VStack(spacing: 20) {
            Button("Enter without login") { self.showSheet = false }
                .buttonStyle(BlueButtonStyle())
            Button("Login") { self.viewModel.auth = .login }
                .buttonStyle(BlueButtonStyle())
            Button("Signup") { self.viewModel.auth = .signup }
                .buttonStyle(BlueButtonStyle())
        }
    }
}

extension LoginView {
    
    struct BlueButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color("LaunchColor"))
                .cornerRadius(10)
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    
    @State static var loginShowSheet = false
    @State static var loginShowActionSheet = false
    
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(),
                  showSheet: $loginShowSheet,
                  showActionSheet: $loginShowActionSheet)
    }
}
