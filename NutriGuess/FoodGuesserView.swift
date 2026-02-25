
import SwiftUI

struct FoodGuesserView: View {
    @Bindable var store: FoodStore
    @State private var currentProduct: ProductAPI?
    @State private var userGuess: Double = 250
    @State private var showResult = false
    @State private var message = ""

    var body: some View {
        VStack(spacing: 30) {
            if let product = currentProduct {
                Text("Combien de calories pour 100g ?")
                    .font(.headline)
                
                // Image du produit mystère
                AsyncImage(url: URL(string: product.imageURL ?? "")) { $0.resizable().scaledToFit() } placeholder: { ProgressView() }
                    .frame(height: 200)
                    .cornerRadius(15)
                
                Text(product.name)
                    .font(.title2).bold()

                // Le Curseur (Interface Dynamique avec Binding)
                VStack {
                    Text("\(Int(userGuess)) kcal")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    
                    Slider(value: $userGuess, in: 0...800, step: 5)
                        .padding(.horizontal)
                }

                Button("Valider mon estimation") {
                    checkResult()
                }
                .buttonStyle(.borderedProminent)
                .alert(message, isPresented: $showResult) {
                    Button("Suivant", action: nextRound)
                }
                
            } else {
                ContentUnavailableView("Lancez une recherche d'abord", systemImage: "gamecontroller", description: Text("Le jeu utilise les produits de vos recherches."))
                    .onAppear { nextRound() }
            }
        }
        .padding()
    }

    func checkResult() {
        guard let actual = currentProduct?.calories else { return }
        let difference = abs(actual - userGuess)
        
        if difference < 20 {
            message = "Excellent ! C'était \(Int(actual)) kcal."
        } else if difference < 100 {
            message = "Pas mal ! La réponse était \(Int(actual)) kcal."
        } else {
            message = "Oups... C'était \(Int(actual)) kcal."
        }
        showResult = true
    }

    func nextRound() {
        currentProduct = store.searchResults.randomElement()
        userGuess = 250
    }
}
