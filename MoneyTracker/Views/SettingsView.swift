//
//  SettingsView.swift
//  MoneyTracker
//
//  Created by Tomi Mandala Putra on 13/05/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("orderDescending") var orderDescending: Bool = false
    @AppStorage("currency") var currency: Currency = .usd
    @State private var filterMinimum: Double = 0.0

    private var toggleLable: String {
        orderDescending ? "Earliest" : "Latest"
    }

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = currency.locale
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Toggle(isOn: $orderDescending, label: {
                        Text("Order (\(toggleLable))")
                    })
                }

                HStack {
                    Picker("Currency", selection: $currency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.title).tag(currency)
                        }
                    }
                }

                HStack {
                    Text("Filter Minimum")
                    TextField("0.0", value: $filterMinimum, formatter: numberFormatter)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
