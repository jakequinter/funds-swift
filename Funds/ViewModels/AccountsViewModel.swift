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
    @Published var accountItems = [AccountItem]()
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
            
            self.fetchAccountItemsForCurrentBudget()
        }
    }
    
    func fetchAccountItemsForCurrentBudget() {
        let accountIds = self.accounts.map { $0.id }
        
        db.collection("items").whereField("accountId", in: accountIds as [Any]).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No account items")
                return
            }
            
            self.accountItems = documents.compactMap { queryDocumentSnapshot -> AccountItem? in
                return try? queryDocumentSnapshot.data(as: AccountItem.self)
            }
        }
    }
    
    func deleteAccount(accountId: String?) {
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
        
        for item in self.accountItems {
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
