import Foundation
import SwiftData

@Model
class BasketItem: Identifiable {
    @Attribute(.unique) var id: UUID
    var productName: String
    var calories: Double
    var quantity: Int
    var imageURL: String?

    init(product: ProductAPI, quantity: Int) {
        self.id = UUID()
        self.productName = product.name
        self.calories = product.calories ?? 0
        self.quantity = quantity
        self.imageURL = product.imageURL
    }
}
