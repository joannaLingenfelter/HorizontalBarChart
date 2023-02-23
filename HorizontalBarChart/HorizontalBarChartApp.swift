//
//  HorizontalBarChartApp.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/16/23.
//

import SwiftUI

@main
struct HorizontalBarChartApp: App {
    var body: some Scene {
        WindowGroup {
            CardBalanceBarChartComponent(
                payments: [
                    .init(type: .plan, amount: 200),
                    .init(type: .cardSpend, amount: 100)
                ],
                detailsAction: {})
        }
    }
}
