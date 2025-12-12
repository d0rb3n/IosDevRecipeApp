//
//  CategoryMeals.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 08.12.2025.
//

import Foundation

struct CategoryMealsResponse: Codable {
    let meals: [CategoryMeals]?
}

struct CategoryMeals: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
