//
//  HomeView.swift
//  RecipeProject
//
//  

import SwiftUI
import RealmSwift

/// Home view ist eine Standardansicht, die angezeigt wird, wenn der Benutzer die App öffnet. Dies hat das Tinder-Swipe-System
struct HomeView: View {
    
    /// Liste von Rezepten
    @State var recipes: [Recipe] = Utils.loadAllRecipies()
    @State private var isAllRecipePresented = false
    
    
    /// Gibt die CardViews-Breite für den angegebenen offset im Array zurück
    /// - Parameters:
    ///   - geometry: Der Geometrie-Proxy des Elternteils
    ///   - id: Die ID des aktuellen Benutzers
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(recipes.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    /// Gibt den CardViews-Frame-Offset für den angegebenen Offset im Array zurück
    /// - Parameters:
    ///   - geometry: Der Geometrie-Proxy des Elternteils
    ///   - id: Die ID des aktuellen Benutzers
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(recipes.count - 1 - id) * 10
    }
    
    private var maxID: Int {
        return self.recipes.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    // Top gradiant background der Seite.
                    LinearGradient(gradient: Gradient(colors: [Color.primaryColor, Color.primaryLightColor, Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
                        .frame(width: geometry.size.width * 1.5, height: geometry.size.height)
                        .clipShape(Circle())
                        .offset(x: -geometry.size.width / 4, y: -geometry.size.height / 2)
                    
                    VStack(alignment: .leading) {
                        
                        // Title text der seite
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Hello,")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .tracking(0.4)
                                Text("es ist Zeit fürs swipen !")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                    .tracking(0.4)
                                
                            }
                            Spacer()
                        }
                        .padding()
                        
                        // Stack View für Tinder Cards beginnt hier.
                        VStack {
                            
                            HStack {
                                
                                Spacer()
                                
                                // View all öffnet Alle Rezepte in der Listenansicht
                                Button(action: {
                                    isAllRecipePresented.toggle()
                                }) {
                                    
                                    HStack {
                                        Text("View All")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.white)
                                        
                                    }
                                    
                                }
                                .fullScreenCover(isPresented: $isAllRecipePresented, onDismiss: nil, content: AllRecipeListView.init)
                                
                            }
                            
                            ZStack {
                                // Rezeptkartenstapel wie tinder
                                
                                ForEach(self.recipes, id: \.self) { recipe in
                                    
                                    NavigationLink(destination: RecipeDetailView(recipeSelected: recipe)) {
                                        Group {
                                            // Range Operator
                                            if (self.maxID - 3)...self.maxID ~= recipe.id {
                                                CardView(recipe: recipe, onRemove: { removeRecipe in
                                                    // Remove that recipe from our array
                                                    self.recipes.removeAll { $0.id == removeRecipe.id }
                                                    
                                                }, onAdd: { addRecipe in
                                                    // macht einen Zugang zu Realm db
                                                    DBHelper.addFavRecipe(addRecipe) { _ in
                                                        // do nothing.
                                                    } 
                                                    self.recipes.removeAll { $0.id == addRecipe.id }
                                                    
                                                }).animation(.spring())
                                                    .frame(width: geometry.size.width , height: 440)
                                                    .offset(x: geometry.size.width - self.getCardWidth(geometry, id: recipe.id), y: self.getCardOffset(geometry, id: recipe.id))
                                                
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            // View wird angezeigt, wenn alle Karten vom Benutzer durchgezogen wurden.
                            if recipes.count == 0 {
                                VStack {
                                    Spacer()
                                    Image("plant").resizable().scaledToFill()
                                        .frame(width: 150, height: 150, alignment: .center)
                                    Text("Tap on refresh to revisit all the recipes")
                                        .font(.subheadline)
                                        .italic()
                                        .padding()
                                        .foregroundColor(.primaryDarkColor)
                                        .multilineTextAlignment(.center)
                                    Button(action: {
                                        recipes = Utils.loadAllRecipies()
                                    }) {
                                        
                                        HStack {
                                            Text("REFRESH")
                                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                    .padding()
                                    .background(Color.primaryColor)
                                    .cornerRadius(.infinity)
                                    Spacer()
                                }
                                .padding(20)
                            }
                            
                        } // Stapel von Tinderkarten endet.
                        
                    }
                    
                }
                .padding()
            }.navigationBarHidden(true)
        }
    }
}

// MARK: - HomeView Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


