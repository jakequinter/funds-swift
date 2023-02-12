//
//  AccountsView.swift
//  Funds
//
//  Created by Jake Quinter on 2/10/23.
//

import SwiftUI

struct AccountsView: View {
    let data = (1...5).map { "Item \($0)" }
    
    var body: some View {
        NavigationStack {
            Text("Community First CU")
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
                .foregroundColor(.primary)
            
            ForEach(data, id: \.self) { item in
                HStack {
                    Text("Checking")
                    Spacer()
                    Text("$5.78")
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 34).fill(.ultraThinMaterial))
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 40).fill(Color.emerald).shadow(radius: 3))
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
