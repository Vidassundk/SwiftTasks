//  ContentView.swift
//  ToDo
//
//  Top‑level screen that owns the list, dark‑mode toggle,
//  and the “new item” form.
//
//  Created by ChatGPT on 2025-05-12.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    // MARK: - Environment / State

    @Environment(\.modelContext) private var modelContext       // SwiftData context
    @Query private var items: [Item]                             // live query

    #if os(iOS)
    @Environment(\.editMode) private var editMode               // bound to EditButton
    #endif

    @State private var showingAddItem = false                    // sheet visibility

    // Fields bound to the “New To‑Do” form
    @State private var newTitle       = ""
    @State private var newDate        = Date.now
    @State private var newIsCritical  = false
    @State private var newIsCompleted = false

    // Dark‑mode persists with @AppStorage, shared across launches
    @AppStorage("isDarkMode") private var isDarkMode = false

    // MARK: - Body

    var body: some View {
        NavigationSplitView {

            // 1. Master column – the list
            List {
                ForEach(items) { item in
                    ToDoRow(item: item)
                        #if os(iOS)
                        // Force view refresh when edit‑mode changes
                        .id("\(item.id)-\(editMode?.wrappedValue == .active)")
                        #endif
                }
                #if os(iOS)
                // Built‑in delete via minus handle
                .onDelete { delete($0) }
                #endif
            }
            #if os(macOS)
            // Make the master column narrower on Mac
            .navigationSplitViewColumnWidth(min: 180, ideal: 220)
            #endif
            .toolbar { toolbar }                                   // top toolbars
            .sheet(isPresented: $showingAddItem) { newItemSheet }  // modal form

        } detail: {

            // 2. Detail column placeholder
            Text("Select an item")
                .font(.title2)
                .foregroundStyle(.secondary)
                .preferredColorScheme(isDarkMode ? .dark : .light)

        }
        // Entire split‑view adopts the chosen color‑scheme
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // MARK: - Toolbar definition

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {

        #if os(iOS)
        // Leading: dark‑/light‑mode toggle
        ToolbarItem(placement: .navigationBarLeading) {
            darkModeButton
        }
        // Trailing: system EditButton toggles edit‑mode
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        #else   // macOS
        ToolbarItem { darkModeButton }
        #endif

        // Trailing: plus button (both platforms)
        ToolbarItem {
            Button { showingAddItem = true } label: {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    // MARK: - Dark‑mode button

    private var darkModeButton: some View {
        Button { isDarkMode.toggle() } label: {
            Image(systemName: isDarkMode ? "sun.max.fill"
                                         : "moon.fill")
        }
        .accessibilityLabel(isDarkMode ? "Switch to Light Mode"
                                       : "Switch to Dark Mode")
    }

    // MARK: - “New item” sheet

    private var newItemSheet: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $newTitle)
                    DatePicker("Date",
                               selection: $newDate,
                               displayedComponents: [.date, .hourAndMinute])
                }
                Section("Flags") {
                    Toggle("Critical",  isOn: $newIsCritical)
                    Toggle("Completed", isOn: $newIsCompleted)
                }
            }
            .navigationTitle("New To‑Do")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { resetForm(); showingAddItem = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addItem(); resetForm(); showingAddItem = false
                    }
                    .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // MARK: - CRUD helpers

    /// Inserts a new `Item` using the form’s bound fields.
    private func addItem() {
        withAnimation {
            modelContext.insert(
                Item(title: newTitle,
                     timestamp: newDate,
                     isCritical: newIsCritical,
                     isCompleted: newIsCompleted)
            )
        }
    }

    #if os(iOS)
    /// Called by `.onDelete` when the user swipes‑to‑delete or
    /// taps the minus handle in edit‑mode.
    private func delete(_ offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(modelContext.delete)
        }
    }
    #endif

    /// Resets the form back to its initial blank state.
    private func resetForm() {
        newTitle = ""
        newDate  = .now
        newIsCritical  = false
        newIsCompleted = false
    }
}
