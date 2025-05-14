//
//  HomeView.swift
//  IncomeTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import CoreData
import SwiftUI

struct HomeView: View {
    @State private var transactionEdit: TransactionItem?
    @State private var showSettingsView: Bool = false

    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<TransactionItem>
    @Environment(\.managedObjectContext) private var viewContext

    @AppStorage("orderDescending") private var orderDescending: Bool = false
    @AppStorage("currency") var currency: Currency = .usd
    @AppStorage("filterMinimum") var filterMinimum: Double = 0.0

    private var displayTransactions: [TransactionItem] {
        let sortedTransactions = orderDescending ? transactions.sorted(by: { $0.wrappedDate < $1.wrappedDate }) : transactions.sorted(by: { $0.wrappedDate > $1.wrappedDate })

        let filteredTransactions = sortedTransactions.filter { $0.amount > filterMinimum }

        return filteredTransactions
    }

    private var expenses: String {
        let sumExpenses = transactions.filter { $0.wrappedType == .expense }.reduce(0) { $0 + $1.amount }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: sumExpenses as NSNumber) ?? "0.00"
    }

    private var income: String {
        let sumIncome = transactions.filter { $0.wrappedType == .income }.reduce(0) { $0 + $1.amount }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: sumIncome as NSNumber) ?? "0.00"
    }

    private var balance: String {
        let sumIncome = transactions.filter { $0.wrappedType == .income }.reduce(0) { $0 + $1.amount }
        let sumExpenses = transactions.filter { $0.wrappedType == .expense }.reduce(0) { $0 + $1.amount }
        let total = sumIncome - sumExpenses

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: total as NSNumber) ?? "0.00"
    }

    fileprivate func FlotingButton() -> some View {
        VStack {
            Spacer()
            NavigationLink {
                AddTransactionView()
            } label: {
                Text("+")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 70)
            }
            .background(.primaryLightGreen)
            .clipShape(Circle())
        }
    }

    fileprivate func BalanceView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.primaryLightGreen)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("BALANCE")
                            .font(.caption)
                            .foregroundStyle(.white)

                        Text(balance)
                            .font(.system(size: 42, weight: .light))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }

                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Expense")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(expenses)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading) {
                        Text("Income")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(income)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.white)
                    }
                }

                Spacer()
            }
            .padding([.top, .horizontal])
        }
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
        .frame(height: 150)
        .padding(.horizontal)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    BalanceView()

                    List {
                        ForEach(displayTransactions) { transaction in
                            Button(action: {
                                transactionEdit = transaction
                            }, label: {
                                TransactionView(transaction: transaction)
                                    .foregroundStyle(.black)
                            })
                        }
                        .onDelete(perform: deleteData)
                    }
                    .scrollContentBackground(.hidden)
                }
                FlotingButton()
            }
            .navigationTitle("Money Tracker")
            .navigationDestination(item: $transactionEdit, destination: { transactionEdit in
                EditTransactionView(
                    transactionEdit: transactionEdit
                )

            })
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
                    .presentationDetents([.height(300), .medium])
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showSettingsView = true
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.black)
                    })
                }
            }
        }
    }

    private func deleteData(at offsets: IndexSet) {
        for index in offsets {
            let transactionToDelete = displayTransactions[index]
            viewContext.delete(transactionToDelete)
        }
    }
}

#Preview {
    let dataManager = DataManager.sharedPreview
    return HomeView().environment(\.managedObjectContext, dataManager.container.viewContext)
}
