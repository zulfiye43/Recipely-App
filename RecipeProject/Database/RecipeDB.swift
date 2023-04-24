//
//  RecipeDB.swift
//  RecipeProject
//
//  
//

import SwiftUI
import RealmSwift
 
//rezepte werden in Realm gespeichert
class RecipeDB: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var imageName = ""
    @objc dynamic var occupation = ""
}

