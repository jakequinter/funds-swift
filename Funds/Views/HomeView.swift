//
//  ContentView.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @StateObject var authentication = LoginViewModel()
    @ObservedObject private var viewModel = HomeViewModel()
    
    @State private var displayName: String
    
    init() {
        displayName = Auth.auth().currentUser?.email ?? ""
    }
    
    var body: some View {
        if !authentication.isAuthenticated {
            LoginView()
        } else {
            NavigationView {
                List(viewModel.accounts) { account in
                    Section(account.name) {
                        ForEach(viewModel.accountItems.filter { $0.accountId == account.id }) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("$\(item.amount, specifier: "%.2f")")
                            }
                        }
                    }
                }
                .navigationTitle("\(viewModel.month?.name ?? ""), \(String(viewModel.year?.year ?? 0))")
            }
            
            .onAppear() {
                self.viewModel.fetchData()
            }
            .environmentObject(authentication)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
