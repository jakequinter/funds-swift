//
//  Month.swift
//  Funds
//
//  Created by Jake Quinter on 2/8/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Month: Codable, Comparable, Hashable, Identifiable {
    @DocumentID var id: String?
    let yearId: String
    let name: String
    let month: Int
    
    static func <(lhs: Month, rhs: Month) -> Bool {
        return lhs.month > rhs.month
    }
}
