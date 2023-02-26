//
//  BudgetViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/26/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class BudgetViewModel: ObservableObject {
    @Published var budget: Budget?
    @Published var accounts = [Account]()
    @Published var accountItems = [AccountItem]()
    
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
                self.budget = budgets.first!
                self.fetchAccountsForCurrentBudget(budgetId: budgets.first!.id!)
            }
        }
    }
    
    func fetchAccountsForCurrentBudget(budgetId: String) {
        db.collection("accounts").whereField("budgetId", isEqualTo: budgetId).order(by: "name").addSnapshotListener { (querySnapshot, error) in
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
}
