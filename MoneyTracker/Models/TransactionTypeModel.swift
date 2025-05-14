//
//  TransactionTypeModel.swift
//  IncomeTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import Foundation
import RealmSwift

enum TransactionType: String, CaseIterable, Identifiable, PersistableEnum {
    case income, expense

    var id: Self { self }

    var title: String {
        switch self {
        case .expense:
            return "Expense"
        case .income:
            return "Income"
        }
    }
}
