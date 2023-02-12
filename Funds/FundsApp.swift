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
    @EnvironmentObject var authentication: LoginViewModel
    @State private var selectedTab = "Home"
    
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag("Home")
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "calendar")
                    }
                    .tag("History")
            }
        }
    }
}
