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
                ProgressView("Recherche...")
            } else if store.searchResults.isEmpty && store.hasSearched {
                // Message si la recherche n'a rien donné
                ContentUnavailableView(
                    "Produit pas trouvé",
                    systemImage: "exclamationmark.magnifyingglass",
                    description: Text("Vérifiez l'orthographe ou essayez un autre mot.")
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
