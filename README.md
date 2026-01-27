# SwiftViz

A lightweight, interactive charting library for SwiftUI with beautiful animations and customizable styling.

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS 17.0+">
  <img src="https://img.shields.io/badge/macOS-14.0+-blue.svg" alt="macOS 14.0+">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="MIT License">
</p>

## Features

- **Stacked Bar Charts** - Display multiple data categories in a single bar with distinct color segments
- **Interactive Selection** - Tap bars to reveal detailed breakdowns with smooth spring animations
- **Customizable Styling** - Configure colors, spacing, fonts, and more via `SVBarChartStyle`
- **Average Line Overlay** - Optional dashed line showing the average value across all bars
- **Legend Support** - Automatic category legend with color indicators
- **Pure SwiftUI** - No external dependencies, works seamlessly with SwiftUI's animation system

## Installation

Add SwiftViz to your project using Xcode:

> **Note:** Requires iOS 17.0+ / macOS 14.0+ and Swift 6.0+

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/omarsinan/SwiftViz.git
   ```
3. Select the version rule (e.g., "Up to Next Major Version")
4. Click **Add Package**

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/omarsinan/SwiftViz.git", from: "1.0.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftViz"]
)
```

## Quick Start

### Simple Bar Chart

The quickest way to get started is to just pass values and labels:

```swift
import SwiftUI
import SwiftViz

struct ContentView: View {
    var body: some View {
        SVBarChart(
            values: [120, 85, 150, 95, 130, 70, 50],
            labels: ["M", "T", "W", "T", "F", "S", "S"],
            color: .blue
        )
        .padding()
    }
}
```

### Stacked Bar Chart

For multiple data categories per bar:

```swift
import SwiftUI
import SwiftViz

struct ContentView: View {
    let categories = [
        SVCategory(name: "Food", color: .blue),
        SVCategory(name: "Transport", color: .green),
        SVCategory(name: "Entertainment", color: .orange)
    ]

    let data: [[Double]] = [
        [120, 45, 30],
        [85, 60, 25],
        [150, 35, 55],
        [95, 50, 40],
        [130, 40, 60],
        [70, 20, 80],
        [50, 15, 45]
    ]

    let labels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        SVBarChart(
            data: data,
            categories: categories,
            labels: labels
        )
        .padding()
    }
}
```

## Usage

### SVBarChart

The main chart component. Supports both simple single-series charts and stacked multi-category charts.

#### Simple Bar Chart (No Categories)

For basic bar charts with a single data series:

```swift
SVBarChart(
    values: [Double],                   // Required: Array of values (one per bar)
    labels: [String]?,                  // Optional: X-axis labels
    expandedLabels: [String]?,          // Optional: Full labels for selection
    color: Color,                       // Optional: Bar color (default: .blue)
    valueFormatter: SVValueFormatter?,  // Optional: Custom value formatting
    style: SVBarChartStyle              // Optional: Styling configuration
)
```

| Parameter        | Type                | Default    | Description                                                                                                          |
| ---------------- | ------------------- | ---------- | -------------------------------------------------------------------------------------------------------------------- |
| `values`         | `[Double]`          |            | An array of values, one per bar.                                                                                     |
| `labels`         | `[String]?`         | `nil`      | Optional labels displayed below each bar on the x-axis. Count must match the number of bars if provided.             |
| `expandedLabels` | `[String]?`         | `nil`      | Optional longer labels shown in the detail view when a bar is selected. Falls back to `labels` if not provided.      |
| `color`          | `Color`             | `.blue`    | The color for all bars.                                                                                              |
| `valueFormatter` | `SVValueFormatter?` | `nil`      | Optional closure to format values in the detail view (e.g., for currencies).                                         |
| `style`          | `SVBarChartStyle`   | `.default` | Configuration object for customizing the chart appearance. Legend is automatically hidden for simple charts.          |

#### Stacked Bar Chart (With Categories)

