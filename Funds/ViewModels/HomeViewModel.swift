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
    @Published var currentBudget: Budget?
    @Published var accounts = [Account]()
    @Published var accountItems = [AccountItem]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
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
                self.currentBudget = budgets.first!
                self.fetchAccountsForCurrentBudget(budgetId: budgets.first!.id!)
            }
        }
    }
    
    func fetchAccountsForCurrentBudget(budgetId: String) {
        guard let _ = Auth.auth().currentUser else { return }
        
        db.collection("accounts").whereField("budgetId", isEqualTo: budgetId).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No accounts")
                return
            }
            
            self.accounts = documents.compactMap { queryDocumentSnapshot -> Account? in
                return try? queryDocumentSnapshot.data(as: Account.self)
            }
            
            self.fetchAccountItems()
        }
    }
    
    func fetchAccountItems() {
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
            if item.accountId == accountId {
                db.collection("items").document(item.accountId).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func deleteAccountItem(accountItemId: String?) {
        guard let accountItemId = accountItemId else {
            print("No account item ID")
            return
        }
        
        db.collection("items").document(accountItemId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
