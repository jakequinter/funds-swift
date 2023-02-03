//
//  FirestoreManager.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class FirestoreManager {
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
}
