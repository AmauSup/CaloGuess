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
                Spacer()
                // Ici tu peux mettre un GIF avec une librairie,
                // ou le ProgressView natif qui est très propre :
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Recherche des produits...")
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                List(store.searchResults) { product in
                    NavigationLink(destination: ProductDetailView(product: product, onAddToBasket: {
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
