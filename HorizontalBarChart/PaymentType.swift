//
//  PaymentType.swift
//  HorizontalBarChart
//
//  Created by Chris Stroud on 2/22/23.
//

import Foundation
import SwiftUI
import Charts

enum SpacerBarMark: String, Plottable {
    case trailing
}

enum PaymentType: String, Plottable {

    case plan = "Plans payment "
    case cardSpend = "Card spend"

    var name: String {
        rawValue
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
