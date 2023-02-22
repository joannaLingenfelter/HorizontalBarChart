//
//  PaymentType.swift
//  HorizontalBarChart
//
//  Created by Chris Stroud on 2/22/23.
//

import Foundation
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
