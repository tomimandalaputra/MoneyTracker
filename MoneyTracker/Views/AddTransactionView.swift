//
//  AddTransactionView.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import SwiftData
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var amount: Double = 0.0
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var transactionTitle: String = ""

    @AppStorage("currency") var currency: Currency = .usd

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = currency.locale
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var disableCreateButton: Bool {
        return !amount.isZero && transactionTitle.count >= 5 ? false : true
    }

    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("Amount")
                    Spacer()
                    TextField("0.00", value: $amount, formatter: numberFormatter)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }

                HStack {
                    Picker("Type", selection: $selectedTransactionType) {
                        ForEach(TransactionType.allCases) { transactionType in
                            Text(transactionType.title)
                                .tag(transactionType)
                        }
                    }
                }

                HStack {
                    Text("Title")
                    Spacer()
                    TextField("Ex: apple purchase", text: $transactionTitle)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12, weight: .semibold))

                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    })
                }

                ToolbarItem(placement: .principal) {
                    Text("Transaction")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        createTransaction()
                    }, label: {
                        Text("Create")
                            .font(.system(size: 16, weight: .semibold))
                    })
                    .disabled(disableCreateButton)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func createTransaction() {
        let transaction = TransactionModel(id: UUID(), title: transactionTitle, type: selectedTransactionType, amount: amount, date: Date())

        modelContext.insert(transaction)

        dismiss()
    }
}

// #Preview {
//    AddTransactionView(transactions: .constant([]))
// }
