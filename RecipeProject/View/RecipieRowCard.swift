//
//  RecipieRowCard.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// View für Rezeptzeilen in der Liste
struct RecipieRowCard: View {
    
    var recipe: Recipe
    var onFavChange: (_ isAdded: Bool) -> Void
    @State var isFavMarked: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
            
            Rectangle()                         // Formen sind standardmäßig in der Größe veränderbar
                .foregroundColor(.clear)        // Rechteck transparent machen
                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            
            
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    Image(systemName: isFavMarked ? "heart.fill" : "heart")
                        .padding(5)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    
                    if isFavMarked {
                        // Favorit entfernen, wenn gespeichert
                        DBHelper.removeFavRecipe(recipe, completion: { _ in
                            isFavMarked = false
                            onFavChange(false)
                        })
                    } else {
                        // Favorit speichern, wenn nicht markiert
                        DBHelper.addFavRecipe(recipe) { status in
                            isFavMarked = true
                            onFavChange(true)
                        }
                    }
                }
                 
                Spacer()
                
                CardTitle(titleText: recipe.title)
                
                HStack {
                    Text("\(recipe.description)")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.85))
                    Spacer()
                }
                
                HStack {
                    
                    StarsView(rating: Float(recipe.ratings?.average ?? "0.0") ?? 0.0, maxRating: 5)
                        .frame(height: 16)
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.85))
                        
                        Text("\(recipe.durationInMinutes) Min")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                }
            }
            .padding(16)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .onAppear {
            // Entscheidet, ob das Favoritensymbol gefüllt ist oder nicht.
            DBHelper.isMarkedFavourite(recipe, completion: { status in
                isFavMarked = status
            })
        }
    }
}

// MARK: - CardTitle implementaiton
struct CardTitle: View {
   var titleText: String
   var body: some View {
       Text(titleText)
           .font(.title2)
           .tracking(0.36)
           .foregroundColor(.white)
   }
   
}

// MARK: - StarsView implementation
struct StarsView: View {
   var rating: Float
   var maxRating: Int
   
   var body: some View {
       let stars = HStack(spacing: 0) {
           ForEach(0..<maxRating) { _ in
               Image(systemName: "star.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
           }
       }
       
       stars.overlay(
           GeometryReader { g in
               let width = CGFloat(rating / Float(maxRating)) * g.size.width
               ZStack(alignment: .leading) {
                   Rectangle()
                       .frame(width: width)
                       .foregroundColor(.yellow)
               }
           }
               .mask(stars)
       )
           .foregroundColor(.gray)
   }
}
