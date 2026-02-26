
import SwiftUI
struct FoodGuesserView: View {
    @Bindable var store: FoodStore
    @State private var currentProduct: ProductAPI?
    @State private var userGuess: Double = 250
    @State private var showResult = false
    @State private var message = ""
    @State private var gameStarted = false
    @State private var isPrepatingGame = false

    var body: some View {
        NavigationStack {
            VStack {
                if isPrepatingGame {
                    VStack {
                        ProgressView()
                        Text("Chargement des produits...").padding()
                    }
                } else if !gameStarted {
                    VStack(spacing: 20) {
                        Image(systemName: "fork.knife.circle.fill").font(.system(size: 80)).foregroundColor(.orange)
                        Text("Nutri Guess").font(.largeTitle).bold()
                        
                        Button(action: {
                            Task {
                                isPrepatingGame = true
                                await store.loadGameData()
                                isPrepatingGame = false
                                nextRound()
                                gameStarted = true
                            }
                        }) {
                            Text("Lancer le jeu").bold().padding().frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent).tint(.orange).padding(.horizontal, 40)
                    }
                } else if let product = currentProduct {
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: product.imageURL ?? "")) { img in
                            img.resizable().scaledToFit()
                        } placeholder: { ProgressView() }
                        .frame(height: 200).cornerRadius(15)

                        Text(product.name).font(.title3).bold().multilineTextAlignment(.center)

                        VStack {
                            Text("\(Int(userGuess)) kcal").font(.system(size: 45, weight: .bold, design: .rounded)).foregroundColor(.orange)
                            Slider(value: $userGuess, in: 0...800, step: 5).tint(.orange)
                        }.padding()

                        Button("Valider") {
                            checkResult() // Calculer le message PUIS afficher
                        }
                        .buttonStyle(.borderedProminent).controlSize(.large)
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Quitter") { gameStarted = false }.foregroundColor(.red)
                        }
                    }
                }
            }
            // Utilisation d'une version plus stable de l'alerte
            .alert("Résultat", isPresented: $showResult) {
                Button("Continuer", action: nextRound)
                Button("Arrêter", action: { gameStarted = false })
            } message: {
                Text(message)
            }
        }
    }

    func checkResult() {
        guard let actual = currentProduct?.calories else { return }
        let diff = abs(actual - userGuess)
        
        // On prépare le message d'abord
        if diff < 30 {
            message = "Excellent ! C'était \(Int(actual)) kcal."
        } else if diff < 100 {
            message = "Pas mal ! C'était \(Int(actual)) kcal."
        } else {
            message = "Oups ! C'était \(Int(actual)) kcal."
        }
        
        // On déclenche l'affichage
        showResult = true
    }

    func nextRound() {
        currentProduct = store.gameProducts.randomElement()
        userGuess = 250
    }
}
