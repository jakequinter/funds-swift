//
//  Budget.swift
//  Funds
//
//  Created by Jake Quinter on 2/15/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Budget: Codable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    var year: Int
    var month: Int
}
