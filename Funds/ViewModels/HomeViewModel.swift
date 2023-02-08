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
   
    private var db = Firestore.firestore()
    
    func fetchYearsForUser() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("years").whereField("userId", isEqualTo: currentUser.uid).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.years = documents.compactMap { queryDocumentSnapshot -> Year? in
                return try? queryDocumentSnapshot.data(as: Year.self)
            }
        }
      
    }
    
    func fetchMonthsForUser() {
        guard let _ = Auth.auth().currentUser else { return }
        
        db.collection("months").whereField("yearId", isEqualTo: "FgJQ9q4RqXjFKIJRw3kQ").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No months")
                return
            }
            
            self.months = documents.compactMap { queryDocumentSnapshot -> Month? in
                return try? queryDocumentSnapshot.data(as: Month.self)
            }
            print("months: \(self.months)")
        }
    }
}
