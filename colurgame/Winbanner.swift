import SwiftUI

struct Winbanner: View {

    // MARK: - Inputs
    let selectedLevel: String
    let finalScore: Int
    let resultMessage: String
    let previousBestScore: Int
    let didImprove: Bool

    let onRetry: () -> Void
    let onPlayAgain: () -> Void

    // MARK: - UI
    var body: some View {
        ZStack {

            // 🔲 Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            // 🎴 Popup Card
            VStack(spacing: 14) {

                // GAME OVER image
                Image("game_over")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190)

                // Final Score
                Text("FINAL SCORE: \(finalScore)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                // ✅ IMPROVEMENT MESSAGE
                if didImprove {
                    Text("🎉 You have improved your sight!")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Previous best score
                if previousBestScore > 0 {
                    Text("Previous Best: \(previousBestScore)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }

                // Result message
                Text(resultMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                // Buttons (IMAGE BASED)
                VStack(spacing: 14) {

                    Button(action: onRetry) {
                        Image("try_again_button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                            .shadow(radius: 4)
                    }

                    Button(action: onPlayAgain) {
                        Image("play_again_button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 54)
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
            }
            .frame(width: 300, height: 420)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 254/255, green: 175/255, blue: 191/255), // #FEAFBF
                                Color(red: 231/255, green: 115/255, blue: 102/255)  // #E77366
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .shadow(radius: 20)
        }
    }
}

