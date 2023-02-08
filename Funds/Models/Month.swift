//
//  Month.swift
//  Funds
//
//  Created by Jake Quinter on 2/8/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Month: Codable, Identifiable {
    @DocumentID var id: String?
    let yearId: String
    let month: String
}
