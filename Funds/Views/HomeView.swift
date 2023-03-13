//
//  ContentView.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @StateObject var currentBudget = BudgetViewModel()
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var showingAddItemSheet = false
    
    var body: some View {
        NavigationStack {
            List(currentBudget.accounts) { account in
                Section(header: AccountSectionHeader(
                    accountName: account.name,
                    total: sumAccountItems(accountId: account.id ?? "")
                )) {
                    ForEach(currentBudget.accountItems.filter { $0.accountId == account.id }) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            HStack {
                                if let additionalAmount = item.additionalAmount {
                                    Text("(\(additionalAmount))")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Text("$\(item.amount, specifier: "%.2f")")
                            }
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                viewModel.deleteAccountItem(accountItemId: item.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle(currentBudget.budgetDisplayName)
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
                .presentationDetents([.medium])
        }
        .environmentObject(currentBudget)
    }
    
    func sumAccountItems(accountId: String) -> String {
        let total = currentBudget.accountItems.filter { $0.accountId == accountId}.map { $0.amount }.reduce(0, +)
        
        return NumberFormatter.localizedString(from: total as NSNumber, number: .currency)
    }
}

struct AccountSectionHeader: View {
    let accountName: String
    let total: String
    
    var body: some View {
        HStack {
            Text(accountName)
            Spacer()
            Text(total)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.accentColor)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
