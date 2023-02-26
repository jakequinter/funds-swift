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
    
    private var db = Firestore.firestore()
    
    func deleteAccount(accountId: String?, accountItems: [AccountItem]) {
        // TODO: check if empty string make guard called
        guard let accountId = accountId else {
            print("No account ID")
            return
        }
        
        db.collection("accounts").document(accountId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        for item in accountItems {
            guard let id = item.id else { return }
            
            if item.accountId == accountId {
                db.collection("items").document(id).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
