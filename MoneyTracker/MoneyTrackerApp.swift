//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import SwiftUI

@main
struct MoneyTrackerApp: App {
    let dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