For charts with multiple data categories per bar:

```swift
SVBarChart(
    data: [[Double]],                   // Required: 2D array of values
    categories: [SVCategory],           // Required: Category definitions
    labels: [String]?,                  // Optional: X-axis labels
    expandedLabels: [String]?,          // Optional: Full labels for selection
    valueFormatter: SVValueFormatter?,  // Optional: Custom value formatting
    style: SVBarChartStyle              // Optional: Styling configuration
)
```

| Parameter        | Type                | Default    | Description                                                                                                                                                                                                       |
| ---------------- | ------------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `data`           | `[[Double]]`        |            | A 2D array where each inner array contains values for each category in a single bar. The outer array represents bars (left to right), and inner arrays represent category values (must match `categories` order). |
| `categories`     | `[SVCategory]`      |            | Array of categories defining the data series. Each category has a name and color.                                                                                                                                 |
| `labels`         | `[String]?`         | `nil`      | Optional labels displayed below each bar on the x-axis. Count must match the number of bars if provided.                                                                                                          |
| `expandedLabels` | `[String]?`         | `nil`      | Optional longer labels shown in the detail view when a bar is selected. Falls back to `labels` if not provided.                                                                                                   |
| `valueFormatter` | `SVValueFormatter?` | `nil`      | Optional closure to format values in the detail view (e.g., for currencies).                                                                                                                                      |
| `style`          | `SVBarChartStyle`   | `.default` | Configuration object for customizing the chart appearance.                                                                                                                                                        |

### SVCategory

Represents a data series with a name and color.

```swift
// Using SwiftUI Color
let category = SVCategory(name: "Food", color: .blue)

// Using hex string
let category = SVCategory(name: "Transport", colorHex: "#4CAF50")
```

#### Initializers

| Initializer                            | Description                                                                                           |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `init(name: String, color: Color)`     | Creates a category with a SwiftUI Color                                                               |
| `init(name: String, colorHex: String)` | Creates a category with a hex color string (supports `#RGB`, `RGB`, `#RRGGBB`, `RRGGBB`, `#AARRGGBB`) |

### SVBarChartStyle

Customize the chart's appearance with `SVBarChartStyle`.

```swift
SVBarChart(
    data: data,
    categories: categories,
    labels: labels,
    style: SVBarChartStyle(
        chartHeight: 250,
        barSpacing: 12,
        barCornerRadius: 10,
        showAverageLine: false,
        showLegend: true
    )
)
```

#### Properties

| Property             | Type        | Default                    | Description                                                |
| -------------------- | ----------- | -------------------------- | ---------------------------------------------------------- |
| `chartHeight`        | `CGFloat`   | `200`                      | The height of the chart area (excluding labels and legend) |
| `barSpacing`         | `CGFloat`   | `8`                        | The spacing between adjacent bars                          |
| `barCornerRadius`    | `CGFloat`   | `8`                        | The corner radius for bar shapes                           |
| `backgroundBarColor` | `Color`     | `.gray.opacity(0.2)`       | The color of the unfilled bar background                   |
| `showAverageLine`    | `Bool`      | `true`                     | Whether to display the average line overlay                |
| `averageLineColor`   | `Color`     | `.gray.opacity(0.6)`       | The color of the average line                              |
| `averageLineDash`    | `[CGFloat]` | `[5, 8]`                   | The dash pattern for the average line                      |
| `showLegend`         | `Bool`      | `true`                     | Whether to display the category legend below the chart     |
| `yAxisFont`          | `Font`      | `.body.bold()`             | The font used for y-axis labels                            |
| `xAxisFont`          | `Font`      | `.body.bold()`             | The font used for x-axis labels                            |
| `legendFont`         | `Font`      | `.system(size: 14).bold()` | The font used for legend items                             |
| `selectionAnimation` | `Animation` | `.spring(duration: 0.25)`  | The animation used for bar selection transitions           |
| `isInteractive`      | `Bool`      | `true`                     | Whether bars are tappable to show the detail view          |

