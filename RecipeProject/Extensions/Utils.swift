//
//  Utilities.swift
//  RecipeProject
//
//  
//

import Foundation

struct Utils {
    
    static func readJSONFromFile(fileName: String) -> Any? {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Abrufen von Daten aus einer JSON-Datei mithilfe der Datei-URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // hier werden Fehler behandelt
            }
        }
        return json
    }
    
    static func parse<T: Codable>(_ model: T.Type,
                                  from apiResponse: [AnyHashable: Any]) -> T? {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: apiResponse, options: .prettyPrinted) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(model.self, from: jsonData)
            }
            catch let error {
                print("Parsing Error : \(error)")
            }
        }
        return nil
    }
    
    /// Lesen von  Rezept-Json-Datei aus dem lokalen
    /// - Returns: Array of Recipes
    static func loadAllRecipies() -> [Recipe] {
        if let response = Utils.readJSONFromFile(fileName: "recipes_data") as? [AnyHashable: Any],
           let recipesData = Utils.parse(RecipeData.self, from: response) {
            return recipesData.recipes ?? []
        }
        return []
    }
    
    /// Lesen Sie das Quiz json aus dem lokalen
    /// - Returns: Array of Questions
    static func loadAllQuestions() -> [Questions] {
        if let response = Utils.readJSONFromFile(fileName: "nutrition_quiz_data") as? [AnyHashable: Any],
           let recipesData = Utils.parse(QuizData.self, from: response) {
            return recipesData.questions ?? []
        }
        return []
    }
    
}
