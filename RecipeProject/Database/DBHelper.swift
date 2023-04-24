//
//  DBHelper.swift
//  RecipeProject
//
//  
//

import RealmSwift

/// Hilfsklasse für die Datenbankooperation.
class DBHelper {
    
    /// Fügt ein Rezept in die Tabelle ein
    /// - Parameters:
    ///   - item: Rezept wird hinzugefügt
    ///   - completion: Status wird wahr sein, wenn das Rezept hinzugefügt wird
    static func addFavRecipe(_ item: Recipe,  completion: @escaping (_ status: Bool) -> Void) {
        let realm = try! Realm()
        
        try! realm.write {
            
            // Überprüfen, ob es bereits als Favorit markiert wurde
            let result = realm.objects(RecipeDB.self).filter({ $0.id == item.id})
            if result.count < 1 {
                let recipieRecord = RecipeDB()
                recipieRecord.id = item.id
                recipieRecord.title = item.title
                recipieRecord.imageName = item.imageName
                realm.add(recipieRecord)
            }
            completion(true)            
        }
    }
    
    /// Rezept aus Tabelle löschen
    /// - Parameters:
    ///   - item: Rezept wird gelöscht
    ///   - completion: Gibt true zurück, wenn erfolgreich gelöscht.
    static func removeFavRecipe(_ item: Recipe, completion: @escaping (_ status: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            let result = realm.objects(RecipeDB.self).filter({ $0.id == item.id})
            realm.delete(result)
            completion(true)
        }
       
    }
    
    /// Überprüft, ob ein Rezept als Favorit markiert ist oder nicht.
    /// - Parameters:
    ///   - item: Rezept zu überprüfen
    ///   - completion: return `true` wenn schon Favorit.
    static func isMarkedFavourite(_ item: Recipe, completion: @escaping (_ status: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            let result = realm.objects(RecipeDB.self).filter({ $0.id == item.id})
            completion(result.count > 0)
        }
    }
    
    /// Holt alle Lieblingsrezepte von Tabelle
    /// - Returns: Eine Reihe von Rezepten, die als Favorit hinzugefügt wurden
    static func fetchRecipesFromDB() -> [Recipe] {
        let realm = try! Realm()
        let list = realm.objects(RecipeDB.self)
        var recipeResult = [Recipe]()
        let recipies = Utils.loadAllRecipies()

        list.forEach { recipieRecord in
            if let recipie = recipies.filter({ $0.id == recipieRecord.id }).first {
            recipeResult.append(recipie)
            }
        }
        return recipeResult
    }
}
