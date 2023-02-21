//
//  WorkoutTestChart.swift
//  HorizontalBarChart
//
//  Created by Jo Lingenfelter on 2/21/23.
//

import SwiftUI
import Charts

struct Workout: Identifiable, Hashable {
    var id = UUID()
    var day: String
    var minutes: Int
}

extension Workout {
    static var walkData: [Workout] {
        [
            .init(day: "Mon", minutes: 23),
            .init(day: "Tue", minutes: 45),
            .init(day: "Wed", minutes: 76),
            .init(day: "Thu", minutes: 21),
            .init(day: "Fri", minutes: 15),
            .init(day: "Sat", minutes: 35),
            .init(day: "Sun", minutes: 10)
        ]
    }

    static var runData: [Workout] {
        [
            .init(day: "Mon", minutes: 33),
            .init(day: "Tue", minutes: 12),
            .init(day: "Wed", minutes: 45),
            .init(day: "Thu", minutes: 54),
            .init(day: "Fri", minutes: 87),
            .init(day: "Sat", minutes: 32),
            .init(day: "Sun", minutes: 45)
        ]
    }
}

struct OtherView: View {
    let workouts = [
        (workoutType: "Walk", data: Workout.walkData),
        (workoutType: "Run", data: Workout.runData)
    ]

    var body: some View {
        VStack {
            Text("DevTechie")
                .font(.largeTitle)
            Chart {
                ForEach(workouts, id: \.workoutType) { series in
                    ForEach(series.data) { element in
                        LineMark(x: .value("Day", element.day),
                                 y: .value("Mins", element.minutes))
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(by: .value("WorkoutType", series.workoutType))
                            .symbol(by: .value("WorkoutType", series.workoutType))
                    }
                }
            }
            .frame(height: 400)
            .chartForegroundStyleScale([
                "Walk" : .yellow,
                "Run" : .blue
            ])
            .chartSymbolScale([
                "Walk" : .circle,
                "Run" : .square
            ])
        }
        .padding()
    }
}
