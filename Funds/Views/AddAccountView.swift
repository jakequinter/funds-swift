//
//  AddAccountView.swift
//  Funds
//
//  Created by Jake Quinter on 2/14/23.
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = AddAccountViewModel()

    let budgetId: String

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $viewModel.account.name)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                    .padding(.bottom)
                
                Button {
                    viewModel.addAccount(budgetId: budgetId)
                    dismiss()
                } label: {
                    Text("Add")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.black.gradient : Color.accentColor.gradient)
                        .foregroundColor(colorScheme == .dark ? .accentColor : .white)
                        .cornerRadius(10)
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add account")
        }
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
