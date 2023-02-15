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
    
    var monthString: String {
        if viewModel.currentBudget?.month != nil {
            return Calendar.current.monthSymbols[(viewModel.currentBudget?.month)! - 1]
        }
        
        return ""
    }
    
    var yearString: String {
        String(viewModel.currentBudget?.year ?? 0)
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
                .navigationTitle("\(monthString), \(yearString)")
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
                viewModel.fetchCurrentBudget()
            }
            .sheet(isPresented: $showingAddAccountSheet) {
                AddAccountView(budgetId: viewModel.currentBudget?.id ?? "")
            }
            .sheet(isPresented: $showingAddItemSheet) {
                AddAccountItemView(budgetId: viewModel.currentBudget?.id ?? "")
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
