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

    private init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
