import SwiftUI

struct ProductRow: View {
    let item: any FoodItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.imageURL ?? "")) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(Int(item.calories ?? 0)) kcal / 100g")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
