import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var store = FoodStore()

    var body: some View {
        NavigationStack {
            TabView {
                SearchView(store: store)
                    .tabItem { Label("Recherche", systemImage: "magnifyingglass") }
                
                BasketView(store: store)
                    .tabItem { Label("Mon Panier", systemImage: "basket.fill") }
                
                FoodGuesserView(store: store)
                    .tabItem { Label("Jeu", systemImage: "gamecontroller.fill") }
            }
            .navigationTitle("NutriSwift")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
