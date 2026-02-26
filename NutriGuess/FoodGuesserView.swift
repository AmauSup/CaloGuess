import SwiftUI
import SwiftUI

struct FoodGuesserView: View {
    @Bindable var store: FoodStore
    @State private var currentProduct: ProductAPI?
    @State private var userGuess: Double = 450
    @State private var message = ""
    @State private var gameStarted = false
    @State private var isPreparingGame = false
    @State private var hasAnswered = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.orange.opacity(0.1), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                if isPreparingGame {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Préparation du défi...").font(.system(.body, design: .rounded))
                    }
                } else if !gameStarted {
                    VStack(spacing: 30) {
                        ZStack {
                            Circle().fill(Color.orange.opacity(0.2)).frame(width: 160)
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.orange)
                        }
                        
                        VStack(spacing: 10) {
                            Text("Nutri Guess").font(.system(size: 40, weight: .black, design: .rounded))
                            Text("Devinez les calories pour 100g").font(.system(.subheadline, design: .rounded)).foregroundColor(.secondary)
                        }
                        
                        Button(action: startGame) {
                            Text("Commencer")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        .clipShape(Capsule())
                        .padding(.horizontal, 50)
                        .shadow(color: .orange.opacity(0.3), radius: 10, y: 5)
                    }
                } else if let product = currentProduct {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            
                            VStack(spacing: 0) {
                                AsyncImage(url: URL(string: product.imageURL ?? "")) { img in
                                    img.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 220)
                                .cornerRadius(20)
                                .padding()
                                
                                Text(product.name)
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .padding([.horizontal, .bottom])
                            }
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 10)
                            .padding(.horizontal)

                            VStack(spacing: 20) {
                                if hasAnswered {
                                    Text(message)
                                        .font(.system(.title2, design: .rounded, weight: .heavy))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                                } else {
                                    VStack {
                                        Text("\(Int(userGuess))")
                                            .font(.system(size: 60, weight: .black, design: .rounded))
                                            .foregroundColor(.orange)
                                        
                                        Text("kcal / 100g")
                                            .font(.system(.caption, design: .rounded).bold())
                                            .foregroundColor(.secondary)
                                        
                                        Slider(value: $userGuess, in: 0...900, step: 1)
                                            .tint(.orange)
                                            .padding(.top)
                                    }
                                }
                            }
                            .padding(30)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(25)
                            .padding(.horizontal)

                            HStack(spacing: 20) {
                                Button(action: { gameStarted = false }) {
                                    Image(systemName: "xmark").bold()
                                        .frame(width: 60, height: 60)
                                        .background(Color.red.opacity(0.1))
                                        .foregroundColor(.red)
                                        .clipShape(Circle())
                                }

                                if hasAnswered {
                                    Button(action: nextRound) {
                                        Text("Suivant")
                                            .font(.system(.headline, design: .rounded).bold())
                                            .frame(maxWidth: .infinity, maxHeight: 60)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.blue)
                                    .clipShape(Capsule())
                                } else {
                                    Button(action: checkResult) {
                                        Text("Valider")
                                            .font(.system(.headline, design: .rounded).bold())
                                            .frame(maxWidth: .infinity, maxHeight: 60)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.green)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
    }

    func startGame() {
        Task {
            isPreparingGame = true
            await store.loadGameData()
            
            print("Produits reçus : \(store.gameProducts.count)")
            
            let playable = store.gameProducts.filter { ($0.calories ?? 0) > 0 }
            
            if !playable.isEmpty {
                withAnimation {
                    nextRound()
                    gameStarted = true
                }
            } else {
               
                print("Erreur : Aucun produit valide. Vérifiez la connexion ou l'API.")
            }
            isPreparingGame = false
        }
    }

    func checkResult() {
        let actual = currentProduct?.calories ?? 900
        let diff = abs(actual - userGuess)
        
        withAnimation(.spring()) {
            if diff < 30 {
                message = "Excellent ! C'était \(Int(actual)) kcal"
            } else if diff < 100 {
                message = "Pas mal ! C'était \(Int(actual)) kcal"
            } else {
                message = "Oups... C'était \(Int(actual)) kcal"
            }
            hasAnswered = true
        }
    }

    func nextRound() {
        withAnimation {
            hasAnswered = false
            userGuess = 450
            let playableProducts = store.gameProducts.filter { ($0.calories ?? 0) > 0 }
            
            if let randomProduct = playableProducts.randomElement() {
                currentProduct = randomProduct
            } else {
                gameStarted = false
            }
        }
    }
}
