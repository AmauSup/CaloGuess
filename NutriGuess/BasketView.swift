import SwiftUI
import SwiftData


struct BasketView: View {
    @Bindable var store: FoodStore
    @Query var items: [BasketItem]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                if items.isEmpty {
                    ContentUnavailableView("Panier vide", systemImage: "basket", description: Text("Ajoutez des produits pour calculer vos calories."))
                } else {
                    List {
                        ForEach(items) { item in
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.productName)
                                        .font(.system(.headline, design: .rounded))
                                    Text("\(Int(item.calories)) kcal/100g")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    Button(action: { if item.quantity > 0 { item.quantity -= 1 } }) {
                                        Image(systemName: "minus").font(.system(size: 12, weight: .bold))
                                            .padding(8).background(Color.gray.opacity(0.1)).clipShape(Circle())
                                    }
                                    
                                    Text("\(item.quantity)").font(.system(.body, design: .monospaced).bold())
                                    
                                    Button(action: { item.quantity += 1 }) {
                                        Image(systemName: "plus").font(.system(size: 12, weight: .bold))
                                            .padding(8).background(Color.orange.opacity(0.1)).foregroundColor(.orange).clipShape(Circle())
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                Button(role: .destructive) {
                                    modelContext.delete(item)
                                } label: {
                                    Image(systemName: "trash").foregroundColor(.red).padding(.leading, 5)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 8)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                            )
                        }
                    }
                    .listStyle(.plain)
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("TOTAL").font(.system(.caption, design: .rounded).bold()).foregroundColor(.secondary)
                                Text("\(Int(totalCalories)) kcal").font(.system(.title, design: .rounded, weight: .black))
                            }
                            Spacer()
                            Image(systemName: "flame.fill").foregroundColor(.orange).font(.title)
                        }
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Calculateur")
    }
    
    var totalCalories: Double {
        items.reduce(0) { $0 + ($1.calories * Double($1.quantity)) }
    }
}
