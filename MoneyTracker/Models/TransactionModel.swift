//
//  TransactionModel.swift
//  IncomeTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import Foundation

protocol TransactionProtocol {
    var displayDate: String { get }
    var displayAmount: String { get }
}

struct Transaction: TransactionProtocol, Identifiable, Hashable {
    let id = UUID()
    let title: String
    let type: TransactionType
    let amount: Double
    let date: Date
}

extension Transaction {
    // MARK: - Computed formatter date

    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    // MARK: - Computed formatter Currency

    var displayAmount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        numberFormatter.currencySymbol = "$"
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
    }
}
