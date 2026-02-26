import SwiftUI
import SwiftData

struct ProductDetailView: View {
    let product: ProductAPI
    @Bindable var store: FoodStore
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var basketItems: [BasketItem]
    
    @State private var animateButton = false
    @Environment(\.dismiss) var dismiss

    var currentCount: Int {
        basketItems.first(where: { $0.productName == product.name })?.quantity ?? 0
    }

    var body: some View {
        List {
            Section {
                AsyncImage(url: URL(string: product.imageURL ?? "")) { img in
                    img.resizable().scaledToFit()
                } placeholder: { ProgressView() }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.name).font(.title2).bold()
                    Text(product.brand ?? "Marque inconnue").foregroundColor(.secondary)
                }
            }

            Section {
                Button(action: {
                    addToBasket()
                }) {
                    VStack(spacing: 4) {
                        Label("Ajouter au panier", systemImage: "cart.badge.plus")
                            .font(.headline)
                        
                        if currentCount > 0 {
                            Text("Déjà \(currentCount) dans le panier")
                                .font(.caption2)
                                .italic()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .scaleEffect(animateButton ? 0.9 : 1.0)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            
            Section("Scores") {
                HStack(spacing: 20) {
                    ScoreBadge(label: "Nutri", value: product.nutriScore?.uppercased() ?? "?", color: .green)
                    ScoreBadge(label: "NOVA", value: "\(product.novaGroup ?? 0)", color: .orange)
                    ScoreBadge(label: "Eco", value: product.ecoScore?.uppercased() ?? "?", color: .blue)
                }
                .frame(maxWidth: .infinity)
            }
            
            Section("Valeurs pour 100g") {
                NutrientRow(label: "Calories", value: "\(Int(product.calories ?? 0)) kcal", color: .primary)
                NutrientRow(label: "Protéines", value: "\(product.nutriments?.proteins ?? 0) g", color: .red)
                NutrientRow(label: "Glucides", value: "\(product.nutriments?.carbohydrates ?? 0) g", subValue: "dont sucres: \(product.nutriments?.sugars ?? 0)g")
                NutrientRow(label: "Matières grasses", value: "\(product.nutriments?.fat ?? 0) g", subValue: "dont saturés: \(product.nutriments?.saturatedFat ?? 0)g")
                NutrientRow(label: "Fibres", value: "\(product.nutriments?.fiber ?? 0) g", color: .green)
                NutrientRow(label: "Sel", value: "\(product.nutriments?.salt ?? 0) g", color: .orange)
            }
            
            Section("Composition & Alertes") {
                if let allergens = product.allergens, !allergens.isEmpty {
                    Text("Allergènes : \(allergens)").font(.footnote).foregroundColor(.red)
                }
                Text("Ingrédients : \(product.ingredients ?? "Non listés")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Détails")
    }
    
    private func addToBasket() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            animateButton = true
        }
        
        if let existingItem = basketItems.first(where: { $0.productName == product.name }) {
            existingItem.quantity += 1
        } else {
            let newItem = BasketItem(product: product, quantity: 1)
            modelContext.insert(newItem)
        }
        
        try? modelContext.save()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animateButton = false
        }
    }
}

struct ScoreBadge: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack {
            Text(label).font(.caption2).bold()
            Text(value).font(.title3).bold()
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct NutrientRow: View {
    let label: String; let value: String; var subValue: String? = nil; var color: Color = .primary
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Spacer()
                Text(value).bold().foregroundColor(color)
            }
            if let sub = subValue {
                Text(sub).font(.caption2).foregroundColor(.secondary)
            }
        }
    }
}