### Value Formatting

Use `valueFormatter` to customize how values appear in the detail view. The formatter receives:

- `value`: The numeric value
- `categoryIndex`: Index of the category (for multi-category charts)
- `barIndex`: Index of the bar being displayed

#### Single Currency

```swift
SVBarChart(
    data: data,
    categories: categories,
    labels: labels,
    valueFormatter: { value, categoryIndex, barIndex in
        String(format: "%.2f QAR", value)
    }
)
```

#### Multiple Currencies

```swift
let currencies = ["USD", "EUR", "GBP"]

SVBarChart(
    data: data,
    categories: categories,
    labels: labels,
    valueFormatter: { value, categoryIndex, barIndex in
        let currency = currencies[categoryIndex]
        return String(format: "%.0f %@", value, currency)
    }
)
```

#### Percentage Values

```swift
SVBarChart(
    values: values,
    labels: labels,
    valueFormatter: { value, _, _ in
        String(format: "%.1f%%", value)
    }
)
```

## Examples

### Simple Bar Chart

```swift
SVBarChart(
    values: [45, 62, 38, 71, 55, 48],
    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
    color: .purple
)
```

### Simple Bar Chart with Expanded Labels

```swift
SVBarChart(
    values: [120, 95, 140, 85],
    labels: ["Q1", "Q2", "Q3", "Q4"],
    expandedLabels: ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"],
    color: .teal,
    style: SVBarChartStyle(chartHeight: 180)
)
```

### Stacked Bar Chart

```swift
let categories = [
    SVCategory(name: "Revenue", color: .green),
    SVCategory(name: "Expenses", color: .red)
]

let data: [[Double]] = [
    [1200, 800],
    [1500, 900],
    [1100, 750],
    [1800, 1200]
]

SVBarChart(
    data: data,
    categories: categories,
    labels: ["Q1", "Q2", "Q3", "Q4"]
)
```

### Weekly Spending with Expanded Labels

```swift
let categories = [
    SVCategory(name: "Food", colorHex: "#6B99D6"),
    SVCategory(name: "Transport", colorHex: "#4CAF50"),
    SVCategory(name: "Shopping", colorHex: "#FF9800")
]

let data: [[Double]] = [
    [50, 20, 30],
    [45, 25, 15],
    [60, 30, 40],
    [55, 20, 25],
    [70, 35, 50],
    [40, 10, 80],
    [30, 5, 20]
]

SVBarChart(
    data: data,
    categories: categories,
    labels: ["M", "T", "W", "T", "F", "S", "S"],
    expandedLabels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    style: SVBarChartStyle(
        chartHeight: 220,
        barSpacing: 10,
        showAverageLine: true
    )
)
```

### Custom Styled Chart

```swift
SVBarChart(
    data: data,
    categories: categories,
    labels: labels,
    style: SVBarChartStyle(
        chartHeight: 300,
        barSpacing: 16,
        barCornerRadius: 12,
        backgroundBarColor: .blue.opacity(0.1),
        showAverageLine: false,
        showLegend: true,
        yAxisFont: .caption.bold(),
        xAxisFont: .caption2,
        legendFont: .footnote,
        selectionAnimation: .spring(duration: 0.3, bounce: 0.2)
    )
)
```

## Data Format

The `data` parameter is a 2D array structured as follows:

```
data[barIndex][categoryIndex] = value
```

For example, with 3 categories and 4 bars:

```swift
let data: [[Double]] = [
    [100, 50, 25],  // Bar 0: Category 0 = 100, Category 1 = 50, Category 2 = 25
    [80, 60, 30],   // Bar 1
    [120, 40, 35],  // Bar 2
    [90, 70, 20]    // Bar 3
]
```

The order of values in each inner array must match the order of categories.

## License

SwiftViz is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
