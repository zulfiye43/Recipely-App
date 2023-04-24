//
//  Quiz.swift
//  RecipeProject
//
//  
//

import Foundation

struct QuizData : Codable {
    let module : QuizModule?
    let questions : [Questions]?
}

struct Questions : Codable {
    let number : Int?
    let question : String?
    var answers : [String]
    let correct_answer : Int?
}

struct QuizModule : Codable {
    let version : String?
    let name : String?
    let questions : Int?
    let revision : String?
}
