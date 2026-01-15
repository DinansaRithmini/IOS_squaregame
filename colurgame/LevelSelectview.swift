import SwiftUI

struct LevelSelectView: View {

    let levels = ["Easy", "Medium", "Hard"]

    var body: some View {
        NavigationStack {
            ZStack {

                
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 10) {

                    
                    ZStack {
                        Image("banner_image")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 580)
                            .frame(width: 780)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .offset(y:90)

                        Text("Select Level")
                            .font(.custom("Lexend-Regular", size: 30))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 3)
                            .offset(y:60)
                    }

                    
                    ZStack {
                        Text("Choose your difficulty")
                            .font(.custom("BalooBhaijaan-Regular", size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .offset(x: 1.9, y: -130)

                        Text("Choose your difficulty")
                            .font(.custom("BalooBhaijaan-Regular", size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(y: -130)
                    }

                    
                    VStack(spacing: -100) {
                        ForEach(levels, id: \.self) { level in
                            NavigationLink {
                                GameView(selectedLevel: level)
                            } label: {
                                Image(getImageName(for: level))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 420, height:200)
                                    .cornerRadius(14)
                                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                            }
                        }
                    }


                    Spacer()
                }
                .padding()
            }
        }
    }

    
    func getImageName(for level: String) -> String {
        switch level {
        case "Easy": return "easy_button"
        case "Medium": return "medium_button"
        case "Hard": return "hard_button"
        default: return "level_easy"
        }
    }
}

#Preview {
    LevelSelectView()
}

