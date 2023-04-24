//
//  RecipeDetailView.swift
//  RecipeProject
//
//  
//

import SwiftUI

/// Ansicht, die Details des Rezepts anzeigt, wenn der Benutzer auf Recipe Cards tippt (aus Liste oder Favoriten)
struct RecipeDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    var recipeSelected: Recipe
    
    var body: some View {
        
        ZStack(alignment: .top) {
            ScrollView {
                // Background image
                GeometryReader { reader in
                    Image(recipeSelected.imageName)
                        .resizable()
                        .scaledToFill()
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY < -500 ? 0 :   reader.frame(in: .global).minY + 500) 
                    
                }
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    // Zeile für Titel und Beschreibung.
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(recipeSelected.title).font(.title2).foregroundColor(.primaryDarkColor).bold()
                        HStack {
                            HStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.yellow)
                                    .frame(height: 16)
                                Text("\(recipeSelected.ratings?.average ?? "3") (\(recipeSelected.ratings?.totalRating ?? 50) Ratings)")
                                    .font(.footnote)
                                    .foregroundColor(.primaryDarkColor.opacity(0.85))
                                
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.footnote)
                                    .foregroundColor(.primaryDarkColor.opacity(0.85))
                                
                                Text("\(recipeSelected.durationInMinutes) Min")
                                    .font(.footnote)
                                    .foregroundColor(.primaryDarkColor.opacity(0.85))
                            }
                        }
                        
                    }.padding()
                    
                    separatorView
                    
                    // Zeile für Zutaten
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("ZUTATEN").font(.headline).foregroundColor(.black).bold()
                        
                        ForEach(recipeSelected.ingrediants ?? [], id: \.self) { ingrediant in
                            
                            HStack {
                                Text(ingrediant.name ?? "").font(.headline).foregroundColor(.primaryDarkColor)
                                Spacer()
                                
                                Text(ingrediant.quantity ?? "").font(.caption).foregroundColor(.white).bold().frame(minWidth: 80).padding(4)
                                    .background(Color.primaryColor).cornerRadius(8)
                                
                            }
                        }
                        
                    }.padding()
                    
                    separatorView
                    
                    // Reihe für Schritte
                    VStack(alignment: .leading, spacing: 8) {
                        
                        
                        HStack( spacing: 4) {
                            Text("SCHRITTE").font(.headline).foregroundColor(.black).bold()
                            
                            Spacer()
                            
                            Text("\(recipeSelected.servings) Servings")
                                .font(.footnote)
                                .foregroundColor(.primaryDarkColor.opacity(0.85))
                        }
                        
                        
                        ForEach(recipeSelected.steps, id: \.self) { step in
                            Text("• " + step).font(.subheadline).foregroundColor(.primaryDarkColor)
                        }.padding(.leading, 8)
                        
                        
                        
                    }.padding()
                    
                    separatorView
                    
                    // Zeile für Kalorien
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("NÄHRWERTE ").font(.headline).foregroundColor(.black).bold()
                        
                        ForEach(recipeSelected.nutritions ?? [], id: \.self) { nutri in
                            
                            HStack {
                                Text(nutri.name ?? "").font(.headline).foregroundColor(.primaryDarkColor)
                                
                                Spacer()
                                
                                Text("\(nutri.value ?? "") \(nutri.unit ?? "")").font(.caption).foregroundColor(.white).bold().frame(minWidth: 80).padding(4)
                                    .background(Color.primaryColor).cornerRadius(8)
                                
                            }
                            
                        }.padding(.leading, 8)
                        
                    }.padding()
                    
            
                }
                .background(Color.white)
                .cornerRadius(20)
                .offset(y: -35)
            }
            
            // Navigation Bar element - Zurück-Pfeil
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.primaryDarkColor)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        
    }
    
    // Ansicht der Trennlinie
    var separatorView: some View {
        // Trennlinie 2
        Rectangle().foregroundColor(.primaryDarkColor.opacity(0.33)).frame( height: 1).padding(.horizontal, 16)
    }
}

// MARK: - RecipeDetailView Preview
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipeSelected:
                            Recipe(id: 0, title: "Möhrenrisotto mit Walnüssen & Petersilienöl", shortTitle: "",
                                   description: "this is short description that will exceed some line. This can grow upto 2 lines at max before line start breaks." ,
                                   imageName: "rezept_20", servings: 3, ratings: nil, steps: ["Zwiebel schälen und würfeln", "Knoblauch schälen und reiben", "Sellerie in feine Scheiben schneiden", "Die Hälfte des Öls in einem großen Topf erhitzen.  Zwiebeln, Knoblauch und Sellerie hinzugeben und 1 Minute braten. Mit Salz würzen.", "Reis hinzugeben und 1 minute unter ständigem Rühren braten.", "Etwas Brühe hinzufügen und unter ständigem  Rühren köcheln lassen, bis die Flüssigkeit komplett aufgenommen ist.", "Nach und nach restliche Brühe hinzugeben und unter Rühren weitere 12 Minuten kochen, bis der Reis fast gar ist.", "In der Zwischenzeit Karotten waschen oder schälen und reiben.", "Anschließend Karotten zu dem fast gar gekochten Reis geben und weitere 2-3 Min köcheln lassen, bis der Reis cremig ist. Mit Salz würzen.", "In der Zwischenzeit Parmesan reiben.", "Wenn der Reis fertig ist, Parmesan und Butter hinzufügen, mischen und warm halten.", "Walnüsse hacken.", "Petersilie waschen, trocken schütteln und fein hacken.", "Restliches Öl in einer Schüssel mit Petersilie und Salz mischen.", "Risotto mit Petersilienöl und Walnüssen garnieren und genießen."],
                                   isVegan: false, durationInMinutes: 20, calories: 123,
                                   ingrediants: [
                                    Ingrediants(quantity: "1", name: "Speisezwiebel", type: "Speisezwiebel"),
                                    Ingrediants(quantity: "1", name: "Staudensellerie", type: "Staudensellerie"),
                                    Ingrediants(quantity: "15 g", name: "Petersillie", type: "Petersillie"),
                                    Ingrediants(quantity: "2", name: "Karotten", type: "Karotten"),
                                    Ingrediants(quantity: "40 g", name: "Walnusskerne", type: "Walnusskerne"),
                                    Ingrediants(quantity: "30 g", name: "Parmesan", type: "Parmesan"),
                                    Ingrediants(quantity: "160 g", name: "Risottoreis", type: "Risottoreis"),
                                    Ingrediants(quantity: "4 EL", name: "Olivenöl", type: "Olivenöl"),
                                    Ingrediants(quantity: "", name: "Salz", type: "Salz"),
                                    Ingrediants(quantity: "1 EL", name: "Butter", type: "Butter"),
                                    Ingrediants(quantity: "1 Zehe", name: "Knoblauch", type: "Knoblauch"),
                                    Ingrediants(quantity: "1/2 l", name: "Gemüsebrühe", type: "Gemüsebrühe")
                                   ], cooksNote: "", nutritions: [
                                    Nutritions(unit: "", name: "kcal", value: "787", percent: 16),
                                    Nutritions(unit: "g", name: "Eiweiß", value: "17", percent: 34),
                                    Nutritions(unit: "g", name: "Fett", value: "46", percent: 16)
                                   ]))
    }
}
