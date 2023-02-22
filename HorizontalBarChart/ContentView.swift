//
//  ContentView.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/16/23.
//

import SwiftUI
import Charts

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
//        GeometryReader { geo in
            Chart {
                ForEach(summary.bars) { bar in
                    barContent(bar)
                }
                ForEach(summary.spacebars) { bar in
                    barContent(bar)
                }
            }
            .chartForegroundStyleScale { (value: PaymentType) in
                value.appearance.color
            }
            .chartSymbolScale { (value: PaymentType) in
                value.appearance.symbol
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
//            .chartXScale(range: 0...geo.size.width, type: .none)
//        }
    }

    @ChartContentBuilder
    private func barContent(_ bar: PaymentBarModel) -> some ChartContent {
        BarMark(xStart: .value("Total", bar.range.lowerBound),
                xEnd: .value("Total", bar.range.upperBound))
        .foregroundStyle(by: .value("Payment Type", bar.value))
        .symbol(by: .value("Payment Type", bar.value))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .accessibilityLabel("\(bar.value.name) total")
        .accessibilityValue(Text(bar.total.value, format: .currency(code: "USD")))
    }

    @ChartContentBuilder
    private func barContent(_ bar: SpacerBarModel) -> some ChartContent {
        BarMark(xStart: .value("Total", bar.range.lowerBound),
                xEnd: .value("Total", bar.range.upperBound))
//        .foregroundStyle(by: .value("Noop", bar.value))
//        .symbol(by: .value("Noop", bar.value))
        .accessibilityHidden(true)
        .opacity(0.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
