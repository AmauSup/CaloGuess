import Foundation
import SwiftData

protocol FoodItem {
    var name: String { get }
    var calories: Double? { get }
    var imageURL: String? { get }
}

struct ProductAPI: Codable, FoodItem, Identifiable {
    let id = UUID()
    let name: String
    let brand: String?
    let quantity: String?
    let imageURL: String?
    
    let nutriScore: String?
    let novaGroup: Int?
    let ecoScore: String?
    
    let ingredients: String?
    let allergens: String?
    
    let nutriments: Nutriments?

    var calories: Double? { nutriments?.calories }

    enum CodingKeys: String, CodingKey {
        case name = "product_name", brand = "brands", quantity, imageURL = "image_url"
        case nutriScore = "nutriscore_grade", novaGroup = "nova_group", ecoScore = "ecoscore_grade"
        case ingredients = "ingredients_text", allergens = "allergens_from_ingredients"
        case nutriments
    }
}

struct Nutriments: Codable {
    let calories: Double?
    let proteins: Double?
    let fat: Double?
    let saturatedFat: Double?
    let carbohydrates: Double?
    let sugars: Double?
    let fiber: Double?
    let salt: Double?

    enum CodingKeys: String, CodingKey {
        case calories = "energy-kcal_100g"
        case proteins = "proteins_100g"
        case fat = "fat_100g"
        case saturatedFat = "saturated-fat_100g"
        case carbohydrates = "carbohydrates_100g"
        case sugars = "sugars_100g"
        case fiber = "fiber_100g"
        case salt = "salt_100g"
    }
}

@Model
class SavedProduct: FoodItem {
    var name: String
    var calories: Double?
    var imageURL: String?
    
    init(name: String, calories: Double?, imageURL: String?) {
        self.name = name
        self.calories = calories
        self.imageURL = imageURL
    }
}
