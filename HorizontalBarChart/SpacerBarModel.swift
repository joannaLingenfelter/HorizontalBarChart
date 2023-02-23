//
//  SpacerBarModel.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/23/23.
//

import Foundation

struct SpacerBarModel: BarRepresentable {
    var value: SpacerBarMark
    var total: DuplicitousValue
    var range: ClosedRange<Double>
}
