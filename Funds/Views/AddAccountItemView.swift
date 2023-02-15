//
//  AddAccountView.swift
//  Funds
//
//  Created by Jake Quinter on 2/13/23.
//

import SwiftUI

struct AddAccountItemView: View {
    @ObservedObject private var viewModel = AddAccountItemViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $viewModel.accountItem.name)
                    .textFieldStyle(.roundedBorder)
                TextField("Name", value: $viewModel.accountItem.amount, format: .number)
                    .textFieldStyle(.roundedBorder)
                Picker("Account", selection: $viewModel.accountItem.accountId) {
                    ForEach(viewModel.accounts) {
                        Text($0.name)
                            .tag($0.id!)
                    }
                }
                Button("Add") {
                    viewModel.addAccountItem()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Add account item")
            .alert(viewModel.errorMessage, isPresented: $viewModel.showingError) {
                Button("OK") { }
            }
        }
    }
}

struct AddAccountItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountItemView()
    }
}
