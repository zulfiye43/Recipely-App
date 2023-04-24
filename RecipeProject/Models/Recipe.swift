//
//  Recipe.swift
//  RecipeProject
//
//  
//

import Foundation

struct RecipeData : Codable {
    let module : Module?
    let recipes : [Recipe]?
}

struct Recipe: Codable, Identifiable, Hashable {
    
    let id : Int
    let title : String
    let shortTitle : String
    let description : String
    let imageName : String
    let servings : Int
    let ratings : Ratings?
    let steps : [String]
    let isVegan : Bool
    let durationInMinutes : Int
    let calories : Int
    let ingrediants : [Ingrediants]?
    let cooksNote : String
    let nutritions : [Nutritions]?
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct Nutritions : Codable, Hashable {
    let unit : String?
    let name : String?
    let value : String?
    let percent : Int?
}

struct Ingrediants : Codable, Hashable {
    let quantity : String?
    let name : String?
    let type : String?
}


struct Ratings : Codable, Hashable {
    let totalRating : Int?
    let average : String?
    let maxRating : String?
}

struct Module : Codable, Hashable {
    let version : String?
    let total : Int?
    let revision : String?
    
}

