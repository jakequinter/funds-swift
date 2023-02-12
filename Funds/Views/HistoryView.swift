//
//  HistoryView.swift
//  Funds
//
//  Created by Jake Quinter on 2/12/23.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.years) { year in
                Section(String(year.year)) {
                    ForEach(viewModel.months.filter { $0.yearId == year.id }) {
                        Text($0.name)
                    }
                }
            }
            .navigationTitle("History")
        }
        .onAppear {
            self.viewModel.fetchYears()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
