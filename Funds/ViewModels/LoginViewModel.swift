//
//  LoginViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/7/23.
//

import Firebase
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login(completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
}
