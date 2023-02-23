//
//  PaymentBarModel.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/23/23.
//

import Foundation

struct PaymentBarModel: BarRepresentable {
    let value: PaymentType
    let total: DuplicitousValue
    let range: ClosedRange<Double>
}
