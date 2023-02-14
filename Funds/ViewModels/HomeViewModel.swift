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
    @Published var year: Year?
    @Published var month: Month?
    @Published var accounts = [Account]()
    @Published var accountItems = [AccountItem]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("years").whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let years = documents.compactMap { queryDocumentSnapshot -> Year? in
                return try? queryDocumentSnapshot.data(as: Year.self)
            }
            
            
            if (years.count > 0) {
                self.year = years.sorted().first!
                
                if let yearId = self.year?.id {
                    self.fetchMonthsForYear(yearId: yearId)
                }
            }
        }
    }
    
    func fetchMonthsForYear(yearId: String) {
        guard let _ = Auth.auth().currentUser else { return }
        
        db.collection("months").whereField("yearId", isEqualTo: yearId).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No months")
                return
            }
            
            let months = documents.compactMap { queryDocumentSnapshot -> Month? in
                return try? queryDocumentSnapshot.data(as: Month.self)
            }
            
            if (months.count > 0) {
                self.month = months.sorted().first!
                if let monthId = self.month?.id {
                    self.fetchAccountsForMonth(monthId: monthId)
                }
            }
        }
    }
    
    func fetchAccountsForMonth(monthId: String) {
        guard let _ = Auth.auth().currentUser else { return }
        
        db.collection("accounts").whereField("monthId", isEqualTo: monthId).addSnapshotListener { (querySnapshot, error) in
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
