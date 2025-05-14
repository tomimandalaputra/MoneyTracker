//
//  DataManager.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 14/05/2025.
//

import CoreData
import Foundation

class DataManager {
    let container = NSPersistentContainer(name: "IncomeData")
    static let shared = DataManager()
    static var sharedPreview: DataManager = {
        let manager = DataManager(inMemory: true)
        let transaction = TransactionItem(context: manager.container.viewContext)

        transaction.id = UUID()
        transaction.title = "iCloud"
        transaction.amount = 5
        transaction.type = Int16(TransactionType.expense.rawValue)
        transaction.date = Date()

        return manager
    }()

    private init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
