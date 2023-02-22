//
//  Strucs.swift
//  HorizontalBarChart
//
//  Created by Chris Stroud on 2/22/23.
//

import Foundation
import SwiftUI
import Charts

struct BarMarkAppearance {
    let color: Color
    let symbol: BasicChartSymbolShape
}

struct DuplicitousValue {
    let value: Double
    let displayValue: Double
}

struct BarInfo: Identifiable {
    let paymentType: PaymentType
    let total: DuplicitousValue
    let range: ClosedRange<Double>

    var id: String {
        paymentType.rawValue
    }
}

struct Payment {
    let type: PaymentType
    let amount: Double
}

struct PaymentSummary {
    let bars: [BarInfo]
    let total: Double

    init(payments: [Payment]) {
        self = PaymentSummary.createBars(payments: payments)
    }

    private init(payments: [BarInfo], total: Double) {
        self.bars = payments
        self.total = total
    }

    private static func createBars(payments: [Payment]) -> PaymentSummary {
        let total = payments.map(\.amount).reduce(0, +)
        print("TOTAL: \(total)")
        let spacing = map(1.0, from: 0...100, to: 0...total) // need this to be a max of a minimum and the total
        let minBarWidth = map(2.0, from: 0...100, to: 0...total)

        var bars: [BarInfo] = []

        for payment in payments {
            var xStart = 0.0
            var aggregateTotal = max(payment.amount, minBarWidth)

            if let last = bars.last {
                xStart = last.range.upperBound + spacing
                aggregateTotal += (last.total.displayValue + spacing)
            }

            let bar = BarInfo(
                paymentType: payment.type,
                total: .init(value: payment.amount, displayValue: aggregateTotal),
                range: xStart...aggregateTotal
            )

            bars.append(bar)

            print("\(bar.id) xStart: \(xStart)")
            print("\(bar.id) aggregateTotal: \(aggregateTotal)")
            print("\(bar.id) lowerBound: \(bar.range.lowerBound)")
            print("\(bar.id) upperBound: \(bar.range.upperBound)")
            print("\(bar.id) paymentAmount: \(bar.total)")
        }

        return .init(payments: bars, total: total)
    }
}
