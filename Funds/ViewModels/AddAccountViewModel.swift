//
//  AddAccountViewModel.swift
//  Funds
//
//  Created by Jake Quinter on 2/14/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class AddAccountViewModel: ObservableObject {
    @Published var account: Account
    @Published var showingError = false
    @Published var errorMessage = ""
    
    private var db = Firestore.firestore()
    
    init() {
        self.account = Account(id: "", name: "")
    }
    
    func addAccount() {
        do {
            let _ = try db.collection("accounts").addDocument(from: self.account)
        }
        catch {
            print(error)
            errorMessage = "There was a problem adding your account"
            showingError = true
        }
    }
}
