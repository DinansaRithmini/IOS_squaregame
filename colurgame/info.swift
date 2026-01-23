import SwiftUI

struct info: View {

    let onClose: () -> Void

    var body: some View {
        ZStack {

            // Dim background
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 16) {

                // Title
                Text("GAME RULES")
                    .font(.custom("HoltwoodOneSC-Regular", size: 26))
                    .foregroundColor(.white)
                    .shadow(radius: 2)

                VStack(alignment: .leading, spacing: 12) {

                    RuleRow(text: "Match all highlighted cards with the same color.")
                    RuleRow(text: "Correct matches increase your score.")
                    RuleRow(text: "Wrong selections reduce available attempts.")
                    RuleRow(text: "Time and attempts vary by difficulty.")
                    RuleRow(text: "Finish before time runs out to pass.")

                }
                .padding(.horizontal)

                Button(action: onClose) {
                    Text("CLOSE")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .foregroundColor(.black)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
            }
            .frame(width: 300, height: 420) // SAME SIZE AS WIN POPUP
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 254/255, green: 175/255, blue: 191/255),
                                Color(red: 231/255, green: 115/255, blue: 102/255)
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

struct RuleRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.title3)
                .foregroundColor(.white)
            Text(text)
                .foregroundColor(.white)
                .font(.body)
        }
    }
}

