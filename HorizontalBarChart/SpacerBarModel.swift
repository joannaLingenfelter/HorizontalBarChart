//
//  SpacerBarModel.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/23/23.
//

import Foundation
import Charts

enum SpacerBarMark: String, Plottable {
    case trailing
}

struct SpacerBarModel: BarRepresentable {
    var value: SpacerBarMark
    var total: DuplicitousValue
    var range: ClosedRange<Double>
}
