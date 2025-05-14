//
//  TransactionItem+CoreDataProperties.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 14/05/2025.
//
//

import CoreData
import Foundation

public extension TransactionItem {
    @nonobjc class func fetchRequest() -> NSFetchRequest<TransactionItem> {
        return NSFetchRequest<TransactionItem>(entityName: "TransactionItem")
    }

    @NSManaged var id: UUID?
    @NSManaged var title: String?
    @NSManaged var type: Int16
    @NSManaged var amount: Double
    @NSManaged var date: Date?
}

extension TransactionItem: Identifiable {}

extension TransactionItem {
    var wrappedId: UUID {
        return id!
    }

    var wrappedTitle: String {
        return title ?? ""
    }

    var wrappedDate: Date {
        return date ?? Date()
    }

    var wrappedType: TransactionType {
        return TransactionType(rawValue: Int(type)) ?? .expense
    }

    var wrappedAmount: Double {
        return amount
    }

    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: wrappedDate)
    }

    func displayCurrency(currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
}
