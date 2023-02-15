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
            List(viewModel.years, id: \.self) { year in
                Section(String(year)) {
                    ForEach(viewModel.budgets.filter { $0.year == year }) { budget in
                        Text(String(Calendar.current.monthSymbols[budget.month - 1]))
                    }
                }
            }
            .navigationTitle("History")
        }
        .onAppear {
            self.viewModel.fetchHistory()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
