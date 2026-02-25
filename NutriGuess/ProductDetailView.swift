import SwiftUI

struct ProductDetailView: View {
    let product: ProductAPI
    var onAddToBasket: () -> Void
    var body: some View {
        List {
            // 1. IDENTITÉ
            Section {
                AsyncImage(url: URL(string: product.imageURL ?? "")) { img in
                    img.resizable().scaledToFit()
                } placeholder: { ProgressView() }
                .frame(maxWidth: .infinity, maxHeight: 200)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.name).font(.title2).bold()
                    Text(product.brand ?? "Marque inconnue").foregroundColor(.secondary)
                    Text("Quantité : \(product.quantity ?? "N/A")").font(.caption)
                }
            }
            Section {
                            Button(action: {
                                onAddToBasket()
                            }) {
                                Label("Ajouter au panier", systemImage: "cart.badge.plus")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        }
            // 2. SCORES DE SYNTHÈSE
            Section("Scores") {
                HStack(spacing: 20) {
                    ScoreBadge(label: "Nutri", value: product.nutriScore?.uppercased() ?? "?", color: .green)
                    ScoreBadge(label: "NOVA", value: "\(product.novaGroup ?? 0)", color: .orange)
                    ScoreBadge(label: "Eco", value: product.ecoScore?.uppercased() ?? "?", color: .blue)
                }
                .frame(maxWidth: .infinity)
            }
            
            // 3. VALEURS NUTRITIONNELLES (Pour 100g)
            Section("Valeurs pour 100g") {
                NutrientRow(label: "Calories", value: "\(Int(product.calories ?? 0)) kcal", color: .primary)
                NutrientRow(label: "Protéines", value: "\(product.nutriments?.proteins ?? 0) g", color: .red)
                NutrientRow(label: "Glucides", value: "\(product.nutriments?.carbohydrates ?? 0) g", subValue: "dont sucres: \(product.nutriments?.sugars ?? 0)g")
                NutrientRow(label: "Matières grasses", value: "\(product.nutriments?.fat ?? 0) g", subValue: "dont saturés: \(product.nutriments?.saturatedFat ?? 0)g")
                NutrientRow(label: "Fibres", value: "\(product.nutriments?.fiber ?? 0) g", color: .green)
                NutrientRow(label: "Sel", value: "\(product.nutriments?.salt ?? 0) g", color: .orange)
            }
            
            // 4. COMPOSITION
            Section("Composition & Alertes") {
                if let allergens = product.allergens, !allergens.isEmpty {
                    Text("⚠️ Allergènes : \(allergens)").font(.footnote).foregroundColor(.red)
                }
                Text("Ingrédients : \(product.ingredients ?? "Non listés")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
        }
        .navigationTitle("Détails")
    }
}

// Sous-composants pour la clarté
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
