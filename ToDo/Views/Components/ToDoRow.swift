//  ToDoRow.swift
//  ToDo
//
//  One reusable list row that supports:
//  • Tap‑to‑delete when the list is in edit‑mode (iOS)
//  • Swipe‑to‑delete (leading) & swipe‑to‑complete (trailing)
//
//  Created by ChatGPT on 2025-05-12.
//

import SwiftUI
import SwiftData

struct ToDoRow: View {
    @Environment(\.modelContext) private var modelContext       // persistence context

    #if os(iOS)
    @Environment(\.editMode) private var editMode               // supplied by EditButton
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    #else
    private let isEditing = false                                // macOS has no edit‑mode
    #endif

    let item: Item                                               // task to display

    // MARK: - View

    var body: some View {
        Group {
            if isEditing {
                // In edit‑mode we disable navigation and make the whole row tappable.
                rowBody
                    .contentShape(Rectangle())                   // enlarge tap target
            } else {
                // Normal navigation link into DetailView
                NavigationLink { DetailView(item: item) } label: { rowBody }
            }
        }
        #if os(iOS)
        .when(!isEditing) { view in                              // gestures only outside edit‑mode
            view
                .swipeActions(edge: .leading, allowsFullSwipe: true) { deleteButton }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) { completeButton }
        }
        #endif
    }

    // MARK: - Row visual

    private var rowBody: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title.isEmpty ? "No Title" : item.title)
                    .font(.headline)
                    .strikethrough(item.isCompleted, color: .gray)

                Text(item.timestamp, format: .dateTime)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if item.isCritical {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
            }
            if item.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Actions

    /// Removes the item from persistence with animation
    private func delete() {
        withAnimation { modelContext.delete(item) }
    }

    /// Toggles `isCompleted` and persists automatically
    private func toggleComplete() {
        withAnimation { item.isCompleted.toggle() }
    }

    #if os(iOS)
    /// Swipe gesture – red destructive button
    private var deleteButton: some View {
        Button(role: .destructive, action: delete) {
            Label("Delete", systemImage: "trash")
        }
    }

    /// Swipe gesture – green/orange toggle button
    private var completeButton: some View {
        Button(action: toggleComplete) {
            Label(item.isCompleted ? "Undo" : "Done",
                  systemImage: item.isCompleted ? "arrow.uturn.left"
                                                : "checkmark.circle")
        }
        .tint(item.isCompleted ? .orange : .green)
    }
    #endif
}
