//
//  LoginView.swift
//  Funds
//
//  Created by Jake Quinter on 2/7/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authentication = LoginViewModel()
    @ObservedObject private var loginVM = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $loginVM.email)
                TextField("Password", text: $loginVM.password)
                Button("Login") {
                    loginVM.login {
                        authentication.isAuthenticated = true
                    }
                }
            }
            .navigationDestination(isPresented: $authentication.isAuthenticated) {
                HomeView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
