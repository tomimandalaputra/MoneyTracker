//
//  Currency.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 13/05/2025.
//

import Foundation

enum Currency: String, CaseIterable {
    case usd, idr

    var title: String {
        switch self {
        case .usd: return "USD"
        case .idr: return "IDR"
        }
    }

    var locale: Locale {
        switch self {
        case .usd: return Locale(identifier: "en_US")
        case .idr: return Locale(identifier: "id_ID")
        }
    }
}
