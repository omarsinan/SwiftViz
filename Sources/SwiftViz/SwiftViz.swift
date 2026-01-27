//
//  SwiftViz.swift
//  SwiftViz
//
//  A SwiftUI charting library for beautiful, interactive bar charts.
//

import SwiftUI

/// A stacked bar chart view with interactive selection.
///
/// `SVBarChart` displays data as vertical bars, with support for multiple categories
/// (stacked segments), interactive selection, and customizable styling.
///
/// ## Basic Usage
///
/// ```swift
/// let categories = [
///     SVCategory(name: "Food", color: .blue),
///     SVCategory(name: "Transport", color: .green)
/// ]
///
/// let data: [[Double]] = [
///     [100, 50],   // Monday
///     [80, 30],    // Tuesday
///     [120, 60],   // Wednesday
///     [90, 40],    // Thursday
///     [110, 55],   // Friday
///     [70, 25],    // Saturday
///     [60, 20]     // Sunday
/// ]
///
/// let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
///
/// SVBarChart(data: data, categories: categories, labels: labels)
/// ```
///
/// ## Customization
///
/// Use `SVBarChartStyle` to customize the chart appearance:
///
/// ```swift
/// SVBarChart(
///     data: data,
///     categories: categories,
///     labels: labels,
///     style: SVBarChartStyle(
///         chartHeight: 250,
///         barSpacing: 12,
///         showAverageLine: false
///     )
/// )
/// ```
public struct SVBarChart: View {
    // MARK: - State

    @State private var selectedBar: Int? = nil
    @State private var isAnimating: Bool = false

    // MARK: - Properties

    /// The chart data. Each inner array represents a bar's category values.
    /// The order of values must match the order of categories.
    let data: [[Double]]

    /// The categories (data series) displayed in the chart.
    let categories: [SVCategory]

    /// The labels displayed below each bar on the x-axis. If nil, no x-axis labels are shown.
    let labels: [String]?

    /// The styling configuration for the chart.
    let style: SVBarChartStyle

    /// Optional expanded labels shown when a bar is selected.
    let expandedLabels: [String]?

    /// Optional formatter for displaying values in the detail view.
    let valueFormatter: SVValueFormatter?

    // MARK: - Computed Properties

    @Namespace private var chartNamespace

    /// The maximum total value across all bars.
    private var maxValue: Double {
        data.map { $0.reduce(0, +) }.max() ?? 0
    }

    /// The padded maximum value for y-axis scaling.
    private var paddedMaxValue: Int {
        let raw = maxValue * 1.2
        return max(Int(ceil(raw / 10.0)) * 10, 10)
    }

    /// The average total value across all bars.
    private var avgValue: Double {
        guard !data.isEmpty else { return 0 }
        let totals = data.map { $0.reduce(0, +) }
        return totals.reduce(0, +) / Double(totals.count)
    }

    /// The number of columns (bars) in the chart.
    private var columns: Int {
        data.count
    }

    // MARK: - Initialization

    /// Creates a new bar chart.
    /// - Parameters:
    ///   - data: A 2D array where each inner array contains values for each category in a single bar.
    ///   - categories: The categories (data series) to display. The count must match the inner array lengths.
    ///   - labels: Optional labels to display below each bar. If provided, count must match the number of bars.
    ///   - expandedLabels: Optional longer labels to show when a bar is selected. Falls back to `labels` if not provided.
    ///   - valueFormatter: Optional closure to format values in the detail view (e.g., for currencies).
    ///   - style: The styling configuration for the chart.
    public init(
        data: [[Double]],
        categories: [SVCategory],
        labels: [String]? = nil,
        expandedLabels: [String]? = nil,
        valueFormatter: SVValueFormatter? = nil,
        style: SVBarChartStyle = .default
    ) {
        self.data = data
        self.categories = categories
        self.labels = labels
        self.expandedLabels = expandedLabels
        self.valueFormatter = valueFormatter
        self.style = style
    }

    /// Creates a simple bar chart without categories.
    ///
    /// Use this initializer when you have a single data series and don't need
    /// stacked bars or a legend.
    ///
    /// ```swift
    /// SVBarChart(
    ///     values: [10, 20, 30, 40],
    ///     labels: ["Q1", "Q2", "Q3", "Q4"],
    ///     color: .blue
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - values: An array of values, one per bar.
    ///   - labels: Optional labels to display below each bar.
    ///   - expandedLabels: Optional longer labels to show when a bar is selected.
    ///   - color: The color for all bars. Defaults to `.blue`.
    ///   - valueFormatter: Optional closure to format values in the detail view.
    ///   - style: The styling configuration. Legend is automatically hidden.
    public init(
        values: [Double],
        labels: [String]? = nil,
        expandedLabels: [String]? = nil,
        color: Color = .blue,
        valueFormatter: SVValueFormatter? = nil,
        style: SVBarChartStyle = .default
    ) {
        self.data = values.map { [$0] }
        self.categories = [SVCategory(name: "", color: color)]
        self.labels = labels
        self.expandedLabels = expandedLabels
        self.valueFormatter = valueFormatter
        // Override to hide legend for simple charts
        var modifiedStyle = style
        modifiedStyle.showLegend = false
        self.style = modifiedStyle
    }

