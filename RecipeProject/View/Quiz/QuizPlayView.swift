//
//  QuizPlayView.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// View  zeigt Fragen und Antwortoptionen an. Diese Ansicht wird für alle Fragen bis zur letzten Frage wiederverwendet.
struct QuizPlayView: View {
    
    @State private var currentProgressIndex = 0
    @State private var isResultView: Bool = false
    @State private var currentScore: Int = 0
    @State private var quizProgress: Float = 0.1
    @State private var selectedAnsIndex: Int = -1
    @Environment(\.presentationMode) private var presentationMode
    
    private var questionsSet = Utils.loadAllQuestions()
    
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
                                Image(systemName: "arrow.backward").foregroundColor(.white).font(.title2)
                            }
                            Spacer()
                        }
                        
                        // Kopfzeile (Fortschritt).
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Question \(currentProgressIndex + 1) / \(questionsSet.count) ").foregroundColor(.white).bold()
                            
                            ProgressBar(value: $quizProgress ).frame(height: 4)
                        }
                        
                        // Kombination aus Frage und Antwort (scrollbarer Teil)
                        ZStack {
                            
                            VStack {
                                
                                ScrollView(.vertical) {
                                    
                                    // Fragenbereich
                                    HStack {
                                        Text("\(questionsSet[$currentProgressIndex.wrappedValue].question ?? "")")
                                            .foregroundColor(.primaryDarkColor)
                                            .bold()
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 16)
                                    
                                    // Antwortbereich
                                    VStack(spacing: 16) {
                                        ForEach(Array((questionsSet[$currentProgressIndex.wrappedValue].answers ).enumerated()), id: \.offset) { (index, ans) in
                                            
                                            OptionRowCard(answer: ans)
                                                .background(selectedAnsIndex == index ? Color.primaryColor : Color.primaryDarkColor.opacity(0.75))
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.25)) {
                                                        selectedAnsIndex = index
                                                    }
                                                    let totalQuestion = questionsSet.count
                                                    let expectedAnwerIndex = (questionsSet[$currentProgressIndex.wrappedValue].correct_answer ?? 1) - 1
                                                    let anwerRowTag = index
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        
                                                        // Antwort bestätigen
                                                        if expectedAnwerIndex == anwerRowTag {
                                                            currentScore += 1
                                                        }
                                                        
                                                        // zur nächsten Frage oder Ergebnisseite gehen.
                                                        if currentProgressIndex < totalQuestion - 1 {
                                                            selectedAnsIndex = -1
                                                            $currentProgressIndex.wrappedValue += 1
                                                            $quizProgress.wrappedValue = Float(currentProgressIndex + 1) / Float(totalQuestion)
                                                        } else {
                                                            isResultView.toggle()
                                                        }
                                                    }
                                                }
                                            
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
                                }.padding()
                            }
                            .background(Rectangle().foregroundColor(Color.white))
                            .cornerRadius(8)
                            .shadow(radius: 8)
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            .padding(.horizontal, 18)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isResultView,
                             onDismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }, content: {
                QuizResultView(totalScore: $currentScore.wrappedValue, totalQuestion: questionsSet.count)
            })
            
        }
    }
    
}

// MARK: - OptionRowCard implementation
struct OptionRowCard: View {
    var answer: String
    
    var body: some View {
        HStack {
            Text(answer)
                .bold()
                .foregroundColor(.white)
                .lineLimit(10)
                .padding(16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}

// MARK: - ProgressBar implementation
struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.primaryColor)
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.white)
                    .animation(.linear)
            }.cornerRadius(.infinity)
        }
    }
}
