//
//  FundsApp.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import Firebase
import SwiftUI

@main
struct FundsApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
