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
    @Published var accounts = [Account]()
    var budgetId: String?
    
    private var db = Firestore.firestore()
    
    func fetchCurrentBudget() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("budgets").whereField("userId", isEqualTo: currentUser.uid).order(by: "year", descending: true).order(by: "month", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let budgets = documents.compactMap { queryDocumentSnapshot -> Budget? in
                return try? queryDocumentSnapshot.data(as: Budget.self)
            }
            
            if (budgets.count > 0) {
                self.budgetId = budgets.first!.id!
                self.fetchAccountsForCurrentBudget()
            }
        }
    }
    
    func fetchAccountsForCurrentBudget() {
        guard let _ = Auth.auth().currentUser else { return }
        
        db.collection("accounts").whereField("budgetId", isEqualTo: self.budgetId as Any).order(by: "name").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No accounts")
                return
            }
            
            self.accounts = documents.compactMap { queryDocumentSnapshot -> Account? in
                return try? queryDocumentSnapshot.data(as: Account.self)
            }
        }
    }
}
