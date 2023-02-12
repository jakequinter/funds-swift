//
//  AccountsView.swift
//  Funds
//
//  Created by Jake Quinter on 2/10/23.
//

import SwiftUI

struct AccountsView: View {
    let accounts: [Account]
    let accountItems: [AccountItem]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(accounts) { account in
                    VStack {
                        Text(account.name)
                            .multilineTextAlignment(.center)
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        
                        ForEach(accountItems.filter { $0.accountId == account.id }) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("$\(item.amount, specifier: "%.2f")")
                            }
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 34).fill(.ultraThinMaterial))
                        }
                    }
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color.emerald).shadow(radius: 3))
                }
            }
            Spacer()
        }
        .padding()
    }
}

//struct AccountsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountsView()
//    }
//}
