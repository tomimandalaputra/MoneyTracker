//
//  AddTransactionView.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import SwiftUI

struct AddTransactionView: View {
    @State private var amount: Double = 0.0
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var transactionTitle: String = ""
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

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
        .alert(alertTitle, isPresented: $showAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        } message: {
            Text(alertMessage)
        }
    }

    private func createTransaction() {
        let transaction = TransactionItem(context: viewContext)
        transaction.id = UUID()
        transaction.title = transactionTitle
        transaction.type = Int16(selectedTransactionType.rawValue)
        transaction.amount = amount
        transaction.date = Date()

        do {
            try viewContext.save()
        } catch {
            alertTitle = "Something went wrong"
            alertMessage = "Unable to create a transaction"
            showAlert = true
            return
        }

        dismiss()
    }
}

#Preview {
    AddTransactionView()
}