    // MARK: - Body

    public var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                if style.showYAxis {
                    yAxisLabels
                }

                VStack {
                    if data.isEmpty {
                        EmptyView()
                    } else {
                        barsView
                            .frame(height: style.chartHeight)
                            .overlay(averageLineOverlay)
                            .allowsHitTesting(!isAnimating)

                        if style.showXAxis, let labels, !labels.isEmpty {
                            xAxisLabels
                        }
                    }
                }
            }

            if style.showLegend {
                legendView
            }
        }
    }

    // MARK: - Subviews

    /// The y-axis labels showing the scale.
    private var yAxisLabels: some View {
        ZStack {
            VStack(alignment: .trailing) {
                Text("\(paddedMaxValue)")
                    .font(style.yAxisFont)

                Spacer()

                Text("0")
                    .font(style.yAxisFont)
            }
        }
        .overlay(averageLabelOverlay)
        .foregroundStyle(.secondary)
        .frame(height: style.chartHeight)
    }

    /// The average value label on the y-axis.
    private var averageLabelOverlay: some View {
        Group {
            let y = style.chartHeight * avgValue / Double(paddedMaxValue) - 10
            if style.showAverageLine && selectedBar == nil && y > 10 {
                VStack(alignment: .trailing) {
                    Spacer()

                    Text("\(Int(avgValue))")
                        .font(style.yAxisFont)
                        .fixedSize()
                        .padding(.bottom, y)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    /// The average line overlay on the chart.
    private var averageLineOverlay: some View {
        Group {
            let y = style.chartHeight * avgValue / Double(paddedMaxValue)
            if style.showAverageLine && selectedBar == nil && y > 10 {
                VStack {
                    Spacer()

                    SVLine()
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                dash: style.averageLineDash
                            )
                        )
                        .frame(height: 1)
                        .foregroundStyle(style.averageLineColor)
                        .padding(.horizontal, -5)
                        .padding(.bottom, y)
                }
            }
        }
    }

    /// The bar chart area.
    private var barsView: some View {
        GeometryReader { geo in
            let totalSpacing = style.barSpacing * CGFloat(columns - 1)
            let barWidth = (geo.size.width - totalSpacing) / CGFloat(columns)

            HStack(spacing: style.barSpacing) {
                if let sel = selectedBar {
                    // Selected bar
                    SVBarView(
                        values: data[sel],
                        categories: categories,
                        maxValue: paddedMaxValue,
                        chartHeight: style.chartHeight,
                        width: barWidth,
                        style: style,
                        namespace: chartNamespace,
                        index: sel
                    )

                    // Detail panel
                    SVDetailView(
                        label: expandedLabels?[sel] ?? labels?[sel] ?? "",
                        values: data[sel],
                        categories: categories,
                        barIndex: sel,
                        valueFormatter: valueFormatter,
                        style: style,
                        onClose: {
                            withAnimation(style.selectionAnimation) {
                                isAnimating = true
                                selectedBar = nil
                            } completion: {
                                isAnimating = false
                            }
                        }
                    )
                    .transition(.scale(scale: 0.001, anchor: .trailing))
                } else {
                    // All bars
                    ForEach(0..<columns, id: \.self) { i in
                        SVBarView(
                            values: data[i],
                            categories: categories,
                            maxValue: paddedMaxValue,
                            chartHeight: style.chartHeight,
                            width: barWidth,
                            style: style,
                            namespace: chartNamespace,
                            index: i
                        )
                        .onTapGesture {
                            guard style.isInteractive else { return }
                            withAnimation(style.selectionAnimation) {
                                isAnimating = true
                                selectedBar = i
                            } completion: {
                                isAnimating = false
                            }
                        }
                    }
                }
            }
            .animation(.spring(), value: selectedBar)
        }
    }

    /// The x-axis labels below the bars.
    @ViewBuilder
    private var xAxisLabels: some View {
        if let labels {
            HStack {
                ForEach(Array(labels.enumerated()), id: \.offset) { i, label in
                    Text(selectedBar == nil ? label : labels[selectedBar!])
                        .font(style.xAxisFont)
                        .frame(maxWidth: .infinity)
                        .opacity(selectedBar == nil ? 1 : (i == 0 ? 1 : 0))
                }
                .foregroundStyle(.secondary)
            }
        }
    }

    /// The category legend below the chart.
    private var legendView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { category in
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(category.color)
                            .cornerRadius(2)
                            .frame(width: 8, height: 8)
                        Text(category.name)
                            .font(style.legendFont)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

/// A closure that formats a value for display in the detail view.
/// - Parameters:
///   - value: The numeric value to format
///   - categoryIndex: The index of the category (useful for multi-currency scenarios)
///   - barIndex: The index of the bar being displayed
/// - Returns: A formatted string representation of the value
public typealias SVValueFormatter = (_ value: Double, _ categoryIndex: Int, _ barIndex: Int) -> String
