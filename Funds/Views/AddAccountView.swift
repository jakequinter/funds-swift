//
//  AddAccountView.swift
//  Funds
//
//  Created by Jake Quinter on 2/14/23.
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = AddAccountViewModel()
    
    let budgetId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $viewModel.account.name)
                    .textFieldStyle(.roundedBorder)
            }
            Button("Add") {
                viewModel.addAccount(budgetId: budgetId)
                dismiss()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Add account")
        .alert(viewModel.errorMessage, isPresented: $viewModel.showingError) {
            Button("OK") { }
        }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView(budgetId: "1")
    }
}
