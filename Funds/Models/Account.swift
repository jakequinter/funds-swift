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
    var monthId: String
    var name: String
}
