//
//  AccountsView.swift
//  Funds
//
//  Created by Jake Quinter on 2/14/23.
//

import SwiftUI

struct AccountsView: View {
    @ObservedObject private var viewModel = AccountsViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.accounts) {
                Text($0.name)
            }
            .navigationTitle("Accounts")
        }
        .onAppear {
            viewModel.fetchCurrentBudget()
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
