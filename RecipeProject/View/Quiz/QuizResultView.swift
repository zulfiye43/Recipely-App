//
//  QuizResultView.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// Endgültige Ergebnisseite, nachdem alle Fragen abgeschlossen sind.
struct QuizResultView: View {
    
    var totalScore: Int
    var totalQuestion: Int
    
    @Environment(\.presentationMode) private var presentationMode
    @State var progressValue: Float = 0.28
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    
                    LinearGradient(gradient: Gradient(colors: [Color.primaryColor, Color.primaryLightColor, Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
                        .frame(width: geometry.size.width * 2, height: geometry.size.height)
                        .clipShape(Circle())
                        .offset(x: -geometry.size.width / 2, y: -geometry.size.height / 2)
                    
                    VStack(spacing: 18) {
                        
                        // Navigation Bar
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "multiply").foregroundColor(.white).font(.title)
                            }
                            Spacer()
                            
                        }
                        .padding()
                        
                        Text("Congratulations!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .tracking(0.4)
                        
                        
                        VStack {
                            Image("quiz_result")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(.infinity)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 5) {
                            
                            ZStack {
                                VStack {
                                    Text("You Scored")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.primaryColor)
                                        .tracking(0.4)
                                    Text("\(totalScore)/\(totalQuestion)")
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.primaryDarkColor)
                                        .tracking(0.4)
                                    
                                }
                                CircularProgressBar(progress: $progressValue)
                                
                            }
                            Spacer()
                            
                        }
                        
                        
                        HStack {
                            // Ergebnisseite verlassen und zu QuizLandingView zurückgehen.
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                
                                HStack {
                                    Text("COMPLETE")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                        .tracking(0.4)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            .padding()
                            .background(Color.primaryColor)
                            .cornerRadius(.infinity)
                            
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Aktualisierung der Fortschrittsprozentsatz, wenn das Quizergebnis angezeigt wird.
                $progressValue.wrappedValue = Float(totalScore) / Float(totalQuestion)
            }
            
        }
    }
}

// MARK: - Preview QuizResultView
struct QuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultView(totalScore: 8, totalQuestion: 10)
    }
}

// MARK: - CircularProgressBar implementation
struct CircularProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.primaryColor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.primaryColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            
        }.padding(40)
    }
}
