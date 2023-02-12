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
    @Published var years =  [Year]()
    @Published var months = [Month]()
    
    private var db = Firestore.firestore()
    
    func fetchYears() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("years").whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No year in HistoryViewModel")
                return
            }
            
            let years = documents.compactMap { queryDocumentSnapshot -> Year? in
                return try? queryDocumentSnapshot.data(as: Year.self)
            }
            
            self.years = years.sorted()
            self.fetchMonths()
        }
    }
    
    func fetchMonths() {
        guard let _ = Auth.auth().currentUser else { return }
        let yearIds = self.years.map { $0.id }
        
        db.collection("months").whereField("yearId", in: yearIds as [Any]).order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No months is HistoryViewModel")
                return
            }
            
            self.months = documents.compactMap { queryDocumentSnapshot -> Month? in
                return try? queryDocumentSnapshot.data(as: Month.self)
            }
        }
    }
}
