//
//  QuizView.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// Standardseite, wenn der Benutzer auf das  Profile Tab icon tippt
struct QuizLandingView: View {
    
    @State private var isQuizPlayPresented = false
    
    var body: some View {
        
        VStack {
            
            // Title of the navigation page
            Text("Diet & Nutrition Quiz")
                .font(.title3)
                .bold()
                .foregroundColor(.primaryColor)
                .tracking(0.4)
                .padding(.top, 16)
            
            Spacer()
            
            // In der Mitte der Seite wird die Illustration und die Beschreibung angzeigt
            VStack(spacing: 24) {
                Image("onboard_quiz")
                    .resizable()
                    .scaledToFit()
                
                Text("Nehmen Sie an unserem Quiz über gesunde Ernährung teil, um herauszufinden, wie viel Sie über Ernährung wissen.")
                    .font(.subheadline)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primaryDarkColor)
            }.padding([.horizontal], 32)
            
            // Button zum Starten der Seite mit den Quizfragen.
            HStack {
                Button(action: {
                    isQuizPlayPresented.toggle()
                }) {
                    
                    HStack {
                        Text("GET STARTED")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .tracking(0.4)
                            .foregroundColor(Color.white)
                    }
                    
                }
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(.infinity)
                .fullScreenCover(isPresented: $isQuizPlayPresented, onDismiss: nil, content: QuizPlayView.init)
                
            }
            .padding(.vertical, 30)
            
            Spacer()
            
        }
    }
}

// MARK: -  Preview QuizLandingView
struct QuizLandingView_Previews: PreviewProvider {
    static var previews: some View {
        QuizLandingView()
    }
}
