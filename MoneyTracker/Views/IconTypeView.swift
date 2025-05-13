//
//  IconTypeView.swift
//  IncomeTracker
//
//  Created by Tomi Mandala Putra on 12/05/2025.
//

import SwiftUI

struct IconTypeView: View {
    @State var type: TransactionType

    private var typeIcon: String {
        return type == .income ? "arrow.up.forward" : "arrow.down.forward"
    }

    private var colorIcon: Color {
        return type == .income ? Color.green : Color.red
    }

    var body: some View {
        Image(systemName: typeIcon)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(colorIcon)
    }
}

#Preview {
    IconTypeView(type: .income)
}
