//
//  SVBarChartStyle.swift
//  SwiftViz
//

import SwiftUI

/// Configuration options for customizing the appearance of an `SVBarChart`.
///
/// ```swift
/// SVBarChart(
///     data: chartData,
///     categories: categories,
///     labels: labels,
///     style: SVBarChartStyle(
///         chartHeight: 250,
///         barSpacing: 12,
///         showAverageLine: true
///     )
/// )
/// ```
public struct SVBarChartStyle: Sendable {
    /// The height of the chart area (excluding labels and legend).
    public var chartHeight: CGFloat

    /// The spacing between bars.
    public var barSpacing: CGFloat

    /// The corner radius for bar shapes.
    public var barCornerRadius: CGFloat

    /// The color of the background bar (unfilled portion).
    public var backgroundBarColor: Color

    /// Whether to show the average line overlay.
    public var showAverageLine: Bool

    /// The color of the average line.
    public var averageLineColor: Color

    /// The dash pattern for the average line.
    public var averageLineDash: [CGFloat]

    /// Whether to show the legend below the chart.
    public var showLegend: Bool

    /// The font for y-axis labels.
    public var yAxisFont: Font

    /// The font for x-axis labels.
    public var xAxisFont: Font

    /// The font for legend items.
    public var legendFont: Font

    /// The font for the chart title.
    public var titleFont: Font

    /// The animation used for bar selection transitions.
    public var selectionAnimation: Animation

    /// Whether to show the y-axis labels.
    public var showYAxis: Bool

    /// Whether to show the x-axis labels.
    public var showXAxis: Bool

    /// Whether bars are interactive (tappable to show detail view).
    public var isInteractive: Bool

    /// Creates a new chart style with customizable options.
    public init(
        chartHeight: CGFloat = 200,
        barSpacing: CGFloat = 8,
        barCornerRadius: CGFloat = 8,
        backgroundBarColor: Color = .gray.opacity(0.2),
        showAverageLine: Bool = true,
        averageLineColor: Color = .gray.opacity(0.6),
        averageLineDash: [CGFloat] = [5, 8],
        showLegend: Bool = true,
        yAxisFont: Font = .body.bold(),
        xAxisFont: Font = .body.bold(),
        legendFont: Font = .system(size: 14).bold(),
        titleFont: Font = .title3.bold(),
        selectionAnimation: Animation = .spring(duration: 0.25),
        showYAxis: Bool = true,
        showXAxis: Bool = true,
        isInteractive: Bool = true
    ) {
        self.chartHeight = chartHeight
        self.barSpacing = barSpacing
        self.barCornerRadius = barCornerRadius
        self.backgroundBarColor = backgroundBarColor
        self.showAverageLine = showAverageLine
        self.averageLineColor = averageLineColor
        self.averageLineDash = averageLineDash
        self.showLegend = showLegend
        self.yAxisFont = yAxisFont
        self.xAxisFont = xAxisFont
        self.legendFont = legendFont
        self.titleFont = titleFont
        self.selectionAnimation = selectionAnimation
        self.showYAxis = showYAxis
        self.showXAxis = showXAxis
        self.isInteractive = isInteractive
    }

    /// The default chart style.
    public static let `default` = SVBarChartStyle()
}
