import SwiftUI

struct Winbanner: View {

    var body: some View {
        NavigationStack {
            ZStack {

                // Background
                Image("win_lose_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: -42) {

                    // MARK: - Win Banner
                    ZStack {
                        Image("win_banner")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 480, height: 280)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .offset(y: 130)
                            .zIndex(9)

                        Image("background_tile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 480, height: 380)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .offset(y: 330)
                            .zIndex(2)

                        Text("Congratulations")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .offset(y: 230)
                            .zIndex(10)

                        Text("You have won the game")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .offset(y: 260)
                            .zIndex(10)
                    }

                    // MARK: - Back to Home Button
                    NavigationLink {
                        LevelSelectView()
                    } label: {
                        Image("back_to_home")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 250)
                            .cornerRadius(14)
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 4, x: 0, y: 1
                            )
                    }
                    .offset(y: 120)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    Winbanner()
}

