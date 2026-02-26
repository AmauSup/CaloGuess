import SwiftUI

struct SearchView: View {
    @Bindable var store: FoodStore
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("Rechercher...", text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .onSubmit { Task { await store.search(query: text) } }

            if store.isLoading {
                ProgressView("Recherche en cours...")
            } else if store.hasSearched && store.searchResults.isEmpty {
                // Ce bloc s'affiche uniquement si une recherche a été faite ET n'a rien trouvé
                ContentUnavailableView(
                    "Produit pas trouvé",
                    systemImage: "magnifyingglass",
                    description: Text("Essayez un autre mot-clé.")
                )
            } else {
                List(store.searchResults) { product in
                    NavigationLink(destination: ProductDetailView(product: product, store: store, onAddToBasket: {
                        store.addToBasket(product)
                    })) {
                        ProductRow(item: product)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
