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
    //    @State private var selectedMonth = "January"
    
    init() {
        displayName = Auth.auth().currentUser?.email ?? ""
    }
    
    var body: some View {
        if !authentication.isAuthenticated {
            LoginView()
        } else {
            NavigationSplitView {
                List(viewModel.months, selection: $viewModel.selectedMonth) {
                    Text($0.month)
                        .tag($0)
                }
                .frame(minWidth: 100)
            } detail: {
                //                AccountsView()
                List(viewModel.accountItems) {
                    Text("\($0.name): \($0.amount, specifier: "%.2f")")
                }
            }
            .navigationTitle("Welcome \(displayName)")
            .toolbar {
                Picker("Options", selection: $viewModel.selectedYear) {
                    ForEach(viewModel.years.sorted().reversed(), id: \.id) {
                        Text(String($0.year))
                            .tag($0)
                    }
                }
                .scaledToFill()
            }
            .onAppear() {
                self.viewModel.fetchYearsForUser()
            }
            .onChange(of: viewModel.selectedYear) { newValue in
                self.viewModel.fetchMonthsForYear()
            }
            .onChange(of: viewModel.selectedMonth) { newValue in
                self.viewModel.fetchAccountForMonth()
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
