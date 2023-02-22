//
//  ContentView.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/16/23.
//

import SwiftUI
import Charts

enum PaymentType: String, Plottable {
    case plan
    case cardSpend

    var name: String {
        switch self {
        case .plan:
            return "Plan payment"
        case .cardSpend:
            return "Card spend"
        }
    }
    
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

    func foregroundStyleScale() -> KeyValuePairs<PaymentType, any ShapeStyle>  {
        var dictionary = bars.reduce(into: [:]) { partialResult, bar in
            partialResult[bar.paymentType] = bar.paymentType.appearance.symbol
        }

        return KeyValuePairs(dictionaryLiteral: dictionary)
    }

    func symbolScale() -> KeyValuePairs<Plotta, BasicChartSymbolShape> {
        var dictionary: [PaymentType: BasicChartSymbolShape] = bars.reduce(into: [:]) { partialResult, bar in
            partialResult[bar.paymentType] = bar.paymentType.appearance.symbol
        }

        var thing = bars.reduce(into: [(String, BasicChartSymbolShape)]()) { partialResult, bar in
            partialResult.append((bar.paymentType, bar.paymentType.appearance.symbol))
        }

        return KeyValuePairs(dictionaryLiteral: thing)
    }
}

func map(_ value: Double, from input: ClosedRange<Double>, to output: ClosedRange<Double>) -> Double {
    return (value - input.lowerBound) * (output.upperBound - output.lowerBound) / (input.upperBound - input.lowerBound) + output.lowerBound
}

struct ContentView: View {
    @State var cardSpendTotal: Double = 0.0
    @State var planTotal: Double = 0.0

    var summary: PaymentSummary {
        PaymentSummary(
            payments: [
            .init(type: .plan, amount: planTotal),
            .init(type: .cardSpend, amount: cardSpendTotal)
            ]
        )
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
                    Text("Plan: \(planTotal.formatted(.currency(code: "USD")))")
                    Slider(value: $planTotal.animation(), in: 0...1000)
                        .tint(.yellow)
                }

                VStack(alignment: .leading) {
                    Text("Card Spend: \(cardSpendTotal.formatted(.currency(code: "USD")))")
                    Slider(value: $cardSpendTotal.animation(), in: 0...1000)
                        .tint(.blue)
                }
            }
        }
        .padding()
        .scenePadding()
    }

    func detailsButton() -> some View {
        Button("Details") {}
    }

    func chartHeader() -> some View {
        VStack(alignment: .leading) {
            Text(summary.total, format: .currency(code: "USD"))
                .fontWeight(.bold)
            Text(Date.now, format: .dateTime.day(.defaultDigits).month())
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Total amount owed on") + Text(Date.now, format: .dateTime.day(.defaultDigits).month()))
        .accessibilityValue(Text(summary.total, format: .currency(code: "USD")))
    }

    func chart() -> some View {
        Chart {
            ForEach(summary.bars) { bar in
                BarMark(xStart: .value("Total", bar.range.lowerBound), xEnd: .value("Total", bar.range.upperBound))
                    .foregroundStyle(by: .value("PaymentType", bar.paymentType.name))
                    .symbol(by: .value("PaymentType", bar.paymentType.name))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accessibilityLabel("\(bar.paymentType.name) total")
                    .accessibilityValue(Text(bar.total.value, format: .currency(code: "USD")))
            }
        }
        .chartForegroundStyleScale(summary.foregroundStyleScale())
        .chartSymbolScale(summary.symbolScale())
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
