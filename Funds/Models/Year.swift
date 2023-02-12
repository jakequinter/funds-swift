//
//  Year.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Year: Codable, Comparable, Hashable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    var year: Int
    
    static func <(lhs: Year, rhs: Year) -> Bool {
        return lhs.year > rhs.year
    }
}
