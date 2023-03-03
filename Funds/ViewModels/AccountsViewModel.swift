//
//  AccountsViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/15/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class AccountsViewModel: ObservableObject {
    var budgetId: String?

    private var database = Firestore.firestore()

    func deleteAccount(accountId: String?, accountItems: [AccountItem]) {
        guard let accountId = accountId else {
            print("No account ID")
            return
        }

        database.collection("accounts").document(accountId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        for item in accountItems {
            guard let id = item.id else { return }

            if item.accountId == accountId {
                database.collection("items").document(id).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
