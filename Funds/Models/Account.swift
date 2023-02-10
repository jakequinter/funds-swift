//
//  Account.swift
//  Funds
//
//  Created by Jake Quinter on 2/10/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Account: Codable, Equatable, Hashable, Identifiable {
    @DocumentID var id: String?
    let monthId: String
    let name: String
    let items: [AccountItem]?
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
