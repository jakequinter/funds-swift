//
//  AccountsView.swift
//  Funds
//
//  Created by Jake Quinter on 2/14/23.
//

import SwiftUI

struct AccountsView: View {
    @StateObject var currentBudget = BudgetViewModel()
    @ObservedObject private var viewModel = AccountsViewModel()

    @State private var showingAddAccountSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(currentBudget.accounts) { account in
                    Text(account.name)
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                viewModel.deleteAccount(accountId: account.id, accountItems: currentBudget.accountItems)
                            }
                        }
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddAccountSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddAccountSheet) {
            AddAccountView(budgetId: currentBudget.budget?.id ?? "")
                .presentationDetents([.medium])
                .presentationCornerRadius(36)
        }
        .onAppear {
            currentBudget.fetchCurrentBudget()
        }
        .environmentObject(currentBudget)
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
