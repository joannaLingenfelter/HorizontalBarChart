//
//  Strucs.swift
//  HorizontalBarChart
//
//  Created by Chris Stroud on 2/22/23.
//

import Foundation
import SwiftUI
import Charts

struct PaymentSummary {
    let bars: [PaymentBarModel]
    let spacebars: [SpacerBarModel]
    let total: Double

    init(payments: [DisplayedPayment]) {
        self = PaymentSummary.createBars(payments: payments)
    }

    private init(payments: [PaymentBarModel], spacebars: [SpacerBarModel], total: Double) {
        self.bars = payments
        self.spacebars = spacebars
        self.total = total
    }

    private static func createBars(payments: [DisplayedPayment]) -> PaymentSummary {
        let rawTotal = payments.map(\.amount).reduce(0, +)

        let isEmptyState = rawTotal.isZero

        let total = DuplicitousValue(value: rawTotal, displayValue: isEmptyState ? 500.0 : rawTotal)

        let spacing = map(1.0, from: 0...100, to: 0...total.displayValue)
        let minBarWidth = map(2.0, from: 0...100, to: 0...total.displayValue)

        var bars: [PaymentBarModel] = []
        
        var aggregateDisplayTotal = 0.0

        for payment in payments {
            var xStart = 0.0
            aggregateDisplayTotal = max(payment.amount, minBarWidth)
            
            if let last = bars.last {
                xStart = last.range.upperBound + spacing
                aggregateDisplayTotal += (last.total.displayValue + spacing)
            }

            let bar = PaymentBarModel(
                value: payment.type,
                total: .init(value: payment.amount, displayValue: aggregateDisplayTotal),
                range: xStart...aggregateDisplayTotal
            )

            bars.append(bar)
        }

        var spacebars: [SpacerBarModel] = []

        if isEmptyState {

            var xStart = 0.0
            if let last = bars.last {
                xStart = last.range.upperBound + spacing
                aggregateDisplayTotal += (last.total.displayValue + spacing)
            }

            spacebars.append(SpacerBarModel(value: .trailing, total: .init(value: 0.0, displayValue: total.displayValue - aggregateDisplayTotal), range: xStart...total.displayValue))
        }

        return .init(payments: bars, spacebars: spacebars, total: total.value)
    }
}
