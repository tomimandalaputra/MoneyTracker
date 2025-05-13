//
//  TransactionView.swift
//  IncomeTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import SwiftUI

struct TransactionView: View {
    let transaction: Transaction

    @AppStorage("currency") var currency: Currency = .usd

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(transaction.displayDate)
                    .font(.system(size: 14))
                Spacer()
            }
            .padding(.vertical, 4)
            .background(Color.lightGrayShade.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            HStack {
                IconTypeView(type: transaction.type)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(transaction.title)
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                        Text(String(transaction.displayCurrency(currency: currency)))
                            .font(.system(size: 15, weight: .bold))
                    }

                    Text("Completed")
                        .font(.system(size: 14))
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    TransactionView(transaction: Transaction(title: "Apple", type: .expense, amount: 5.00, date: Date()))
}
