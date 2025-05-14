//
//  EditTransactionView.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import RealmSwift
import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss

    @State private var amount: Double = 0.0
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var transactionTitle: String = ""
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false

    @AppStorage("currency") var currency: Currency = .usd

    @ObservedRealmObject var transactionEdit: TransactionModel

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
            amount = transactionEdit.amount
            transactionTitle = transactionEdit.title
            selectedTransactionType = transactionEdit.type
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        } message: {
            Text(alertMessage)
        }
    }

    private func updateTransaction() {
        guard let realm = transactionEdit.realm?.thaw() else {
            alertTitle = "Oooopsss"
            alertMessage = "Transaction could not be edited rigth now"
            showAlert = true
            return
        }

        do {
            try realm.write {
                transactionEdit.thaw()?.title = transactionTitle
                transactionEdit.thaw()?.type = selectedTransactionType
                transactionEdit.thaw()?.amount = amount
            }
        } catch {}
        dismiss()
    }
}

// #Preview {
//    EditTransactionView(transactions: .constant([]))
// }
