//
//  Helpers.swift
//  HorizontalBarChart
//
//  Created by Chris Stroud on 2/22/23.
//

import Foundation

func map(_ value: Double, from input: ClosedRange<Double>, to output: ClosedRange<Double>) -> Double {
    (value - input.lowerBound) * (output.upperBound - output.lowerBound) / (input.upperBound - input.lowerBound) + output.lowerBound
}
