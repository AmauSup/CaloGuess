
import SwiftUI
import Observation
import SwiftData

@Observable
class FoodStore {
    var searchResults: [ProductAPI] = []
    var gameProducts: [ProductAPI] = []
    var isLoading: Bool = false
    var hasSearched = false

    func search(query: String) async {
        guard !query.isEmpty else { return }
        await MainActor.run { self.isLoading = true; self.hasSearched = true }
        let results = await performFetch(query: query)
        await MainActor.run { self.searchResults = results; self.isLoading = false }
    }

    func loadGameData() async {
        let themes = ["pizza", "burger", "salade", "fruit", "dessert", "chocolat"]
        let randomTheme = themes.randomElement() ?? "snack"
        let results = await performFetch(query: randomTheme)
        await MainActor.run { self.gameProducts = results }
    }

    private func performFetch(query: String) async -> [ProductAPI] {
        let urlString = "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&json=true&fields=product_name,brands,quantity,image_url,nutriscore_grade,nova_group,ecoscore_grade,ingredients_text,nutriments"
        guard let url = URL(string: urlString) else { return [] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenFoodResponse.self, from: data)
            return response.products
        } catch {
            return []
        }
    }

    struct OpenFoodResponse: Codable {
        let products: [ProductAPI]
    }
    
  
}
