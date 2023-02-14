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
    @State private var showingAddAccountSheet = false
    @State private var showingAddItemSheet = false
    
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
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    viewModel.deleteAccountItem(accountItemId: item.id)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("\(viewModel.month?.name ?? ""), \(String(viewModel.year?.year ?? 0))")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Add item") {
                                showingAddItemSheet = true
                            }
                            Button("Add account") {
                                showingAddAccountSheet = true
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            
            .onAppear() {
                self.viewModel.fetchData()
            }
            .sheet(isPresented: $showingAddAccountSheet) {
                AddAccountView(monthId: viewModel.month?.id ?? "")
            }
            .sheet(isPresented: $showingAddItemSheet) {
                AddAccountItemView(monthId: viewModel.month?.id ?? "")
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
