//
//  ContentView.swift
//  Funds
//
//  Created by Jake Quinter on 2/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMonth = "February"
    @State private var selectedYear = "2023"
    // TODO: replace hardcodes years with results from fetching firebase
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let years = ["2018", "2019", "2020", "2021", "2022", "2023"].reversed()
    
    var body: some View {
        NavigationSplitView {
            List(months, id: \.self, selection: $selectedMonth) {
                Text($0)
            }
            .frame(minWidth: 100)
        } detail: {
            Text("show list of monthly expenses for \(selectedMonth) \(selectedYear)")
        }
        .toolbar {
            Picker("Options", selection: $selectedYear) {
                ForEach(years, id: \.self) {
                    Text($0)
                }
            }
            .scaledToFill()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
