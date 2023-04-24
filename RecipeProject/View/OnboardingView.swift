//
//  OnboardingView.swift
//  RecipeProject
//
//  
//

import SwiftUI

// View zeigt Onboarding-Infografiken, wenn die App zum ersten Mal vom Benutzer gestartet wird.
struct OnboardingView: View {
    
    @State private var slideGesture: CGSize = CGSize.zero
    @State private var curSlideIndex = 0
    @State private var isHomePresented = false
    
    private var distance: CGFloat = UIScreen.main.bounds.size.width
    
    private var pageDots: some View {
        
        HStack(spacing: 14.0){
            Circle().frame(width: OnboardingConstants.dotSize, alignment: .center)
                .foregroundColor(curSlideIndex == 0 ? Color.primaryColor : Color.red.opacity(0.4))
            
            Circle().frame(width: OnboardingConstants.dotSize, alignment: .center)
                .foregroundColor(curSlideIndex == 1 ? Color.primaryColor : Color.red.opacity(0.4))
            
            Circle().frame(width: OnboardingConstants.dotSize, alignment: .center)
                .foregroundColor(curSlideIndex == 2 ? Color.primaryColor : Color.red.opacity(0.4))
            
        }.frame(height: 100.0)
    }
    
    // Erster Schritt des Onboardings
    private var page1: some View {
        
        return VStack(spacing : 10) {
            Image("picc")
                .resizable()
                .scaledToFit()
            
            Text("Enjoy cooking")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Finden Sie köstliche und detaillierte Rezepte auf Ihrem Handy.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
            
        }.padding([.horizontal], 10)
    }
    
    /// Zweiter Schritt des Onboardings
    private var page2: some View {
        
        return VStack(spacing : 10) {
            Image("onboard_fav")
                .resizable()
                .scaledToFit()
            
            Text("Save your favourites")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Speichern Sie ganz einfach Ihre Lieblingsrezepte und lassen Sie sich daran erinnern, die Zutaten zu kaufen, um sie zu kochen.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
            
            
        }.padding([.horizontal], 10)
    }
    
    /// Third and Last Step of onboarding. Here You will see complete button.
    private var page3: some View {
        return VStack(spacing : 10) {
            Image("onboard_quiz")
                .resizable()
                .scaledToFit()
            
            Text("Diät- und Ernährungsquiz")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Nehmen Sie an unserem Quiz über gesunde Ernährung teil, um herauszufinden, wie viel Sie über Ernährung wissen.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
        }.padding([.horizontal], 10)
    }
    
    private var skipButton : some View {
        HStack{
            Spacer()
            Button(action: {
                UserDefaults.standard.onboardingCompleted = true
                isHomePresented.toggle()
            }) {
                HStack {
                    Text("Skip")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(Color(0x7F187D))
                }
            }
            .opacity( self.curSlideIndex == OnboardingConstants.maxSlides - 1 ? 0 : 1)
            .fullScreenCover(isPresented: $isHomePresented, onDismiss: nil, content: BaseView.init)
        }
    }
    
    var body: some View {
        
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // MARK: - Top header views
                HStack {
                    Spacer()
                    skipButton
                }
                
                Spacer()
                
                // MARK: - Onboarding body view
                ZStack(alignment: .center) {
                    ForEach(0..<OnboardingConstants.maxSlides) { i in
                        
                        ZStack {
                            
                            VStack(alignment: .center, spacing: 20) {
                                self.page1
                            }  .offset(x: CGFloat(0) * self.distance)
                            
                            
                            VStack(alignment: .center,  spacing: 20) {
                                self.page2
                            }  .offset(x: CGFloat(1) * self.distance)
                            
                            
                            VStack(alignment: .center,  spacing: 20) {
                                self.page3
                            }  .offset(x: CGFloat(2) * self.distance)
                            
                        }
                        .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                        .animation(.spring())
                        .gesture(DragGesture().onChanged{ value in
                            self.slideGesture = value.translation
                        }
                                    .onEnded{ value in
                            if self.slideGesture.width < -50 {
                                if self.curSlideIndex < OnboardingConstants.maxSlides - 1 {
                                    withAnimation {
                                        self.curSlideIndex += 1
                                    }
                                }
                            }
                            if self.slideGesture.width > 50 {
                                if self.curSlideIndex > 0 {
                                    withAnimation {
                                        self.curSlideIndex -= 1
                                    }
                                }
                            }
                            self.slideGesture = .zero
                        })
                    }
                }
                Spacer()
                
                // MARK: - Footer views
                pageDots
                
                ZStack {
                    
                    Button(action: {
                        UserDefaults.standard.onboardingCompleted = true
                        isHomePresented.toggle()
                    }) {
                        HStack {
                            Text("GET STARTED")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white)
                        }
                        
                    }
                    .padding()
                    .background(Color(0xFC4069))
                    .foregroundColor(Color.white)
                    .cornerRadius(.infinity)
                    .animation(.spring())
                    .offset(x: self.curSlideIndex == OnboardingConstants.maxSlides - 1 ? 0 : OnboardingConstants.slideOffset)
                    .fullScreenCover(isPresented: $isHomePresented, onDismiss: nil, content: BaseView.init)
                }
                
            } .padding(EdgeInsets.init(top: 20, leading: 20, bottom: 30, trailing: 20))
        }
    }
    
}

// MARK: - OnboardingConstants
struct OnboardingConstants {
    static let slideOffset:CGFloat = 500
    static let maxSlides = 3
    static var dotSize:CGFloat = 8.0
}

// MARK: - Preview OnboardingView
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
