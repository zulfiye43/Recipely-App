//
//  AllRecipeListView.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// View  zeigt alle Rezepte in einer Liste an.
struct AllRecipeListView: View {
    
    @State private var refresh = false
    @State private var selectedRecipe: Recipe? = nil
    @State var recipes: [Recipe] = Utils.loadAllRecipies()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Stapel für Navigation bar, enthält die Schaltfläche mit dem Zurück-Pfeil und den Titel.
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward").foregroundColor(.primaryColor).font(.title2)
                    }
                    
                    Text("Alle Rezepte")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .tracking(0.4)
                    
                    Spacer()
                    
                }
                .padding()
                
                // Liste der Rezepte aus der Datenquelle.
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        ForEach(self.recipes, id: \.self) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipeSelected: recipe)) {
                                RecipieRowCard(recipe: recipe) { isAdded in
                                    print("Called with \(isAdded)")
                                    self.recipes = Utils.loadAllRecipies()
                                }
                            }
                        }
                    }
                }
                
                
            }
            .navigationBarHidden(true)
            
        }
        .onAppear {
            // man lädt die Rezepte zusammen mit dem Favoritenmarkierungsstatus beim öffnen neu.
            recipes = Utils.loadAllRecipies()
        }
        
    }
    
}

// MARK: - AllRecipeListView Preview
struct AllRecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        AllRecipeListView()
    }
}
