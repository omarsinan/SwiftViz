//
//  DetailView.swift
//  SwiftViz
//

import SwiftUI

/// Internal view showing details when a bar is selected.
struct SVDetailView: View {
    let label: String
    let values: [Double]
    let categories: [SVCategory]
    let barIndex: Int
    let valueFormatter: SVValueFormatter?
    let style: SVBarChartStyle
    let onClose: () -> Void

    /// Custom content builder for detail view, if provided.
    let customContent: AnyView?

    init(
        label: String,
        values: [Double],
        categories: [SVCategory],
        barIndex: Int = 0,
        valueFormatter: SVValueFormatter? = nil,
        style: SVBarChartStyle,
        onClose: @escaping () -> Void,
        customContent: AnyView? = nil
    ) {
        self.label = label
        self.values = values
        self.categories = categories
        self.barIndex = barIndex
        self.valueFormatter = valueFormatter
        self.style = style
        self.onClose = onClose
        self.customContent = customContent
    }

    /// Formats a value using the formatter if available, otherwise returns the integer representation.
    private func formatValue(_ value: Double, categoryIndex: Int) -> String {
        if let formatter = valueFormatter {
            return formatter(value, categoryIndex, barIndex)
        }
        return "\(Int(value))"
    }

    var body: some View {
        ZStack {
            // Close button
            Button(role: .cancel, action: onClose) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.borderless)
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            // Content
            if let custom = customContent {
                custom
            } else {
                defaultContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(style.backgroundBarColor)
        .cornerRadius(style.barCornerRadius)
    }

    /// Whether this is a simple (single category with no name) chart.
    private var isSimpleChart: Bool {
        categories.count == 1 && categories[0].name.isEmpty
    }

    private var defaultContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)

            if isSimpleChart {
                // Simple chart: just show the value
                if let value = values.first, value > 0 {
                    HStack {
                        Circle()
                            .fill(categories[0].color)
                            .frame(width: 10, height: 10)
                        Text(formatValue(value, categoryIndex: 0))
                    }
                    .font(.caption)
                }
            } else {
                // Stacked chart: show category breakdown
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(Array(values.enumerated()).filter { $0.element > 0 }, id: \.offset) { i, value in
                            if i < categories.count {
                                HStack {
                                    Circle()
                                        .fill(categories[i].color)
                                        .frame(width: 10, height: 10)

                                    Text("\(categories[i].name): \(formatValue(value, categoryIndex: i))")
                                }
                            }
                        }
                        .font(.caption)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
