//
//  AddAccountViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/13/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class AddAccountItemViewModel: ObservableObject {
    @Published var accountItem: AccountItem
    @Published var accounts = [Account]()
    @Published var showingError = false
    @Published var errorMessage = ""

    private var database = Firestore.firestore()

    init() {
        self.accountItem = AccountItem(id: "", accountId: "", name: "", amount: 0)
    }

    func addAccountItem() {
        do {
            _ = try database.collection("items").addDocument(from: self.accountItem)
        } catch {
            print(error)
            errorMessage = "There was a problem adding your account item"
            showingError = true
        }
    }

    func fetchAccounts(budgetId: String) {
        guard Auth.auth().currentUser != nil else { return }

        if budgetId.isEmpty {
            errorMessage = "Cannot find account ID"
            showingError = true
            return
        }

        database.collection("accounts")
            .whereField("budgetId", isEqualTo: budgetId)
            .order(by: "name")
            .addSnapshotListener { (querySnapshot, _) in
            guard let documents = querySnapshot?.documents else {
                print("No accounts in AddAccountViewModel")
                return
            }

            self.accounts = documents.compactMap { queryDocumentSnapshot -> Account? in
                return try? queryDocumentSnapshot.data(as: Account.self)
            }

            self.accountItem = AccountItem(accountId: self.accounts.first?.id ?? "", name: "", amount: 0)
        }
    }
}
