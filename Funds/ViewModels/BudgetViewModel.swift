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
    var showArchive = false
    var currentMonth: Int
    var currentYear: Int
    
    init() {
        let date = Date()
        let calendar = Calendar.current
        self.currentMonth = calendar.component(.month, from: date)
        self.currentYear = calendar.component(.year, from: date)
    }
    
    var budgetDisplayName: String {
        let month = monthString
        let year =  String(self.budget?.year ?? 0)
        
        return "\(month), \(year)"
    }
    
    var monthString: String {
        if let month = budget?.month {
            return Calendar.current.monthSymbols[month - 1]
        }
        
        return ""
    }
    
    private var database = Firestore.firestore()
    
    func fetchCurrentBudget() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        database.collection("budgets")
            .whereField("userId", isEqualTo: currentUser.uid)
            .order(by: "year", descending: true)
            .order(by: "month", descending: true)
            .addSnapshotListener { (querySnapshot, _) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                let budgets = documents.compactMap { queryDocumentSnapshot -> Budget? in
                    return try? queryDocumentSnapshot.data(as: Budget.self)
                }
                
                if budgets.count > 0 {
                    self.budget = budgets.first
                    self.fetchAccountsForCurrentBudget(budgetId: budgets.first!.id!)
                    
                    if let budget = self.budget {
                        if budget.year < self.currentYear || budget.month < self.currentMonth {
                            self.showArchive = true
                        }
                    }
                }
            }
    }
    
    func fetchAccountsForCurrentBudget(budgetId: String) {
        database.collection("accounts")
            .whereField("budgetId", isEqualTo: budgetId)
            .order(by: "name")
            .addSnapshotListener { (querySnapshot, _) in
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
        
        if accountIds.isEmpty {
            return
        }
        
        database.collection("items")
            .whereField("accountId", in: accountIds as [Any])
            .addSnapshotListener { (querySnapshot, _) in
                guard let documents = querySnapshot?.documents else {
                    print("No account items")
                    return
                }
                
                self.accountItems = documents.compactMap { queryDocumentSnapshot -> AccountItem? in
                    return try? queryDocumentSnapshot.data(as: AccountItem.self)
                }
            }
    }
    
    func archiveBudget() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userId = currentUser.uid
        
        let budget = Budget(userId: userId, year: self.currentYear, month: self.currentMonth)
        do {
            _ = try database.collection("budgets").addDocument(from: budget)
            self.showArchive = false
        } catch {
            print(error)
        }
    }
}
