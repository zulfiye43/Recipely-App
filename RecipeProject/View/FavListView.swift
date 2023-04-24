//
//  FavListView.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// eine View das zeigt eine Liste aller Lieblingsrezepte aus der Datenbank.
struct FavListView: View {
        
    @State var shouldRefresh: Bool = false
    @State var recipes: [Recipe] = DBHelper.fetchRecipesFromDB()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        NavigationView {
            VStack {
                
                // Navigation Title
                Text("Deine Lieblingsrezepte")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primaryColor)
                    .tracking(0.4)
                    .padding(.top, 16)
                
                 // Wenn keine Favoriten vorhanden sind (normalerweise Erstbenutzer), eine Nachricht anzeigen.
                if recipes.count == 0 {
                    VStack {
                        Spacer()
                        Image("plant").resizable().scaledToFill()
                            .frame(width: 150, height: 150, alignment: .center)
                        Text("Ihre Lieblingsrezepte werden hier angezeigt, sobald Sie mit dem Hinzufügen beginnen !")
                            .font(.subheadline)
                            .italic()
                            .padding()
                            .foregroundColor(.primaryDarkColor)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(20)
                }
     
                // Liste der Lieblingsrezeptkarten anzeigen.
                if recipes.count > 0 {
                    ScrollView(.vertical) {
                        VStack(spacing: 16) {
                            ForEach(self.recipes, id: \.self) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeSelected: recipe)) {
                                    RecipieRowCard(recipe: recipe) { isAdded in
                                        recipes = DBHelper.fetchRecipesFromDB()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                /// wichtig : Dadurch wird die Liste "aktualisiert", wenn der Benutzer ein Lieblingsrezept von der Startseite hinzufügt
                /// und kehrt zur Favoritenliste zurück
                recipes = DBHelper.fetchRecipesFromDB()
            }
        }
    }
    
}

// MARK: - FavListView Preview
struct FavListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FavListView(recipes: [
            Recipe(id: 0, title: "This test title 1", shortTitle: "",
                   description: "this is short description that will exceed some line. This can grow upto 2 lines at max before line start breaks." ,
                   imageName: "rezept_20", servings: 3, ratings: nil, steps: [],
                   isVegan: false, durationInMinutes: 20, calories: 123,
                   ingrediants: nil, cooksNote: "", nutritions: nil),
            
            Recipe(id: 0, title: "This test title 2" , shortTitle: "",
                   description: "this is short description.", imageName: "rezept_15",
                   servings: 3, ratings: nil, steps: [], isVegan: false,
                   durationInMinutes: 40, calories: 123, ingrediants: nil,
                   cooksNote: "", nutritions: nil)
        ])
        
      // Uncomment for No recipes view preview
      // FavListView(recipes: [])
        
    }
}
