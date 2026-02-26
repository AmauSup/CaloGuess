import SwiftUI
import Observation
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
    var gameProducts: [ProductAPI] = [] // Données dédiées au jeu
    var basket: [BasketItem] = []
    var isLoading: Bool = false
    var hasSearched = false

    // Recherche classique pour la page Search
    func search(query: String) async {
        guard !query.isEmpty else { return }
        await MainActor.run {
            self.isLoading = true
            self.hasSearched = true
        }
        let results = await performFetch(query: query)
        await MainActor.run {
            self.searchResults = results
            self.isLoading = false
        }
    }

    // Chargement dédié au Guesser (Aléatoire/Thématique)
    func loadGameData() async {
        let themes = ["pizza", "burger", "salade", "fruit", "dessert", "chocolat"]
        let randomTheme = themes.randomElement() ?? "snack"
        let results = await performFetch(query: randomTheme)
        await MainActor.run {
            self.gameProducts = results
        }
    }

    // Fonction interne de fetch pour éviter la répétition
    private func performFetch(query: String) async -> [ProductAPI] {
        let urlString = "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&json=true&fields=product_name,brands,quantity,image_url,nutriscore_grade,nova_group,ecoscore_grade,ingredients_text,nutriments"
        
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // C'est ici qu'on utilise OpenFoodResponse
            let response = try JSONDecoder().decode(OpenFoodResponse.self, from: data)
            return response.products
        } catch {
            print("Erreur de décodage: \(error)")
            return []
        }
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

    // --- LA STRUCTURE MANQUANTE EST ICI ---
    struct OpenFoodResponse: Codable {
        let products: [ProductAPI]
    }
}
