//
//  SVCategory.swift
//  SwiftViz
//

import SwiftUI

/// A category for stacked bar chart segments.
///
/// Each category represents a distinct data series with its own name and color.
/// Categories are displayed in the chart legend and used to color bar segments.
///
/// ```swift
/// let categories = [
///     SVCategory(name: "Food", color: .blue),
///     SVCategory(name: "Transport", color: .green),
///     SVCategory(name: "Entertainment", color: .orange)
/// ]
/// ```
public struct SVCategory: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let color: Color

    /// Creates a new category.
    /// - Parameters:
    ///   - name: The display name for this category (shown in legend and detail view)
    ///   - color: The color used for this category's bar segments
    public init(name: String, color: Color) {
        self.id = UUID()
        self.name = name
        self.color = color
    }

    /// Creates a new category with a hex color string.
    /// - Parameters:
    ///   - name: The display name for this category
    ///   - colorHex: A hex color string (e.g., "#FF5733" or "FF5733")
    public init(name: String, colorHex: String) {
        self.id = UUID()
        self.name = name
        self.color = Color(hex: colorHex)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: SVCategory, rhs: SVCategory) -> Bool {
        lhs.id == rhs.id
    }
}
