
import SwiftUI

struct FoodGuesserView: View {
    @Bindable var store: FoodStore
    @State private var currentProduct: ProductAPI?
    @State private var userGuess: Double = 250
    @State private var showResult = false
    @State private var message = ""
    @State private var gameStarted = false // État pour savoir si on est dans le jeu

    var body: some View {
        NavigationStack {
            VStack {
                if !gameStarted {
                    // ÉCRAN D'ACCUEIL DU JEU
                    VStack(spacing: 20) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                        
                        Text("Nutri Guess")
                            .font(.largeTitle).bold()
                        
                        Text("Devinez les calories des produits !")
                            .foregroundColor(.secondary)

                        Button(action: {
                            Task {
                                if store.searchResults.isEmpty {
                                    await $store.loadInitialProducts
                                }
                                nextRound()
                                gameStarted = true
                            }
                        }) {
                            Text("Lancer le jeu")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        .padding(.horizontal, 40)
                    }
                } else if let product = currentProduct {
                    // ÉCRAN DE JEU ACTIF
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: product.imageURL ?? "")) { img in
                            img.resizable().scaledToFit()
                        } placeholder: { ProgressView() }
                        .frame(height: 200)
                        .cornerRadius(15)

                        Text(product.name)
                            .font(.title3).bold().multilineTextAlignment(.center)

                        VStack {
                            Text("\(Int(userGuess)) kcal")
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                                .foregroundColor(.orange)
                            
                            Slider(value: $userGuess, in: 0...800, step: 5)
                                .tint(.orange)
                        }
                        .padding()

                        Button("Valider") { checkResult() }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Arrêter") { gameStarted = false }
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(gameStarted ? "Quel est le score ?" : "")
            .alert(message, isPresented: $showResult) {
                Button("Continuer", action: nextRound)
                Button("Quitter", action: { gameStarted = false })
            }
        }
    }

    func checkResult() {
        guard let actual = currentProduct?.calories else { return }
        let diff = abs(actual - userGuess)
        message = diff < 30 ? "Bravo ! C'était \(Int(actual)) kcal" : "Raté ! C'était \(Int(actual)) kcal"
        showResult = true
    }

    func nextRound() {
        currentProduct = store.searchResults.randomElement()
        userGuess = 250
    }
}
