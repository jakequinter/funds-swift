//
//  TabsView.swift
//  Funds
//
//  Created by Jake Quinter on 3/4/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var buget: BudgetViewModel
    @StateObject var authentication = LoginViewModel()
    @State private var selectedTab = "Home"
    
    var body: some View {
        if !authentication.isAuthenticated {
            LoginView()
                .environmentObject(authentication)
        } else {
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

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
