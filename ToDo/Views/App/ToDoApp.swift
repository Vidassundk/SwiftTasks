//
//  ToDoApp.swift
//  ToDo
//

import SwiftUI
import SwiftData

@main
struct ToDoApp: App {
    private let modelContainer: ModelContainer = {
        let schema = Schema([Item.self])

        // ❌ in-memory (volatile)
        // let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        // ✅ on-disk (persists between launches)
        let config = ModelConfiguration(schema: schema)

        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
