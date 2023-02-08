//
//  ContentView.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @StateObject var authentication = LoginViewModel()
    @ObservedObject private var viewModel = HomeViewModel()
    
    @State private var displayName: String
    @State private var selectedYear = 2023
    @State private var selectedMonth = "January"
    
    init() {
        displayName = Auth.auth().currentUser?.email ?? ""
    }
    
    var body: some View {
        if !authentication.isAuthenticated {
            LoginView()
        } else {
            NavigationSplitView {
                List(viewModel.months, selection: $selectedMonth) {
                    Text($0.month)
                        .tag($0.month)
                }
                .frame(minWidth: 100)
            } detail: {
                Text("show list of monthly expenses for selected month/year")
            }
            .navigationTitle("Welcome \(displayName)")
            .toolbar {
                Picker("Options", selection: $selectedYear) {
                    ForEach(viewModel.years.sorted().reversed(), id: \.id) {
                        Text(String($0.year))
                            .tag($0.year)
                    }
                }
                .scaledToFill()
            }
            .onAppear() {
                print("calling getYears")
                self.viewModel.fetchYearsForUser()
                self.viewModel.fetchMonthsForUser()
                print("years \(viewModel.years)")
            }
            .onChange(of: authentication.isAuthenticated) { newValue in
                print("new value is: \(newValue)")
            }
            .environmentObject(authentication)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
