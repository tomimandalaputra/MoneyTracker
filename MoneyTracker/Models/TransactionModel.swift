//
//  TransactionModel.swift
//  IncomeTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import Foundation
import RealmSwift

class TransactionModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var type: TransactionType
    @Persisted var amount: Double
    @Persisted var date: Date

    convenience init(_id: ObjectId, title: String, type: TransactionType, amount: Double, date: Date) {
        self.init()
        self._id = _id
        self.title = title
        self.type = type
        self.amount = amount
        self.date = date
    }

    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    func displayCurrency(currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
}

protocol TransactionProtocol {
    var displayDate: String { get }
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

    // MARK: - func formatter Currency

    func displayCurrency(currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
}
