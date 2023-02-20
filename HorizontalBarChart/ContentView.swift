//
//  ContentView.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/16/23.
//

import SwiftUI
import Charts

enum PaymentType: String {
    case plan
    case cardSpend

    var appearance: BarMarkAppearance {
        switch self {
        case .plan:
            return BarMarkAppearance(color: .yellow, symbol: .circle)
        case .cardSpend:
            return BarMarkAppearance(color: .blue, symbol: .square)
        }
    }
}

struct BarMarkAppearance {
    let color: Color
    let symbol: BasicChartSymbolShape
}

struct DuplicitousValue {
    let value: Double
    let displayValue: Double
}

struct BarInfo: Identifiable {
    let id: String
    let total: DuplicitousValue
    let appearance: BarMarkAppearance
    let range: ClosedRange<Double>
}

struct PaymentSummary {
    let bars: [BarInfo]
    let total: Double

    init(payments: [PaymentType: Double]) {
        self = PaymentSummary.createBars(payments: payments)
    }

    private init(payments: [BarInfo], total: Double) {
        self.bars = payments
        self.total = total
    }

    private static func createBars(payments: [PaymentType: Double]) -> PaymentSummary {
        let total = payments.values.reduce(0, +)
        let spacing = map(1.0, from: 0...100, to: 0...total)
        let minBarWidth = map(2.0, from: 0...100, to: 0...total)

        var bars: [BarInfo] = []

        for (payment, total) in payments {
            var xStart = 0.0
            var aggregateTotal = max(total, minBarWidth)

            if let last = bars.last {
                xStart = last.range.upperBound + spacing
                aggregateTotal += (last.total.displayValue + spacing)
            }

            let bar = BarInfo(
                id: payment.rawValue,
                total: .init(value: total, displayValue: aggregateTotal),
                appearance: payment.appearance,
                range: xStart...aggregateTotal
            )

            bars.append(bar)
        }

        return .init(payments: bars, total: total)
    }
}

func map(_ value: Double, from input: ClosedRange<Double>, to output: ClosedRange<Double>) -> Double {
    return (value - input.lowerBound) * (output.upperBound - output.lowerBound) / (input.upperBound - input.lowerBound) + output.lowerBound
}

struct ContentView: View {
    @State var cardSpendTotal: Double = 0.0
    @State var planTotal: Double = 0.0

    var summary: PaymentSummary {
        PaymentSummary(payments: [.cardSpend: cardSpendTotal, .plan: planTotal])
    }

    var body: some View {
        VStack(spacing: 50) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    chartHeader()
                    Spacer()
                    detailsButton()
                }
                chart()
                    .frame(height: 50)
            }

            VStack(spacing: 15) {
                VStack(alignment: .leading) {
                    Text("Card Spend")
                    Slider(value: $cardSpendTotal.animation(), in: 0...1000)
                }

                VStack(alignment: .leading) {
                    Text("Plan")
                    Slider(value: $planTotal.animation(), in: 0...1000)
                }
            }
        }
        .padding()
        .scenePadding()
    }

    func detailsButton() -> some View {
        Button("Details") {

        }
    }

    func chartHeader() -> some View {
        VStack(alignment: .leading) {
            Text(summary.total, format: .currency(code: "USD"))
                .fontWeight(.bold)
            Text("Due Feb 1st")
        }
    }

    func chart() -> some View {
        Chart {
            ForEach(summary.bars) { bar in
                BarMark(xStart: .value(bar.id, bar.range.lowerBound), xEnd: .value(bar.id, bar.range.upperBound))
                    .foregroundStyle(bar.appearance.color)
                    .symbol(.circle)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
