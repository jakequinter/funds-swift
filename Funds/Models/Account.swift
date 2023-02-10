//
//  Account.swift
//  Funds
//
//  Created by Jake Quinter on 2/10/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Account: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    let monthId: String
    let name: String
}

