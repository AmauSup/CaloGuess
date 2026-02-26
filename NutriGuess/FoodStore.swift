import SwiftUI
import Observation

struct BasketItem: Identifiable {
    let id = UUID()
    let product: ProductAPI
    var quantity: Int
}

@Observable
class FoodStore {
    var searchResults: [ProductAPI] = []
    var basket: [BasketItem] = []
    var isLoading: Bool = false
    var hasSearched = false

    func search(query: String) async {
        guard !query.isEmpty else { return }
        
        await MainActor.run {
            self.isLoading = true
            self.hasSearched = true
        }
        
        let urlString = "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&json=true&fields=product_name,brands,quantity,image_url,nutriscore_grade,nova_group,ecoscore_grade,ingredients_text,nutriments"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenFoodResponse.self, from: data)
            
            await MainActor.run {
                self.searchResults = response.products
                self.isLoading = false
            }
        } catch {
            await MainActor.run { self.isLoading = false }
            print("Erreur : \(error)")
        }
    }

    func loadInitialProducts() async {
        await search(query: "biscuits")
    }
    
    var totalCalories: Double {
        basket.reduce(0) { $0 + (($1.product.calories ?? 0) * Double($1.quantity)) }
    }
    
    func addToBasket(_ product: ProductAPI) {
        if let index = basket.firstIndex(where: { $0.product.name == product.name }) {
            basket[index].quantity += 1
        } else {
            basket.append(BasketItem(product: product, quantity: 1))
        }
    }
    struct OpenFoodResponse: Codable {
        let products: [ProductAPI]
    }
}
