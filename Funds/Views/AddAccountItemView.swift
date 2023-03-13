//
//  AddAccountView.swift
//  Funds
//
//  Created by Jake Quinter on 2/13/23.
//

import SwiftUI

struct AddAccountItemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = AddAccountItemViewModel()
    
    let budgetId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $viewModel.accountItem.name)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                
                TextField("Name", value: $viewModel.accountItem.amount, format: .number)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                
                Picker("Account", selection: $viewModel.accountItem.accountId) {
                    ForEach(viewModel.accounts) {
                        Text($0.name)
                            .tag($0.id!)
                    }
                    .padding()
                }
                .pickerStyle(.segmented)
                
                Button {
                    viewModel.addAccountItem()
                    dismiss()
                } label: {
                    Text("Add")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.gradient)
                        .cornerRadius(10)
                }
                .padding(.top, 24)
            }
            .padding()
            .navigationTitle("Add account item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                    }
                }
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showingError) {
                Button("OK") { }
            }
            .onAppear {
                viewModel.fetchAccounts(budgetId: budgetId)
            }
        }
    }
}

struct AddAccountItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountItemView(budgetId: "1")
    }
}
