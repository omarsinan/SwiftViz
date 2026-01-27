//
//  Examples.swift
//  SwiftViz
//
//  Example usage and previews for SwiftViz components.
//

import SwiftUI

// MARK: - Basic Example

struct BasicBarChartExample: View {
    let categories = [
        SVCategory(name: "Food", color: .blue),
        SVCategory(name: "Transport", color: .green),
        SVCategory(name: "Entertainment", color: .orange)
    ]

    let data: [[Double]] = [
        [120, 45, 30],   // Mon
        [85, 60, 25],    // Tue
        [150, 35, 55],   // Wed
        [95, 50, 40],    // Thu
        [130, 40, 60],   // Fri
        [70, 20, 80],    // Sat
        [50, 15, 45]     // Sun
    ]

    let labels = ["M", "T", "W", "T", "F", "S", "S"]
    let expandedLabels = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        SVBarChart(
            data: data,
            categories: categories,
            labels: labels,
            expandedLabels: expandedLabels
        )
        .padding()
    }
}

// MARK: - Custom Styled Example

struct CustomStyledChartExample: View {
    let categories = [
        SVCategory(name: "Revenue", colorHex: "#4CAF50"),
        SVCategory(name: "Expenses", colorHex: "#F44336")
    ]

    let data: [[Double]] = [
        [1200, 800],
        [1500, 900],
        [1100, 750],
        [1800, 1200]
    ]

    let labels = ["Q1", "Q2", "Q3", "Q4"]

    var body: some View {
        SVBarChart(
            data: data,
            categories: categories,
            labels: labels,
            style: SVBarChartStyle(
                chartHeight: 250,
                barSpacing: 16,
                barCornerRadius: 12,
                showAverageLine: false,
                showLegend: true
            )
        )
        .padding()
    }
}

// MARK: - Simple Bar Chart (No Categories)

struct SimpleBarChartExample: View {
    var body: some View {
        SVBarChart(
            values: [45, 62, 38, 71, 55, 48],
            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
            color: .purple
        )
        .padding()
    }
}

// MARK: - Simple Bar Chart with Expanded Labels

struct SimpleBarChartExpandedExample: View {
    var body: some View {
        SVBarChart(
            values: [120, 95, 140, 85],
            labels: ["Q1", "Q2", "Q3", "Q4"],
            expandedLabels: ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"],
            color: .teal,
            style: SVBarChartStyle(chartHeight: 180)
        )
        .padding()
    }
}

// MARK: - Chart with Currency Formatter

struct CurrencyFormatterExample: View {
    let categories = [
        SVCategory(name: "Food", color: .blue),
        SVCategory(name: "Transport", color: .green)
    ]

    let data: [[Double]] = [
        [150.50, 45.00],
        [120.75, 60.25],
        [180.00, 35.50]
    ]

    let labels = ["Mon", "Tue", "Wed"]

    var body: some View {
        SVBarChart(
            data: data,
            categories: categories,
            labels: labels,
            valueFormatter: { value, categoryIndex, barIndex in
                value.formatted(
                    .currency(code: "USD")
                    .presentation(.narrow)
                    .locale(Locale(identifier: "en_US"))
                )
            }
        )
        .padding()
    }
}

// MARK: - Multi-Currency Example

struct MultiCurrencyExample: View {
    let categories = [
        SVCategory(name: "USD Account", color: .green),
        SVCategory(name: "EUR Account", color: .blue)
    ]

    let currencies = ["USD", "EUR"]

    let data: [[Double]] = [
        [1200, 950],
        [1500, 1100],
        [1100, 800]
    ]

    let labels = ["Jan", "Feb", "Mar"]

    var body: some View {
        SVBarChart(
            data: data,
            categories: categories,
            labels: labels,
            valueFormatter: { value, categoryIndex, barIndex in
                let currency = currencies[categoryIndex]
                return String(format: "%.0f %@", value, currency)
            }
        )
        .padding()
    }
}

// MARK: - Previews

#Preview("Stacked Bar Chart") {
    BasicBarChartExample()
}

#Preview("Custom Styled") {
    CustomStyledChartExample()
}

#Preview("Simple Bar Chart") {
    SimpleBarChartExample()
}

#Preview("Simple with Expanded Labels") {
    SimpleBarChartExpandedExample()
}

#Preview("Currency Formatter") {
    CurrencyFormatterExample()
}

#Preview("Multi-Currency") {
    MultiCurrencyExample()
}
