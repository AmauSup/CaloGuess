import SwiftUI
import SwiftData



struct ContentView: View {
    @State private var store = FoodStore()
    
    var body: some View {
        // La NavigationStack englobe tout pour permettre le scroll et la navigation fluide
        NavigationStack {
            TabView {
                SearchView(store: store)
                    .tabItem {
                        Label("Recherche", systemImage: "magnifyingglass")
                    }
                
                // Tes autres onglets ici...
                Text("Page Somme")
                    .tabItem { Label("Calcul", systemImage: "plus.forwardslash.minus") }
                
                Text("Page Jeu")
                    .tabItem { Label("Jeu", systemImage: "gamecontroller") }
            }
            .navigationTitle("NutriSwift")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
