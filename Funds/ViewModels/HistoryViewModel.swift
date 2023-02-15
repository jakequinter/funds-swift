//
//  HistoryViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/12/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

@MainActor class HistoryViewModel: ObservableObject {
    @Published var budgets = [Budget]()
    @Published var years = [Int]()
    
    private var db = Firestore.firestore()
    
    func fetchHistory() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("budgets").whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No budgets in HistoryViewModel")
                return
            }
            
            self.budgets = documents.compactMap { queryDocumentSnapshot -> Budget? in
                return try? queryDocumentSnapshot.data(as: Budget.self)
            }
            
            self.findUniqueYears()
        }
    }
    
    func findUniqueYears() {
        var hasOccuredYears = [Int]()
        
        for budget in self.budgets {
            if hasOccuredYears.contains(budget.year) {
                continue
            } else {
                self.years.append(budget.year)
                hasOccuredYears.append(budget.year)
            }
        }
    }
}
