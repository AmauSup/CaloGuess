import SwiftUI
import SwiftData

struct SearchView: View {
    @Bindable var store: FoodStore
    @State private var text = ""

    var body: some View {
        VStack(spacing: 0) {
            
            TextField("Rechercher...", text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .onSubmit { Task { await store.search(query: text) } }

            Group {
                if store.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Recherche en cours...")
                        Spacer()
                    }
                } else if store.hasSearched && store.searchResults.isEmpty {
                    ContentUnavailableView(
                        "Produit pas trouvé",
                        systemImage: "magnifyingglass",
                        description: Text("Essayez un autre mot-clé.")
                    )
                } else {
                    List(store.searchResults) { product in
                        NavigationLink(destination: ProductDetailView(product: product, store: store)) {
                            ProductRow(item: product)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            
            if !store.hasSearched && !store.isLoading {
                Spacer()
            }
        }
    }
}
