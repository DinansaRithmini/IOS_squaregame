import SwiftUI

// MARK: - COLOR GROUPS (FOR HARD MODE DIAGNOSIS)
enum ColorGroup {
    case red
    case blue
}

// MARK: - ENTRY VIEW
struct GameView: View {
    let selectedLevel: String

    var body: some View {
        switch selectedLevel {
        case "Easy":
            GameScreen(selectedLevel: selectedLevel, gridSize: 3, palette: easyColors)
        case "Medium":
            GameScreen(selectedLevel: selectedLevel, gridSize: 4, palette: mediumColors)
        default:
            GameScreen(selectedLevel: selectedLevel, gridSize: 5, palette: hardColors)
        }
    }
}

// MARK: - MAIN GAME SCREEN
struct GameScreen: View {

    let selectedLevel: String
    let gridSize: Int
    let palette: [Color]

    // Game State
    @State private var tiles: [Color] = []
    @State private var selectedIndexes: [Int] = []

    @State private var score: Int = 20
    @State private var attemptsUsed: Int = 0

    @State private var timeRemaining: Double = 30
    @State private var timer: Timer?

    // Result
    @State private var resultMessage: String = ""
    @State private var navigateToWin = false
    
    @State private var previousBestScore: Int = 0
    @State private var didImprove: Bool = false
    
    @State private var showInfo = false


    // HARD MODE GROUP SCORES
    @State private var groupScores: [ColorGroup: Int] = [
        .red: 0,
        .blue: 0
    ]

    // Attempts per level
    private var maxAttempts: Int {
        switch gridSize {
        case 3: return 3
        case 4: return 5
        default: return 8
        }
    }

    // MARK: - GRID SIZES (FROM FIGMA)
    private var tileSize: CGFloat {
        switch gridSize {
        case 3: return 90
        case 4: return 70
        default: return 60
        }
    }

    private var gridSpacing: CGFloat {
        switch gridSize {
        case 3: return 12
        case 4: return 10
        default: return 8
        }
    }

