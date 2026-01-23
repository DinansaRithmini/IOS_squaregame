import SwiftUI

struct LevelSelectView: View {

    let levels = ["Easy", "Medium", "Hard"]

    // Username state (persisted)
    @State private var username: String = ScoreStore.shared.getUsername()

    var body: some View {
        NavigationStack {
            ZStack {

                // Background
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 18) {

                    Spacer()

                    // Logo Image
                    Image("poppy_sees_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260)
                        .padding(.bottom, 10)

                    // Pig Character Image
                    Image("pig")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                        .padding(.bottom, 10)

                    // 👤 ENTER NAME
                    VStack(alignment: .leading, spacing: 6) {

                        Text("ENTER YOUR NAME")
                            .font(.custom("HoltwoodOneSC-Regular", size: 16))
                            .foregroundColor(.white)
                            .shadow(radius: 2)

                        TextField("Your name", text: $username)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(14)
                            .font(.body)
                            .onChange(of: username) { newValue in
                                ScoreStore.shared.saveUsername(
                                    newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                )
                            }
                    }
                    .frame(width: 300)
                    .padding(.bottom, 16)

                    // Select Your Level Text
                    Text("SELECT YOUR LEVEL")
                        .font(.custom("HoltwoodOneSC-Regular", size: 26))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 3)
                        .padding(.bottom, 10)

                    // Level Buttons
                    VStack(spacing: 14) {
                        ForEach(levels, id: \.self) { level in
                            NavigationLink {
                                GameView(selectedLevel: level)
                            } label: {
                                Image(getImageName(for: level))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 80)
                                    .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 3)
                                    .opacity(isNameValid ? 1 : 0.5)
                            }
                            .disabled(!isNameValid)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Helpers

    private var isNameValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // Button image mapper
    func getImageName(for level: String) -> String {
        switch level {
        case "Easy": return "easy_button"
        case "Medium": return "medium_buttton" // keep your asset name as-is
        case "Hard": return "hard_button"
        default: return ""
        }
    }
}

#Preview {
    LevelSelectView()
}

