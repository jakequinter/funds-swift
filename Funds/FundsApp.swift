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
    @EnvironmentObject var buget: BudgetViewModel
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
                
                AccountsView()
                    .tabItem {
                        Label("Accounts", systemImage: "tag")
                    }
                    .tag("Accounts")
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "calendar")
                    }
                    .tag("History")
            }
        }
    }
}
