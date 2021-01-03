//
//  LoginViewModel.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 05.09.2020.
//  Copyright © 2020 Anton Davydov. All rights reserved.
//

import Foundation

class LoginViewModel: ObservableObject, Identifiable {
    
    enum Auth {
        case welcome
        case login
        case signup
    }
    var auth: Auth = .welcome
    
}
