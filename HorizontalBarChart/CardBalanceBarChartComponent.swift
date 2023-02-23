//
//  ContentView.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/16/23.
//

import SwiftUI
import Charts

struct CardBalanceBarChartComponent: View {
    private var summary: PaymentSummary
    private var detailsAction: () -> ()

    @ScaledMetric(relativeTo: .largeTitle)
    var headerVerticalStackSpacing: CGFloat = 5

    @ScaledMetric(relativeTo: .largeTitle)
    private var chartContentSpacing: CGFloat = 10

    init(
        payments: [DisplayedPayment],
        detailsAction: @escaping () -> ()
    ) {
        self.summary = PaymentSummary(payments: payments)
        self.detailsAction = detailsAction
    }

    var body: some View {
            VStack(alignment: .leading, spacing: chartContentSpacing) {
                header()
                chart()
                    .frame(height: 30)
                legend()
            }
            .padding()
            .scenePadding()
    }

    private func detailsButton() -> some View {
        // TODO: Style font
        Button("Details") {
            detailsAction()
        }
    }

    private func header() -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top) {
                chartHeaderContent()
                Spacer()
                detailsButton()
            }

            VStack(alignment: .leading, spacing: headerVerticalStackSpacing) {
                chartHeaderContent()
                detailsButton()
            }
        }
    }

    func chartHeaderContent() -> some View {
        VStack(alignment: .leading, spacing: headerVerticalStackSpacing) {
            // TODO: Style font
            Text(summary.total, format: .currency(code: "USD"))
                .fontWeight(.bold)
                .lineLimit(1)
            Text(Date.now, format: .dateTime.day(.defaultDigits).month())
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            Text(summary.total, format: .currency(code: "USD")) +
            Text("owed on") +
            Text(Date.now, format: .dateTime.day(.defaultDigits).month())
        )
    }

    func chart() -> some View {
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
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden) // Using the chart's legend enforces a minimum height on chart that cannot be overriden
    }

    private func legend() -> some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                legendContent()
            }

            VStack(alignment: .leading) {
                legendContent()
            }
        }
        .accessibilityHidden(true)
    }

    private func legendContent() -> some View {
        ForEach(summary.bars) { (bar: PaymentBarModel) in
            HStack {
                bar.value.appearance.symbol
                    .fill(bar.value.appearance.color)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(height: 15)
                // TODO: Style Font
                Text(bar.value.name)
                    .foregroundColor(.black)
            }
        }
    }

    @ChartContentBuilder
    private func barContent(_ bar: PaymentBarModel) -> some ChartContent {
        BarMark(xStart: .value("Total", bar.range.lowerBound),
                xEnd: .value("Total", bar.range.upperBound))
        .foregroundStyle(by: .value("Payment Type", bar.value))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .accessibilityLabel("\(bar.value.name) total")
        .accessibilityValue(Text(bar.total.value, format: .currency(code: "USD")))
    }

    @ChartContentBuilder
    private func barContent(_ bar: SpacerBarModel) -> some ChartContent {
        BarMark(xStart: .value("Total", bar.range.lowerBound),
                xEnd: .value("Total", bar.range.upperBound))
        .accessibilityHidden(true)
        .opacity(0.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardBalanceBarChartComponent(
            payments: [
                .init(type: .plan, amount: 200),
                .init(type: .cardSpend, amount: 100)
            ],
            detailsAction: {})
    }
}
