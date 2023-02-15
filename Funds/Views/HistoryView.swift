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
            Text("hi")
        }
        .navigationTitle("History")
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
