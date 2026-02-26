import SwiftUI
struct BasketView: View {
    @Bindable var store: FoodStore

    var body: some View {
        List {
            ForEach($store.basket) { $item in
                HStack(spacing: 12) {
                    ProductRow(item: item.product)
                        .opacity(item.quantity == 0 ? 0.5 : 1.0)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: { if item.quantity > 0 { item.quantity -= 1 } }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(item.quantity > 0 ? .blue : .gray)
                        }

                        Text("\(item.quantity)")
                            .font(.system(.body, design: .monospaced))
                            .frame(width: 25)

                        Button(action: { item.quantity += 1 }) {
                            Image(systemName: "plus.circle").foregroundColor(.blue)
                        }
                        
                        Divider().frame(height: 20).padding(.horizontal, 2)
                        
                        // CORRECTION ICI : On utilise item.id (valeur) et non le binding
                        Button(action: {
                            let idToDelete = item.id
                            withAnimation {
                                store.basket.removeAll(where: { $0.id == idToDelete })
                            }
                        }) {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                    }
                    .buttonStyle(.borderless)
                }
            }
            .onDelete { offsets in
                store.basket.remove(atOffsets: offsets)
            }
            
            Section {
                HStack {
                    Text("Total :").bold()
                    Spacer()
                    Text("\(Int(store.totalCalories)) kcal").bold().foregroundColor(.orange)
                }
            }
        }
        .navigationTitle("Calculateur")
    }
}
