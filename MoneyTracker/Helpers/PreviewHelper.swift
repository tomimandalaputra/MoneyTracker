//
//  PreviewHelper.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 14/05/2025.
//

import Foundation
import SwiftData

@MainActor
class PreviewHelper {
    static let previewContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: TransactionModel.self, configurations: config)
            let transaction = TransactionModel(id: UUID(), title: "iCloud", type: .expense, amount: 5, date: Date())
            container.mainContext.insert(transaction)
            return container
        } catch {
            fatalError("Failed to create model container")
        }
    }()
}
