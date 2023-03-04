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
            ZStack {
                Color("Background")
                
                VStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 50).weight(.thin))
                    
                    Text("Log in to Funds")
                        .font(.title.width(.condensed).bold())
                        .padding(.bottom, 24)
                    
                    TextField("Email", text: $loginVM.email)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.2).gradient)
                        .cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.white.opacity((0.5)), .clear, .white.opacity(0.5), .clear],
                                    startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        )
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $loginVM.password)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.2).gradient)
                        .cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.white.opacity((0.5)), .clear, .white.opacity(0.5), .clear],
                                    startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        )
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    Button {
                        loginVM.login {
                            authentication.isAuthenticated = true
                        }
                    } label: {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.black.gradient)
                            .cornerRadius(10)
                    }
                    .padding(.top, 24)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.white.opacity((0.5)), .clear, .white.opacity(0.5), .clear],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, y: 20)
                .frame(maxWidth: 500)
                .padding(10)
                .navigationDestination(isPresented: $authentication.isAuthenticated) {
                    TabsView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
