import SwiftUI

struct BasketView: View {
    @Bindable var store: FoodStore

    var body: some View {
        VStack {
            if store.basket.isEmpty {
                ContentUnavailableView("Votre panier est vide", systemImage: "cart", description: Text("Ajoutez des produits depuis l'onglet Recherche."))
            } else {
                List {
                    ForEach(store.basket) { item in
                        HStack(spacing: 12) {
                            ProductRow(item: item.product)
                                .opacity(item.quantity == 0 ? 0.5 : 1.0)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    if let index = store.basket.firstIndex(where: { $0.id == item.id }) {
                                        if store.basket[index].quantity > 0 {
                                            store.basket[index].quantity -= 1
                                        }
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(item.quantity > 0 ? .blue : .gray)
                                }

                                Text("\(item.quantity)")
                                    .font(.system(.body, design: .monospaced))
                                    .frame(width: 25)
                                    .foregroundColor(item.quantity == 0 ? .secondary : .primary)

                                Button(action: {
                                    if let index = store.basket.firstIndex(where: { $0.id == item.id }) {
                                        store.basket[index].quantity += 1
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                                
                                Divider().frame(height: 20).padding(.horizontal, 2)
                                
                                Button(action: {
                                    withAnimation {
                                        store.basket.removeAll(where: { $0.id == item.id })
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .onDelete { indexSet in
                        store.basket.remove(atOffsets: indexSet)
                    }

                    Section {
                        HStack {
                            Text("Total :").bold()
                            Spacer()
                            Text("\(Int(store.totalCalories)) kcal")
                                .font(.title3).bold()
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
        .navigationTitle("Calculateur")
    }
}
