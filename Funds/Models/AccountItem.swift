//
//  AccountItem.swift
//  Funds
//
//  Created by Jake Quinter on 2/10/23.
//

import FirebaseFirestoreSwift
import Foundation

struct AccountItem: Codable, Equatable, Identifiable {
    @DocumentID var id: String?
    let accountId: String
    var name: String
    var amount: Double
}
