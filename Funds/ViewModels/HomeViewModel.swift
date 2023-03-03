//
//  ContentViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/7/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

@MainActor class HomeViewModel: ObservableObject {
    private var database = Firestore.firestore()

    func deleteAccountItem(accountItemId: String?) {
        guard let accountItemId = accountItemId else {
            print("No account item ID")
            return
        }

        database.collection("items").document(accountItemId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
