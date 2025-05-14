//
//  EditTransactionView.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    var transactionEdit: TransactionItem?

    @State private var amount: Double = 0.0
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var transactionTitle: String = ""
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false

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
                    Text("Edit")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        updateTransaction()
                    }, label: {
                        Text("Update")
                            .font(.system(size: 16, weight: .semibold))
                    })
                    .disabled(disableCreateButton)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let transactionEdit = transactionEdit {
                amount = transactionEdit.amount
                selectedTransactionType = transactionEdit.wrappedType
                transactionTitle = transactionEdit.wrappedTitle
            }
        }
    }

    private func updateTransaction() {
        if let transactionEdit = transactionEdit {
            transactionEdit.title = transactionTitle
            transactionEdit.amount = amount
            transactionEdit.type = Int16(selectedTransactionType.rawValue)
            transactionEdit.date = transactionEdit.wrappedDate

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
}

#Preview {
    EditTransactionView()
}
