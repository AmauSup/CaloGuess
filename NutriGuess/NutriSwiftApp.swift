import SwiftUI
import SwiftData

@main
struct NutriSwiftApp: App {
    // On déclare le container pour SwiftData
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([SavedProduct.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
