//
//  Userdefaults+Extension.swift
//  RecipeProject
//
//  
//

import Foundation

extension UserDefaults {
  var onboardingCompleted: Bool {
    get { return bool(forKey: #function) }
    set { set(newValue, forKey: #function) }
  }
}
