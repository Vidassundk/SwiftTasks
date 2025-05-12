//  Item.swift
//  ToDo
//
//  The domain model that represents one task in the to‑do list.
//  Marked with `@Model` so SwiftData generates persistence boiler‑plate.
//
//  Created by ChatGPT on 2025-05-12.
//

import Foundation
import SwiftData

/// A single to‑do task.
///
/// `@Model` makes SwiftData generate a lightweight Core Data–like
/// persistence layer behind the scenes.  Each stored property becomes
/// a column in the underlying SQLite table, and every `Item` instance
/// automatically receives an `id` used by SwiftUI’s `ForEach`.
@Model
final class Item {

    // MARK: - Stored properties

    /// The user‑visible title of the task.
    var title: String

    /// Creation or due date.  (You could rename it and index it for sorting.)
    var timestamp: Date

    /// Whether the task is marked important.  Drives the red “❗️” badge in the UI.
    var isCritical: Bool

    /// Whether the task has been completed.  Drives the green “✔︎” badge.
    var isCompleted: Bool

    // MARK: - Initialiser

    /// Convenience initialiser with sensible defaults
    /// so we can create `Item()` without arguments in previews.
    ///
    /// - Parameters:
    ///   - title:        Text shown in the list.
    ///   - timestamp:    Defaults to *now*.
    ///   - isCritical:   Shows a red badge in the row.
    ///   - isCompleted:  Toggles strikethrough + green badge.
    init(
        title: String = "",
        timestamp: Date = .now,
        isCritical: Bool = false,
        isCompleted: Bool = false
    ) {
        self.title       = title
        self.timestamp   = timestamp
        self.isCritical  = isCritical
        self.isCompleted = isCompleted
    }
}