    private var gridDimension: CGFloat {
        CGFloat(gridSize) * tileSize +
        CGFloat(gridSize - 1) * gridSpacing
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.fixed(tileSize), spacing: gridSpacing),
            count: gridSize
        )
    }

    private var cornerRadius: CGFloat {
        gridSize == 5 ? 6 : 10
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("backgroun_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // 🔵 TOP RIGHT INFO BUTTON
                VStack {
                    HStack {
                        Spacer()

                        Button {
                            showInfo = true   // later you can show popup
                        } label: {
                            Image("info_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 44)
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 16)
                    }

                    Spacer()
                }

                
                VStack(spacing: 14) {
                    
                    Spacer()
                    
                    Image("poppy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                    
                    Image("pig_character")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140)
                    
                    Text(String(format: "Time remaining: %.2f", timeRemaining))
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.25))
                        .cornerRadius(12)
                        .offset(y: -110)
                    
                    Text("MATCH THREE CARDS\nWITH THE SAME COLOR")
                        .font(.custom("HoltwoodOneSC-Regular", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .offset(y: -120)
                    
                    // Score + Attempts (unchanged UI)
                    VStack(spacing: 8) {
                        
                        HStack(spacing: 6) {
                            Image("diamond")
                                .offset(y: -120)
                            Text("\(score)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                                .offset(y: -120)
                        }
                        
                        HStack(spacing: 6) {
                            ForEach(0..<maxAttempts, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(index < attemptsUsed ? Color.red : Color.pink.opacity(0.4))
                                    .frame(width: 42, height: 14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(.white, lineWidth: 1)
                                    )
                                    .offset(y: -120)
                            }
                        }
                        
                        Text("\(attemptsUsed)/\(maxAttempts) attempts have been used")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .offset(y: -120)
                    }
                    
                    // Grid
                    VStack {
                        LazyVGrid(columns: columns, spacing: gridSpacing) {
                            ForEach(tiles.indices, id: \.self) { index in
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .fill(tiles[index])
                                    .frame(width: tileSize, height: tileSize)
                                    .overlay(
                                        selectedIndexes.contains(index)
                                        ? RoundedRectangle(cornerRadius: cornerRadius)
                                            .stroke(.white, lineWidth: 3)
                                        : nil
                                    )
                                    .onTapGesture {
                                        tileTapped(index)
                                    }
                            }
                        }
                    }
                    .frame(width: gridDimension, height: gridDimension)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.black, lineWidth: 4)
                    )
                    .offset(y: -100)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .onAppear {
                setupTime()
                generateTiles()
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
            .overlay {
                if navigateToWin {
                    Winbanner(
                        selectedLevel: selectedLevel,
                        finalScore: score,
                        resultMessage: resultMessage,
                        previousBestScore: previousBestScore,
                        didImprove: didImprove,
                        onRetry: {
                            navigateToWin = false
                            attemptsUsed = 0
                            score = 20
                            generateTiles()
                            startTimer()
                        },
                        onPlayAgain: {
                            navigateToWin = false
                        }
                    )
                }
            }

            .overlay {
                if showInfo {
                    info {
                        showInfo = false
                    }
                }
            }

        }
    }


    // MARK: - TIMER
    private func setupTime() {
        switch gridSize {
        case 3: timeRemaining = 30
        case 4: timeRemaining = 40
        default: timeRemaining = 50
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            timeRemaining -= 0.01
            if timeRemaining <= 0 {
                timer?.invalidate()
                finishGame()
            }
        }
    }

    // MARK: - GAME LOGIC
    private func generateTiles() {
        let totalTiles = gridSize * gridSize
        let matchCount = gridSize

        let matchColor = palette.randomElement()!
        var tempTiles = Array(repeating: matchColor, count: matchCount)

        var index = 0
        while tempTiles.count < totalTiles {
            tempTiles.append(palette[index % palette.count])
            index += 1
        }

        tiles = tempTiles.shuffled()
        selectedIndexes.removeAll()
    }

    private func tileTapped(_ index: Int) {
        guard !selectedIndexes.contains(index) else { return }
        selectedIndexes.append(index)

        if selectedIndexes.count == gridSize {
            let colors = Set(selectedIndexes.map { tiles[$0] })

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                selectedIndexes.removeAll()

                if colors.count == 1 {
                    score += 10

                    if gridSize == 5 {
                        let group: ColorGroup = tiles[index].isRedLike ? .red : .blue
                        groupScores[group, default: 0] += 10
                    }

                    generateTiles()
                } else {
                    attemptsUsed += 1
                    if attemptsUsed >= maxAttempts {
                        finishGame()
                    }
                }
            }
        }
    }

    // MARK: - RESULT EVALUATION (UPDATED RULES)
    private func evaluateResult() {
        switch selectedLevel {

        case "Easy":
            resultMessage = score >= 30
            ? "Basic color recognition passed"
            : "Failed to recognize basic colors"

        case "Medium":
            resultMessage = score >= 40
            ? "No mild color confusion detected"
            : "Early signs of color-vision deficiency detected"

        default:
            let redScore = groupScores[.red] ?? 0
            let blueScore = groupScores[.blue] ?? 0

            let redLow = redScore < 20
            let blueLow = blueScore < 20

            if redLow && blueLow {
                resultMessage = "Possible combined Red–Green and Blue–Yellow color vision deficiency detected"
            } else if redLow {
                resultMessage = "Possible Red–Green color vision deficiency detected"
            } else if blueLow {
                resultMessage = "Possible Blue–Yellow color vision deficiency detected"
            } else {
                resultMessage = "No major color vision deficiency detected"
            }
        }
    }

    private func finishGame() {
        evaluateResult()

        let user = ScoreStore.shared
            .getUsername()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if !user.isEmpty {

            // 1️⃣ Get previous best score
            let oldBest = ScoreStore.shared.getBestScore(
                user: user,
                level: selectedLevel
            )

            // 2️⃣ Save if this is a new best
            let result = ScoreStore.shared.saveIfBest(
                user: user,
                level: selectedLevel,
                score: score
            )

            // 3️⃣ Update state for Winbanner
            previousBestScore = oldBest
            didImprove = score > oldBest && result.1 == score

        } else {
            // Safety fallback (should not happen because name is required)
            previousBestScore = 0
            didImprove = false
        }

        navigateToWin = true
    }

}

// MARK: - COLOR HELPER (VERY SIMPLE HEURISTIC)
extension Color {
    var isRedLike: Bool {
        UIColor(self).cgColor.components?.first ?? 0.0 > 0.6
    }
}

// MARK: - COLOR PALETTES
let easyColors: [Color] = [
    Color(red: 0.3, green: 0.8, blue: 0.3),
    Color(red: 0.4, green: 0.9, blue: 0.4),
    Color(red: 0.2, green: 0.7, blue: 0.3)
]

let mediumColors: [Color] = [
    Color(red: 0.0, green: 0.45, blue: 0.8),
    Color(red: 0.2, green: 0.6, blue: 0.9),
    Color(red: 0.0, green: 0.35, blue: 0.7)
]

let hardColors: [Color] = [
    Color(red: 0.8, green: 0.2, blue: 0.2),
    Color(red: 0.9, green: 0.4, blue: 0.3),
    Color(red: 0.7, green: 0.3, blue: 0.2)
]

// MARK: - PREVIEW
#Preview {
    GameView(selectedLevel: "Easy")
}

