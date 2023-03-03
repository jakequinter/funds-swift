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
    @StateObject var currentBudget = BudgetViewModel()
    @ObservedObject private var viewModel = HomeViewModel()

    @State private var displayName: String
    @State private var showingAddItemSheet = false

    init() {
        displayName = Auth.auth().currentUser?.email ?? ""
    }

    var monthString: String {
        if currentBudget.budget?.month != nil {
            return Calendar.current.monthSymbols[(currentBudget.budget?.month)! - 1]
        }

        return ""
    }

    var yearString: String {
        String(currentBudget.budget?.year ?? 0)
    }

    var body: some View {
        if !authentication.isAuthenticated {
            LoginView()
        } else {
            NavigationView {
                List(currentBudget.accounts) { account in
                    Section(account.name) {
                        ForEach(currentBudget.accountItems.filter { $0.accountId == account.id }) { item in
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
                        Button {
                            showingAddItemSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .onAppear {
                currentBudget.fetchCurrentBudget()
            }
            .sheet(isPresented: $showingAddItemSheet) {
                AddAccountItemView(budgetId: currentBudget.budget?.id ?? "")
            }
            .environmentObject(authentication)
            .environmentObject(currentBudget)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
