import SwiftUI

struct GameView: View {

    let selectedLevel: String

    // MARK: - Attempts

    var maxAttempts: Int {
        switch selectedLevel {
        case "Easy": return 5
        case "Medium": return 7
        case "Hard": return 9
        default: return 5
        }
    }

    var SelectLeveltext: String {
        switch selectedLevel {
        case "Easy": return "You have 5 attempts to select a tile"
        case "Medium": return "You have 7 attempts to select a tile"
        case "Hard": return "You have 9 attempts to select a tile"
        default: return "You have 5 attempts to select a tile"
        }
    }

    // MARK: - Grid Settings

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

    // MARK: - Init

    init(selectedLevel: String) {
        self.selectedLevel = selectedLevel

        let size: Int
        let attempts: Int

        switch selectedLevel {
        case "Easy":
            size = 3
            attempts = 5
        case "Medium":
            size = 4
            attempts = 7
        case "Hard":
            size = 5
            attempts = 9
        default:
            size = 3
            attempts = 5
        }

        _revealed = State(initialValue: Array(repeating: false, count: size * size))
        _rotation = State(initialValue: Array(repeating: 0, count: size * size))
        _remainingAttempts = State(initialValue: attempts)
    }

    // MARK: - Card Assets

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
        case "Easy":
            return [.red, .green, .blue][index % 3]
        case "Medium":
            return [.orange, .pink, .purple, .teal][index % 4]
        case "Hard":
            return [.mint, .cyan, .indigo, .brown, .green][index % 5]
        default:
            return .gray
        }
    }

    // MARK: - View

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

                    Text(SelectLeveltext)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // ❤️ Hearts in a ROW
                    HStack(spacing: 10) {
                        ForEach(0..<remainingAttempts, id: \.self) { _ in
                            Image("heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.vertical, 8)

                    // 🟦 Cards Grid
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(0..<totalBoxes, id: \.self) { index in
                            Button {
                                guard remainingAttempts > 0 else { return }

                                withAnimation(.linear(duration: 0.4)) {
                                    rotation[index] += 180
                                    revealed[index].toggle()
                                    remainingAttempts -= 1
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
        }
    }
}

#Preview {
    GameView(selectedLevel: "Hard")
}

