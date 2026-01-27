//
//  BarView.swift
//  SwiftViz
//

import SwiftUI

/// Internal view representing a single bar in the chart.
struct SVBarView: View {
    let values: [Double]
    let categories: [SVCategory]
    let maxValue: Int
    let chartHeight: CGFloat
    let width: CGFloat
    let style: SVBarChartStyle
    let namespace: Namespace.ID
    let index: Int

    var body: some View {
        let total = values.reduce(0, +)
        let height = CGFloat(total / Double(maxValue) * chartHeight)

        ZStack {
            // Background bar
            Rectangle()
                .fill(style.backgroundBarColor)
                .cornerRadius(style.barCornerRadius)
                .transaction { t in t.animation = nil }

            // Actual value bar with gradient
            Rectangle()
                .fill(gradientForValues(values))
                .cornerRadius(style.barCornerRadius)
                .frame(height: max(0, height))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .transaction { t in t.animation = nil }
        }
        .frame(width: width)
        .matchedGeometryEffect(id: "bar\(index)", in: namespace)
    }

    /// Creates a gradient with hard color stops for stacked bar effect.
    private func gradientForValues(_ values: [Double]) -> LinearGradient {
        let total = values.reduce(0, +)
        guard total > 0 else {
            return LinearGradient(colors: [.clear], startPoint: .bottom, endPoint: .top)
        }

        var stops: [Gradient.Stop] = []
        var cumulative: Double = 0

        for (i, value) in values.enumerated() where i < categories.count {
            let start = cumulative / total
            cumulative += value
            let end = cumulative / total
            let color = categories[i].color

            // Hard cutoff: duplicate color at start & end
            stops.append(.init(color: color, location: start))
            stops.append(.init(color: color, location: end))
        }

        return LinearGradient(
            gradient: Gradient(stops: stops),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}
