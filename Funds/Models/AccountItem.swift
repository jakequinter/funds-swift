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
    var name = ""
    var amount = 0.0
    
    static func ==(lhs: AccountItem, rhs: AccountItem) -> Bool {
        return lhs.name == rhs.name && lhs.amount == rhs.amount
    }
}
