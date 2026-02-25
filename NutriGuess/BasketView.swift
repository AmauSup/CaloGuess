import SwiftUI

struct BasketView: View {
    @Bindable var store: FoodStore

    var body: some View {
        VStack {
            if store.basket.isEmpty {
                ContentUnavailableView("Panier vide", systemImage: "cart", description: Text("Ajoutez des produits depuis la recherche."))
            } else {
                List {
                    ForEach($store.basket) { $item in
                        HStack {
                            ProductRow(item: item.product)
                            
                            Spacer()
                            
                            // Contrôle des quantités
                            HStack {
                                Button(action: { if item.quantity > 1 { item.quantity -= 1 } }) {
                                    Image(systemName: "minus.circle")
                                }
                                Text("\(item.quantity)")
                                    .frame(width: 30)
                                Button(action: { item.quantity += 1 }) {
                                    Image(systemName: "plus.circle")
                                }
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .onDelete { indexSet in store.basket.remove(atOffsets: indexSet) }
                    
                    Section {
                        HStack {
                            Text("Total Nutritionnel").bold()
                            Spacer()
                            Text("\(Int(store.totalCalories)) kcal")
                                .bold()
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
        .navigationTitle("Calculateur")
    }
}
