//
//  LoginView.swift
//  Funds
//
//  Created by Jake Quinter on 2/7/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var loginVM = LoginViewModel()
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $loginVM.email)
                TextField("Passwored", text: $loginVM.password)
                Button("Login") {
                    loginVM.login {
                        isActive = true
                    }
                }
            }
            .navigationDestination(isPresented: $isActive) {
                ContentView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
