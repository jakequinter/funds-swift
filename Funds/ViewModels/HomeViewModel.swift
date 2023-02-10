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
    @Published var years = [Year]()
    @Published var months = [Month]()
    @Published var accounts = [Account]()
    @Published var selectedYear = Year(id: "1", userId: "1", year: 1)
    @Published var selectedMonth = Month(id: "1", yearId: "1", month: "test")
    
    private var db = Firestore.firestore()
    
    func fetchYearsForUser() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("years").whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let years = documents.compactMap { queryDocumentSnapshot -> Year? in
                return try? queryDocumentSnapshot.data(as: Year.self)
            }
            
            self.years = years
            
            if (years.count > 0) {
                self.selectedYear = years.sorted().reversed().first!
            }
        }
        
    }
    
    func fetchMonthsForYear() {
        guard let _ = Auth.auth().currentUser else { return }
        guard let _ = selectedYear.id else { return }
        
        db.collection("months").whereField("yearId", isEqualTo: self.selectedYear.id!).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No months")
                return
            }
            
            let months = documents.compactMap { queryDocumentSnapshot -> Month? in
                return try? queryDocumentSnapshot.data(as: Month.self)
            }
            
            self.months = months
            
            if (months.count > 0) {
                self.selectedMonth = months.first!
            }
        }
    }
    
    func fetchAccountForMonth() {
        guard let _ = Auth.auth().currentUser else { return }
        guard let _ =  selectedMonth.id else { return }
        
        db.collection("accounts").whereField("monthId", isEqualTo: self.selectedMonth.id!).addSnapshotListener { (querySnapshot, error) in
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
