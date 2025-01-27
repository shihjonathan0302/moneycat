//
//  ExpenseBetterWorseChart.swift
//  moneycat_beta
//
//  Created by Jonathan Shih on 2024/11/9.
//

import SwiftUI
import Charts

struct ExpenseBetterWorseChart: View {
    @ObservedObject var realmManager: RealmManager // Observe RealmManager changes

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Text("Attractive")
                        .foregroundColor(Color.orange) // Changed to orange
                        .font(.caption)
                        .padding(.leading, 5)
                    Spacer()
                    Text("Indifferent")
                        .foregroundColor(Color(red: 1, green: 0.8, blue: 0.5, opacity: 1)) // Lighter orange
                        .font(.caption)
                        .padding(.trailing, 5)
                }
                Spacer()
                HStack {
                    Text("Must")
                        .foregroundColor(Color(red: 1, green: 0.75, blue: 0.3, opacity: 1)) // Golden Orange
                        .font(.caption)
                        .padding(.leading, 5)
                    Spacer()
                    Text("One-Dimensional")
                        .foregroundColor(Color(red: 0.95, green: 0.65, blue: 0.1, opacity: 1)) // Vibrant Ochre
                        .font(.caption)
                        .padding(.trailing, 5)
                }
            }
            .zIndex(1)

            Chart {
                RectangleMark(
                    xStart: .value("Left", -100.0),
                    xEnd: .value("Right", -50.0),
                    yStart: .value("Bottom", 0.0),
                    yEnd: .value("Top", 50.0)
                )
                .foregroundStyle(Color(red: 0.8, green: 0.4, blue: 0, opacity: 0.2)) // Burnt Orange

                RectangleMark(
                    xStart: .value("Left", -50.0),
                    xEnd: .value("Right", 0.0),
                    yStart: .value("Bottom", 0.0),
                    yEnd: .value("Top", 50.0)
                )
                .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.05, opacity: 0.2)) // Amber

                RectangleMark(
                    xStart: .value("Left", -100.0),
                    xEnd: .value("Right", -50.0),
                    yStart: .value("Bottom", 50.0),
                    yEnd: .value("Top", 100.0)
                )
                .foregroundStyle(Color(red: 1, green: 0.5, blue: 0, opacity: 0.2)) // Rich Orange

                RectangleMark(
                    xStart: .value("Left", -50.0),
                    xEnd: .value("Right", 0.0),
                    yStart: .value("Bottom", 50.0),
                    yEnd: .value("Top", 100.0)
                )
                .foregroundStyle(Color(red: 1, green: 0.75, blue: 0.25, opacity: 0.2)) // Sunflower Yellow

                ForEach(realmManager.expenses.filter { !$0.isInvalidated && $0.needOrWant == "Want" }, id: \.id) { expense in
                    let better = expense.betterCoefficient
                    let worse = expense.worseCoefficient
                    let categoryColor = expense.category?.color?.toUIColor() ?? UIColor.gray

                    PointMark(
                        x: .value("Worse", Double(worse)),
                        y: .value("Better", Double(better))
                    )
                    .foregroundStyle(Color(uiColor: categoryColor))
                    .symbolSize(120)
                }

                RuleMark(y: .value("50% Better", 50))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundStyle(.gray.opacity(0.5))

                RuleMark(x: .value("50% Worse", -50))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundStyle(.gray.opacity(0.5))
            }
            .padding()
            .chartXScale(domain: -100...0)
            .chartYScale(domain: 0...100)
            .onAppear {
                print("Debug: ExpenseBetterWorseChart appeared with \(realmManager.expenses.count) expenses")
            }
            .onReceive(realmManager.$updateTrigger) { _ in
                print("Debug: updateTrigger fired, updating chart")
            }
        }
    }
}
