//
//  CardView.swift
//  RecipeProject
//
//  
//


import SwiftUI


/// Card of Recipe in HomeView
struct CardView: View {
    
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    
    private var recipe: Recipe
    private var onRemove: (_ user: Recipe) -> Void
    private var onAdd: (_ user: Recipe) -> Void
    private var thresholdPercentage: CGFloat = 0.5 // wenn der Benutzer 50 % der Breite des Bildschirms in eine Richtung gezogen hat
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    init(recipe: Recipe, onRemove: @escaping (_ user: Recipe) -> Void, onAdd:  @escaping (_ user: Recipe) -> Void) {
        self.recipe = recipe
        self.onRemove = onRemove
        self.onAdd = onAdd
    }
    
    /// Wie viel Prozent unserer eigenen Breite haben wir gewischt
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: Der aktuelle Gestenübersetzungswert
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: self.swipeStatus == .like ? .topLeading : .topTrailing) {
                    
                    if self.swipeStatus == .like {
                        
                        Text("FAVE")
                            .font(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color(0x0B4619))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(0x0B4619), lineWidth: 3.0)
                            ).padding(24)
                            .rotationEffect(Angle.degrees(-45))
                        
                        
                    } else if self.swipeStatus == .dislike {
                        Text("NOPE")
                            .font(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 3.0)
                            ).padding(.top, 45)
                            .rotationEffect(Angle.degrees(45))
                    }
                    
                    // innerhalb der Karte - unterer Teil
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            CardTitle(titleText: self.recipe.title)
                            
                            HStack {
                                StarsView(rating: Float(recipe.ratings?.average ?? "0.0") ?? 0.0, maxRating: 5).frame(height: 16)
                                Spacer()
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.footnote)
                                        .foregroundColor(.white.opacity(0.85))
                                    
                                    Text("\(self.recipe.durationInMinutes) Min")
                                        .font(.footnote)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                            }
                            
                        }
                        .padding()
                        .background(Color.black.opacity(0.4))
                        
                        
                    }
                }.background(Image(self.recipe.imageName)
                                .resizable()
                                .scaledToFill())
                
                
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        
                        if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                            self.swipeStatus = .like
                        } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                            self.swipeStatus = .dislike
                        } else {
                            self.swipeStatus = .none
                        }
                        
                    }.onEnded { value in
                        // Bestimmt den Fangabstand > 0,5 aka die halbe Bildschirmbreite
                        if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                            
                            self.swipeStatus == .dislike ? self.onRemove(self.recipe) : self.onAdd(self.recipe)
                            
                        } else {
                            self.translation = .zero
                        }
                    }
                
            )
        }
    }
}

// MARK: - HomeView Preview
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

