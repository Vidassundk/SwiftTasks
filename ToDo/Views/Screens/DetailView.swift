//  DetailView.swift
//  ToDo
//
//  Shows a single task in larger text.
//
//  Created by ChatGPT on 2025-05-12.
//

import SwiftUI

/// Displays full information about one `Item`.
///
/// The view is *stateless* — it receives an `Item` and shows its data.
/// Any edits to the `Item` propagate automatically thanks to SwiftData’s
/// live objects.
struct DetailView: View {
    let item: Item                                  // injected by caller

    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text(item.title.isEmpty ? "No Title" : item.title)
                .font(.largeTitle)

            // Date
            Text(item.timestamp, format: .dateTime)

            // Badges
            HStack(spacing: 24) {
                Label(
                    item.isCritical ? "Critical" : "Not Critical",
                    systemImage: item.isCritical ? "exclamationmark.circle.fill"
                                                 : "circle"
                )
                Label(
                    item.isCompleted ? "Completed" : "Incomplete",
                    systemImage: item.isCompleted ? "checkmark.circle.fill"
                                                  : "circle"
                )
            }
            .font(.title3)
        }
        .padding()
    }
}
