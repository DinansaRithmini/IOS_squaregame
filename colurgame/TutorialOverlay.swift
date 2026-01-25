import SwiftUI
struct TutorialOverlay: View {
    
    let steps:[ TutorialStep]
    @Binding var isShowing: Bool
    
    
    @State private var currentStep = 0
    
    var body: some View {
        if isShowing{
            ZStack{Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                VStack(spacing:16)
                {
                    Text(steps[currentStep].title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(steps[currentStep].description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Button(action: nextStep){
                        Text(currentStep == steps.count - 1 ? " Got it! " : " Next")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.blue)
                    .cornerRadius(20)
                    .padding(40)
                
            }
        }
    }
    private func nextStep()
    {
        if currentStep < steps.count - 1 {
            currentStep += 1
            
        }
        else {
            isShowing = false
        }
                    }
                
        }
    

//  TutorialOverlay.swift
//  colurgame
//
//  Created by  Dinansa Rithmini  on 2026-01-25.
//

