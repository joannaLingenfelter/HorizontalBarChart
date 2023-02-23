//
//  BarRepresentable.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/23/23.
//

import Foundation
import Charts

protocol BarRepresentable: Identifiable {
    associatedtype Value: Plottable & RawRepresentable
    var value: Value { get }
    var total: DuplicitousValue { get }
    var range: ClosedRange<Double> { get }
    var id: String { get }
}

extension BarRepresentable where Value.RawValue == String {
    var id: String {
        value.rawValue
    }
}
