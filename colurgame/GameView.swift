import SwiftUI

struct GameView: View {

    let selectedLevel: String

    // MARK: - Game Config
    var maxAttempts: Int {
        switch selectedLevel {
        case "Easy": return 5
        case "Medium": return 7
        case "Hard": return 9
        default: return 5
        }
    }

    var gridSize: Int {
        switch selectedLevel {
        case "Easy": return 3
        case "Medium": return 4
        case "Hard": return 5
        default: return 3
        }
    }

    var totalBoxes: Int { gridSize * gridSize }

    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: gridSize)
    }

    var cardSize: CGFloat {
        switch selectedLevel {
        case "Easy": return 160
        case "Medium": return 130
        case "Hard": return 100
        default: return 130
        }
    }

    // MARK: - State
    @State private var revealed: [Bool]
    @State private var rotation: [Double]
    @State private var remainingAttempts: Int
    @State private var gameMessage: String = ""
    @State private var gameOver: Bool = false
    @State private var didWin: Bool = false
    @State private var selectedColors: [Color] = []
    @State private var showResultBanner: Bool = false


    // MARK: - Init
    init(selectedLevel: String) {
        self.selectedLevel = selectedLevel

        let size: Int
        let attempts: Int

        switch selectedLevel {
        case "Easy":
            size = 3; attempts = 5
        case "Medium":
            size = 4; attempts = 7
        case "Hard":
            size = 5; attempts = 9
        default:
            size = 3; attempts = 5
        }

        _revealed = State(initialValue: Array(repeating: false, count: size * size))
        _rotation = State(initialValue: Array(repeating: 0, count: size * size))
        _remainingAttempts = State(initialValue: attempts)
    }

    // MARK: - Helpers
    var cardImageName: String {
        switch selectedLevel {
        case "Easy": return "fox_card"
        case "Medium": return "pig_card"
        case "Hard": return "dog_card"
        default: return "fox_card"
        }
    }

    func cardColor(index: Int) -> Color {
        switch selectedLevel {
        case "Easy": return [.red, .green, .blue][index % 3]
        case "Medium": return [.orange, .pink, .purple, .teal][index % 4]
        case "Hard": return [.mint, .cyan, .indigo, .brown, .green][index % 5]
        default: return .gray
        }
    }

    func requiredMatchCount() -> Int {
        switch selectedLevel {
        case "Easy": return 3
        case "Medium": return 4
        case "Hard": return 5
        default: return 3
        }
    }

    // MARK: - UI
    var body: some View {
        ZStack {

            Image("level_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 26) {

                    Text("Level: \(selectedLevel)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(gameMessage.isEmpty ? "Attempts left: \(remainingAttempts)" : gameMessage)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(gameMessage.contains("won") ? .green : .white)

                    // ❤️ Attempts Indicator
                    let heartsPerRow = 5
                    VStack(spacing: 8) {
                        ForEach(0..<Int(ceil(Double(remainingAttempts) / Double(heartsPerRow))), id: \.self) { row in
                            HStack(spacing: 10) {
                                ForEach(0..<min(heartsPerRow, remainingAttempts - row * heartsPerRow), id: \.self) { _ in
                                    Image("heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                    }

                    // 🟦 Card Grid
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<totalBoxes, id: \.self) { index in
                            Button {
                                guard remainingAttempts > 0, !gameOver else { return }

                                let color = cardColor(index: index)

                                withAnimation(.linear(duration: 0.4)) {
                                    rotation[index] += 180
                                    revealed[index] = true
                                    remainingAttempts -= 1
                                    selectedColors.append(color)
                                }

                                let sameColorCount = selectedColors.filter { $0 == color }.count

                                // ✅ WIN
                                if sameColorCount == requiredMatchCount() {
                                    gameMessage = "🎉 Congratulations! You have won!"
                                    didWin = true
                                    gameOver = true
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.3)) {
                                           showResultBanner = true
                                       }
                                    return
                                }

                                // ❌ LOSE
                                if remainingAttempts == 0 {
                                    gameMessage = "❌ You lost the game. Better luck next time!"
                                    didWin = false
                                    gameOver = true
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                           showResultBanner = true
                                       }
                                }
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(cardColor(index: index))
                                        .frame(width: cardSize * 0.7, height: cardSize * 0.7)
                                        .cornerRadius(12)
                                        .opacity(revealed[index] ? 1 : 0)

                                    Image(cardImageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: cardSize * 0.9, height: cardSize * 0.9)
                                        .cornerRadius(12)
                                        .opacity(revealed[index] ? 0 : 1)
                                }
                                .rotation3DEffect(
                                    .degrees(rotation[index]),
                                    axis: (x: 0, y: 1, z: 0),
                                    perspective: 0.6
                                )
                                .shadow(radius: 3)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }

            // 🏆 WIN / LOSE OVERLAY (CORRECT PLACE)
            if gameOver {
                ZStack {
                    Color.black.opacity(showResultBanner ? 0.6 : 0)
                        .ignoresSafeArea()

                    if didWin {
                        Winbanner()
                            .scaleEffect(showResultBanner ? 1 : 0.8)
                            .opacity(showResultBanner ? 1 : 0)
                            .offset(y: showResultBanner ? 0 : 40)
                    } else {
                        Losebanner()
                            .scaleEffect(showResultBanner ? 1 : 0.8)
                            .opacity(showResultBanner ? 1 : 0)
                            .offset(y: showResultBanner ? 0 : 40)
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showResultBanner)
                .zIndex(10)
            }

        }
    }
}

#Preview {
    GameView(selectedLevel: "Medium")
}

